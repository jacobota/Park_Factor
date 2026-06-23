import { config } from '@/config';
import { getToken } from './storage';

/**
 * Central HTTP client — replaces the repeated URLSession.dataTask boilerplate scattered
 * across every Swift view. Injects the Bearer token, sets JSON headers, and throws ApiError
 * on non-2xx so callers (and React Query) get consistent error handling.
 */

export class ApiError extends Error {
  constructor(public status: number, message: string) {
    super(message);
    this.name = 'ApiError';
  }
}

export type Backend = 'express' | 'flask';

const baseFor = (backend: Backend) =>
  backend === 'flask' ? config.flaskBaseURL : config.expressBaseURL;

interface RequestOptions {
  backend?: Backend;
  /** Attach the stored auth token as a Bearer header. */
  auth?: boolean;
  query?: Record<string, string | number | boolean | null | undefined>;
  body?: unknown;
  signal?: AbortSignal;
}

const buildUrl = (backend: Backend, path: string, query?: RequestOptions['query']) => {
  const url = new URL(path.replace(/^\//, ''), baseFor(backend).replace(/\/?$/, '/'));
  if (query) {
    for (const [k, v] of Object.entries(query)) {
      if (v !== null && v !== undefined) url.searchParams.set(k, String(v));
    }
  }
  return url.toString();
};

async function request<T>(method: string, path: string, opts: RequestOptions = {}): Promise<T> {
  const { backend = 'express', auth = false, query, body, signal } = opts;
  const headers: Record<string, string> = { 'Content-Type': 'application/json' };

  if (auth) {
    const token = await getToken();
    if (token) headers.Authorization = `Bearer ${token}`;
  }

  const res = await fetch(buildUrl(backend, path, query), {
    method,
    headers,
    body: body !== undefined ? JSON.stringify(body) : undefined,
    signal,
  });

  if (!res.ok) {
    let message = `Request failed (${res.status})`;
    try {
      const data = await res.json();
      if (data?.message) message = data.message; // NodeError shape
    } catch {
      /* ignore non-JSON error bodies */
    }
    throw new ApiError(res.status, message);
  }

  if (res.status === 204) return undefined as T;
  const text = await res.text();
  return (text ? JSON.parse(text) : undefined) as T;
}

export const api = {
  get: <T>(path: string, opts?: RequestOptions) => request<T>('GET', path, opts),
  post: <T>(path: string, opts?: RequestOptions) => request<T>('POST', path, opts),
  put: <T>(path: string, opts?: RequestOptions) => request<T>('PUT', path, opts),
  patch: <T>(path: string, opts?: RequestOptions) => request<T>('PATCH', path, opts),
  delete: <T>(path: string, opts?: RequestOptions) => request<T>('DELETE', path, opts),
};
