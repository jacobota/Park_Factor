# Supabase Setup Runbook

Goal this session: user accounts + auth + (text) posts on Supabase, then retire AWS.
**Images (profile pics + post images) are DEFERRED** → we stay on the Supabase **Free** tier for now
and switch to **Pro ($25/mo)** when we add images + launch (Pro also removes Free's 1-week
inactivity pause). Since AWS holds only **throwaway test data**, there is **no data migration** —
start clean.

Legend: **[YOU]** = you do it (dashboard/CLI) · **[CLAUDE]** = I write the code.

---

## Part 1 — Create the Supabase project  [YOU]
1. Go to https://supabase.com → sign in with GitHub → **New organization** (if needed).
2. **New project**:
   - Name: `park-factor`
   - Database password: generate a strong one → **save it** (password manager).
   - Region: **West US (North California)** or nearest to your users.
   - Plan: **Free** for now (flip to **Pro $25** before launch).
3. Wait ~2 min for provisioning.

## Part 2 — Grab your keys  [YOU]
4. Project → **Settings → API**, copy these three:
   - **Project URL** (e.g. `https://abcd.supabase.co`)
   - **anon public** key  ← goes in the app
   - **service_role** key ← server/admin only, **never** ship in the app
   - Also note the **project ref** (the `abcd` in the URL) for the CLI.

## Part 3 — Configure Auth  [YOU]
5. **Authentication → Providers → Email**: ensure **Email** is enabled.
6. For fast dev, **turn OFF "Confirm email"** (Authentication → Providers → Email, or
   Authentication → Sign In/Up settings). Re-enable before launch.
7. (Defer) OAuth/password-reset redirect URLs — set when we add deep links.

## Part 4 — Apply the schema  [YOU]
The schema file is already in the repo: `supabase/migrations/0001_initial_schema.sql`.

**Recommended (version-controlled) — Supabase CLI:**
```bash
brew install supabase/tap/supabase          # macOS
supabase login                              # opens browser
cd /Users/jacobota/final_project/Park_Factor
supabase link --project-ref <YOUR_PROJECT_REF>
supabase db push                            # applies 0001_initial_schema.sql
```
**Quick alternative — SQL editor:** open `supabase/migrations/0001_initial_schema.sql`, copy all,
paste into Supabase **SQL Editor**, **Run**.

## Part 5 — Verify  [YOU]
8. **Table editor** → confirm `profiles`, `posts`, `post_likes` exist.
9. **Authentication → Policies** → confirm RLS is **enabled** on all three tables.
   (No Storage buckets yet — images are deferred; apply `supabase/migrations/0002_storage.sql` later.)

## Part 6 — Install the client in the app  [YOU]
```bash
cd /Users/jacobota/final_project/Park_Factor/mobile
npx expo install @supabase/supabase-js @react-native-async-storage/async-storage react-native-url-polyfill
```
11. Create `mobile/.env` (and add it to `.gitignore`):
```
EXPO_PUBLIC_SUPABASE_URL=<your Project URL>
EXPO_PUBLIC_SUPABASE_ANON_KEY=<your anon public key>
```

## Part 7 — Wire up the code  [CLAUDE — DONE]
Written/rewritten in `mobile/` (ready once Part 6 deps + .env are in place):
- `src/api/supabaseClient.ts` — client (URL polyfill + AsyncStorage session persistence)
- `src/api/profileMap.ts` — row↔type mapping (profiles→User, embedded author→Post)
- `src/api/auth.ts` — `login(email,pw)` / `register` / `fetchProfile` via Supabase Auth
- `src/api/posts.ts` — feed CRUD (author embedded) + `likePost`/`unlikePost`/`getLikeCount`
- `src/api/user.ts` — profile mutations; email/password via Supabase Auth
- `src/context/AuthContext.tsx` — session-backed (signIn/signOut/setUser surface unchanged)
- `src/screens/auth/LoginScreen.tsx` — logs in by **email**; `SignupScreen.tsx` — auto-login by email
- `src/components/cards/PostCard.tsx` — like toggle now hits the post_likes table
- _(deferred)_ `uploadImage()` helper → `avatars` / `post-images` (when we go Pro)

Stats (Flask) and news (Express) calls are untouched — only the Express auth/posts/user paths moved.

## Part 8 — Test the golden path  [YOU + CLAUDE]
12. Run the app (`npx expo start`), then: sign up → log in → create a (text) post → see it render →
    like it. Confirm rows appear in the Supabase Table editor. (Images come later, post-Pro.)
    - **Posting requires `verified = true`** (RLS — only verified users post, by design). To test:
      open **Table editor → profiles**, set your row's `verified` to `true` (the dashboard uses the
      service role, so it's allowed). Set `admin = true` too if you want delete-any powers.
    - Sign-up needs **"Confirm email" OFF** (Part 3) so the session is active immediately.

---

## Part 9 — Retire AWS  [YOU]  (safe to do once Part 8 passes — data is disposable)
1. **Confirm** signup/login/posts/images work on Supabase end-to-end.
2. Delete the DynamoDB tables:
   ```bash
   aws dynamodb delete-table --table-name ParkFactor-Users        --region us-west-1
   aws dynamodb delete-table --table-name ParkFactor-VerifiedPosts --region us-west-1
   ```
3. Empty + delete the S3 bucket holding test images:
   ```bash
   aws s3 rm s3://<your-image-bucket> --recursive
   aws s3 rb s3://<your-image-bucket>
   ```
4. **[CLAUDE]** Remove AWS bits from `backend/`: DynamoDB DAOs, `@aws-sdk/*` deps, and AWS env vars.
5. Delete the AWS env vars from `backend/.env` (`REGION`, `ACCESS_KEY_ID`, `SECRET_ACCESS_KEY_ID`,
   `USERS_TABLENAME`, `VERIFIEDPOSTS_TABLENAME`).
6. **IAM** → deactivate/delete the access key pair used by the app (security hygiene).
7. (Optional) If nothing else uses this AWS account, downgrade/close it.

> The stats backend (`stats_api` + future DuckDB/MotherDuck) is a **separate track** — it does not
> use AWS and is unaffected by this retirement.
