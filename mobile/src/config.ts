import Constants from 'expo-constants';

/**
 * App config — replaces Env.swift / Env.plist.
 *
 * On a physical device `localhost` points at the phone, not your Mac, so we resolve the dev
 * host from Expo's `hostUri` (the IP the phone used to reach Metro) and talk to the backend on
 * that same machine. Order of precedence:
 *   1. app.json `extra.EXPRESS_BASE_URL` / `extra.FLASK_URL` (explicit override)
 *   2. the Metro dev host (auto — works on device + simulator)
 *   3. the detected LAN IP, then localhost
 *
 * NOTE: the Swift Env.plist hardcoded live AWS credentials; those are intentionally NOT ported.
 * Image uploads should be proxied through the backend so the client never holds AWS secrets.
 */
const extra = (Constants.expoConfig?.extra ?? {}) as Record<string, string | undefined>;

const EXPRESS_PORT = 3000;
const FLASK_PORT = 5000;
const FALLBACK_LAN_IP = '10.0.0.47';

/** Host part of the Metro connection (e.g. "10.0.0.47" from "10.0.0.47:8081"), if available. */
const devHost = Constants.expoConfig?.hostUri?.split(':')[0];

const host = devHost ?? FALLBACK_LAN_IP;

export const config = {
  /** Node/Express backend (users, news, posts, leaderboards). */
  expressBaseURL: extra.EXPRESS_BASE_URL ?? `http://${host}:${EXPRESS_PORT}`,
  /** Flask + PyBaseball stats service. */
  flaskBaseURL: extra.FLASK_URL ?? `http://${host}:${FLASK_PORT}`,
};
