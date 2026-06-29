-- Park Factor — image storage (DEFERRED; apply when adding profile pics + post images).
-- Prereq: upgrade to Supabase Pro ($25/mo) for headroom + no inactivity pause at launch.
-- The profiles.profile_picture and posts.post_image columns (from 0001) hold the public CDN URL.

-- Image buckets.
insert into storage.buckets (id, name, public) values
  ('avatars',     'avatars',     true),
  ('post-images', 'post-images', true)
on conflict (id) do nothing;

-- Public read for both buckets.
create policy "public read avatars"
  on storage.objects for select using (bucket_id = 'avatars');
create policy "public read post-images"
  on storage.objects for select using (bucket_id = 'post-images');

-- Authenticated users may write only inside their own user-id folder, e.g. "<auth.uid>/pic.jpg".
create policy "users manage own avatars"
  on storage.objects for all to authenticated
  using      (bucket_id = 'avatars'     and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'avatars'     and (storage.foldername(name))[1] = auth.uid()::text);
create policy "users manage own post-images"
  on storage.objects for all to authenticated
  using      (bucket_id = 'post-images' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'post-images' and (storage.foldername(name))[1] = auth.uid()::text);
