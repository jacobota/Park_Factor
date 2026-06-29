-- Park Factor — initial Supabase schema (OLTP: profiles / posts / likes). Images deferred (0002).
-- Paste into the Supabase SQL editor, OR run via `supabase db push` (CLI).
-- Auth: Supabase Auth owns auth.users (email + password). public.profiles is 1:1 with it.
-- Security: the app uses supabase-js with the ANON key; the Row-Level Security policies below are
-- the ONLY boundary between a client and the data. The service_role key bypasses RLS (server only).
-- Design (per decisions): likes = post_likes join table; posts reference author_id (profile embedded
-- at query time); follows/favorites = JSONB Team/Player objects to match the app's TS types.

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. PROFILES  (1:1 with auth.users; app user fields. No password — Supabase owns it.)
-- ─────────────────────────────────────────────────────────────────────────────
create table public.profiles (
  id                uuid primary key references auth.users (id) on delete cascade,
  username          text unique not null,
  admin             boolean not null default false,
  verified          boolean not null default false,
  user_tag          text not null default 'Rookie',
  user_biography    text not null default '',
  profile_picture   text,                          -- Storage URL (NULL until images ship)
  favorite_team     jsonb,                         -- full Team object (or null)
  favorite_player   jsonb,                         -- full Player object (or null)
  following_teams   jsonb not null default '[]',   -- Team[]
  following_players jsonb not null default '[]',   -- Player[]
  created_at        timestamptz not null default now()
);

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. POSTS  (The Concourse feed). Author is referenced by id; the username/avatar are embedded
--    at read time (always current). author_id defaults to the caller so clients can't spoof it.
-- ─────────────────────────────────────────────────────────────────────────────
create table public.posts (
  id          uuid primary key default gen_random_uuid(),
  author_id   uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  content     text not null check (char_length(content) <= 255),
  post_image  text,                                -- Storage URL (nullable; deferred)
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index posts_author_id_idx  on public.posts (author_id);
create index posts_created_at_idx  on public.posts (created_at desc);   -- feed ordering

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. POST_LIKES  (many-to-many; enables atomic like/unlike + like counts)
-- ─────────────────────────────────────────────────────────────────────────────
create table public.post_likes (
  user_id    uuid not null references public.profiles (id) on delete cascade,
  post_id    uuid not null references public.posts (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, post_id)
);
create index post_likes_post_id_idx on public.post_likes (post_id);     -- count likes per post

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. TRIGGERS
-- ─────────────────────────────────────────────────────────────────────────────
-- 4a. keep posts.updated_at current
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

create trigger posts_set_updated_at
  before update on public.posts
  for each row execute function public.set_updated_at();

-- 4b. auto-create a profile on signup. username comes from signup metadata:
--     supabase.auth.signUp({ email, password, options:{ data:{ username }}})
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, username)
  values (new.id, coalesce(new.raw_user_meta_data->>'username', 'user_' || left(new.id::text, 8)));
  return new;
end; $$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4c. clients may NOT self-grant admin/verified; only the service role can change them
create or replace function public.protect_privileged_columns()
returns trigger language plpgsql as $$
begin
  if (new.admin is distinct from old.admin or new.verified is distinct from old.verified)
     and auth.role() <> 'service_role' then
    raise exception 'Only the service role may change admin/verified';
  end if;
  return new;
end; $$;

create trigger profiles_protect_privileged
  before update on public.profiles
  for each row execute function public.protect_privileged_columns();

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. ROW-LEVEL SECURITY
-- ─────────────────────────────────────────────────────────────────────────────
alter table public.profiles   enable row level security;
alter table public.posts      enable row level security;
alter table public.post_likes enable row level security;

-- PROFILES: public read; users edit/delete only their own (admin/verified guarded by 4c).
create policy "profiles are publicly readable"
  on public.profiles for select using (true);
create policy "users update own profile"
  on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
create policy "users delete own profile"
  on public.profiles for delete using (auth.uid() = id);

-- POSTS: public read; only VERIFIED users create as themselves; authors edit; author/admin delete.
create policy "posts are publicly readable"
  on public.posts for select using (true);
create policy "verified users create posts"
  on public.posts for insert with check (
    auth.uid() = author_id
    and (select verified from public.profiles where id = auth.uid())
  );
create policy "authors update own posts"
  on public.posts for update using (auth.uid() = author_id) with check (auth.uid() = author_id);
create policy "authors or admins delete posts"
  on public.posts for delete using (
    auth.uid() = author_id
    or (select admin from public.profiles where id = auth.uid())
  );

-- POST_LIKES: public read (counts); users like/unlike only as themselves.
create policy "likes are publicly readable"
  on public.post_likes for select using (true);
create policy "users like as themselves"
  on public.post_likes for insert with check (auth.uid() = user_id);
create policy "users remove own likes"
  on public.post_likes for delete using (auth.uid() = user_id);

-- ─────────────────────────────────────────────────────────────────────────────
-- 6. IMAGES / STORAGE — DEFERRED (stay on Free tier). Apply 0002_storage.sql on Pro when ready;
--    profiles.profile_picture / posts.post_image then hold the public CDN URLs.
-- ─────────────────────────────────────────────────────────────────────────────
