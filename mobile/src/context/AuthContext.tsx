import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { api } from '@/api/client';
import { clearSavedUser, clearToken, getToken, setSavedUser, setToken } from '@/api/storage';
import type { User } from '@/types';

/**
 * Auth state — replaces the @Observable SavedUser class and the ContentView token check.
 * Persists the user to AsyncStorage on every change (mirrors SavedUser.didSet).
 */

interface AuthContextValue {
  user: User | null;
  isLoggedIn: boolean;
  isBootstrapping: boolean;
  /** Store token + user after a successful login. */
  signIn: (user: User, token: string) => Promise<void>;
  signOut: () => Promise<void>;
  /** Replace the current user and persist (mirrors SavedUser.user = ...). */
  setUser: (user: User) => Promise<void>;
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUserState] = useState<User | null>(null);
  const [isBootstrapping, setIsBootstrapping] = useState(true);

  // ContentView.checkLoginStatus: if a token exists, fetch the profile to validate it.
  useEffect(() => {
    (async () => {
      try {
        const token = await getToken();
        if (!token) return;
        const profile = await api.get<User>('/users/profile', { auth: true });
        setUserState(profile);
        await setSavedUser(profile);
      } catch {
        await clearToken();
        await clearSavedUser();
        setUserState(null);
      } finally {
        setIsBootstrapping(false);
      }
    })();
  }, []);

  const signIn = useCallback(async (u: User, token: string) => {
    await setToken(token);
    await setSavedUser(u);
    setUserState(u);
  }, []);

  const signOut = useCallback(async () => {
    await clearToken();
    await clearSavedUser();
    setUserState(null);
  }, []);

  const setUser = useCallback(async (u: User) => {
    setUserState(u);
    await setSavedUser(u);
  }, []);

  const value = useMemo<AuthContextValue>(
    () => ({ user, isLoggedIn: user !== null, isBootstrapping, signIn, signOut, setUser }),
    [user, isBootstrapping, signIn, signOut, setUser],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within an AuthProvider');
  return ctx;
}
