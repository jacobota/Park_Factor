import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { supabase } from '@/api/supabaseClient';
import { fetchProfile } from '@/api/auth';
import { clearSavedUser, clearToken, setSavedUser, setToken } from '@/api/storage';
import type { User } from '@/types';

/**
 * Auth state, backed by the Supabase session. supabase-js persists/refreshes the session in
 * AsyncStorage; we mirror the access token into our storage so any remaining Express/Flask calls
 * can still send a Bearer header. The signIn/signOut/setUser surface is unchanged so the auth
 * screens and onboarding flow keep working.
 */

interface AuthContextValue {
  user: User | null;
  isLoggedIn: boolean;
  isBootstrapping: boolean;
  /** Store user (+ token) after a successful login/onboarding. */
  signIn: (user: User, token: string) => Promise<void>;
  signOut: () => Promise<void>;
  /** Replace the current user and persist. */
  setUser: (user: User) => Promise<void>;
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUserState] = useState<User | null>(null);
  const [isBootstrapping, setIsBootstrapping] = useState(true);

  useEffect(() => {
    let active = true;

    // Restore an existing session on launch.
    (async () => {
      try {
        const { data } = await supabase.auth.getSession();
        if (data.session) {
          await setToken(data.session.access_token);
          const profile = await fetchProfile();
          if (active) {
            setUserState(profile);
            await setSavedUser(profile);
          }
        }
      } catch {
        /* no valid session — stay logged out */
      } finally {
        if (active) setIsBootstrapping(false);
      }
    })();

    // Keep the mirrored token fresh; clear everything on sign-out.
    const { data: sub } = supabase.auth.onAuthStateChange(async (_event, session) => {
      if (session) {
        await setToken(session.access_token);
      } else {
        await clearToken();
        await clearSavedUser();
        if (active) setUserState(null);
      }
    });

    return () => {
      active = false;
      sub.subscription.unsubscribe();
    };
  }, []);

  const signIn = useCallback(async (u: User, token: string) => {
    if (token) await setToken(token);
    await setSavedUser(u);
    setUserState(u);
  }, []);

  const signOut = useCallback(async () => {
    await supabase.auth.signOut();
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
