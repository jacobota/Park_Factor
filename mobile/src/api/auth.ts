import { api } from './client';
import type { User, UserLoginResponse, UserRegisterResponse } from '@/types';

/** POST /users/login — returns the user + auth token. */
export const login = (username: string, password: string) =>
  api.post<UserLoginResponse>('/users/login', { body: { username, password } });

/** POST /users/registration — creates the account (does not log in). */
export const register = (username: string, email: string, password: string) =>
  api.post<UserRegisterResponse>('/users/registration', { body: { username, email, password } });

/** GET /users/profile — validates the stored token and returns the current user. */
export const fetchProfile = () => api.get<User>('/users/profile', { auth: true });
