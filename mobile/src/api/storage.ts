import AsyncStorage from '@react-native-async-storage/async-storage';
import type { User } from '@/types';

/** Persistent storage — replaces @AppStorage("accessToken") and the SavedUser/UserDefaults class. */

const TOKEN_KEY = 'accessToken';
const USER_KEY = 'User';

export const getToken = () => AsyncStorage.getItem(TOKEN_KEY);
export const setToken = (token: string) => AsyncStorage.setItem(TOKEN_KEY, token);
export const clearToken = () => AsyncStorage.removeItem(TOKEN_KEY);

export const getSavedUser = async (): Promise<User | null> => {
  const raw = await AsyncStorage.getItem(USER_KEY);
  if (!raw) return null;
  try {
    return JSON.parse(raw) as User;
  } catch {
    return null;
  }
};
export const setSavedUser = (user: User) => AsyncStorage.setItem(USER_KEY, JSON.stringify(user));
export const clearSavedUser = () => AsyncStorage.removeItem(USER_KEY);
