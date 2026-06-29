import 'react-native-url-polyfill/auto';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { createClient } from '@supabase/supabase-js';

/**
 * Supabase client — backs auth + the social layer (profiles, posts, likes), replacing the
 * Express/DynamoDB backend. Stats stay on Flask (see api/client.ts `flask` backend).
 *
 * The anon key is publishable by design; Row-Level Security (the policies in
 * supabase/migrations/0001_initial_schema.sql) is the actual security boundary. Never put the
 * service_role key in the app.
 *
 * Env (mobile/.env, EXPO_PUBLIC_ prefix so it reaches the client bundle):
 *   EXPO_PUBLIC_SUPABASE_URL=...
 *   EXPO_PUBLIC_SUPABASE_ANON_KEY=...
 */
const url = process.env.EXPO_PUBLIC_SUPABASE_URL;
const anonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

if (!url || !anonKey) {
  throw new Error(
    'Missing Supabase env. Set EXPO_PUBLIC_SUPABASE_URL and EXPO_PUBLIC_SUPABASE_ANON_KEY in mobile/.env',
  );
}

export const supabase = createClient(url, anonKey, {
  auth: {
    storage: AsyncStorage,        // persist the session across app restarts (was manual token storage)
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,    // no URL-based auth on React Native
  },
});
