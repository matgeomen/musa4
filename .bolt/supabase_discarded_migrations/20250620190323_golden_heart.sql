/*
  # Create Sample Users with Proper Authentication
  
  1. Creates test users in auth.users table
  2. Creates corresponding profiles in public.users table
  3. Adds sample posts and dua requests
  4. Uses proper UUID format
*/

-- Insert users into auth.users table (this requires service_role permissions)
-- Note: In production, users would be created through the signup process

-- First, let's create the auth users with proper UUIDs
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  recovery_sent_at,
  last_sign_in_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES 
(
  '00000000-0000-0000-0000-000000000000',
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'authenticated',
  'authenticated',
  'ahmet@example.com',
  crypt('123456', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '{"provider": "email", "providers": ["email"]}',
  '{"full_name": "Ahmet Yılmaz", "username": "ahmetyilmaz"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'b2c3d4e5-f6a7-8901-bcde-f23456789012',
  'authenticated',
  'authenticated',
  'admin@islamic.com',
  crypt('123456', gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '{"provider": "email", "providers": ["email"]}',
  '{"full_name": "Platform Yöneticisi", "username": "adminuser"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
)
ON CONFLICT (id) DO NOTHING;

-- Insert corresponding user profiles into public.users table
INSERT INTO public.users (
  id,
  email,
  name,
  username,
  avatar_url,
  bio,
  location,
  website,
  verified,
  role,
  created_at,
  updated_at
) VALUES 
(
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'ahmet@example.com',
  'Ahmet Yılmaz',
  'ahmetyilmaz',
  NULL,
  'İslami değerlere bağlı bir kardeşiniz. Allah''ın rızasını kazanmaya çalışıyorum.',
  'İstanbul, Türkiye',
  NULL,
  true,
  'user',
  NOW(),
  NOW()
),
(
  'b2c3d4e5-f6a7-8901-bcde-f23456789012',
  'admin@islamic.com',
  'Platform Yöneticisi',
  'adminuser',
  NULL,
  'İslami Sosyal Platform yöneticisi. Toplumumuza hizmet etmekten mutluluk duyuyorum.',
  'İstanbul, Türkiye',
  'https://islamic-platform.com',
  true,
  'admin',
  NOW(),
  NOW()
)
ON CONFLICT (id) DO NOTHING;

-- Insert some sample posts from these users
INSERT INTO public.posts (
  id,
  user_id,
  content,
  type,
  media_url,
  category,
  tags,
  likes_count,
  comments_count,
  shares_count,
  created_at,
  updated_at
) VALUES 
(
  gen_random_uuid(),
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'Bismillahirrahmanirrahim. Yeni bir güne başlarken Allah''a hamdolsun. Bugün de hayırlı işler yapmaya niyetliyim. 🤲',
  'text',
  NULL,
  'Dua ve Zikir',
  ARRAY['dua', 'hamd', 'şükür'],
  5,
  2,
  1,
  NOW() - INTERVAL '2 hours',
  NOW() - INTERVAL '2 hours'
),
(
  gen_random_uuid(),
  'b2c3d4e5-f6a7-8901-bcde-f23456789012',
  'Sevgili kardeşlerim, platformumuza hoş geldiniz! Burada İslami değerlerimizi paylaşarak birbirimize destek olacağız. Lütfen paylaşımlarınızda edep ve adaba dikkat edelim. 📚✨',
  'text',
  NULL,
  'Duyuru',
  ARRAY['hoşgeldin', 'platform', 'edep'],
  12,
  4,
  3,
  NOW() - INTERVAL '1 day',
  NOW() - INTERVAL '1 day'
),
(
  gen_random_uuid(),
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'Bugün Cuma namazından sonra çok güzel bir vaaz dinledim. Hocamız sabır konusunda çok değerli şeyler söyledi. Allah hepimize sabır versin. 🕌',
  'text',
  NULL,
  'İbadet',
  ARRAY['cuma', 'vaaz', 'sabır'],
  8,
  3,
  2,
  NOW() - INTERVAL '6 hours',
  NOW() - INTERVAL '6 hours'
)
ON CONFLICT (id) DO NOTHING;

-- Insert some sample dua requests
INSERT INTO public.dua_requests (
  id,
  user_id,
  title,
  content,
  category,
  is_urgent,
  is_anonymous,
  tags,
  prayers_count,
  comments_count,
  created_at,
  updated_at
) VALUES 
(
  gen_random_uuid(),
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'Hasta Annem İçin Dua',
  'Sevgili kardeşlerim, annem rahatsız. Doktorlar iyileşeceğini söylüyor ama ben çok endişeliyim. Lütfen annemin şifası için dua edin. Allah razı olsun.',
  'Sağlık',
  true,
  false,
  ARRAY['sağlık', 'anne', 'şifa'],
  15,
  8,
  NOW() - INTERVAL '3 hours',
  NOW() - INTERVAL '3 hours'
),
(
  gen_random_uuid(),
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'İş Bulabilmek İçin',
  'Uzun süredir iş arıyorum. Helal kazanç elde edebileceğim bir iş bulabilmek için dualarınızı istiyorum. Allah hepimizin rızkını bol etsin.',
  'Rızık',
  false,
  false,
  ARRAY['iş', 'rızık', 'helal'],
  7,
  3,
  NOW() - INTERVAL '1 day',
  NOW() - INTERVAL '1 day'
)
ON CONFLICT (id) DO NOTHING;

-- Insert some sample comments
INSERT INTO public.comments (
  id,
  user_id,
  dua_request_id,
  content,
  is_prayer,
  created_at,
  updated_at
) 
SELECT 
  gen_random_uuid(),
  'b2c3d4e5-f6a7-8901-bcde-f23456789012',
  dr.id,
  'Allah şifa versin kardeşim, dua ediyorum. 🤲',
  true,
  NOW() - INTERVAL '1 hour',
  NOW() - INTERVAL '1 hour'
FROM public.dua_requests dr 
WHERE dr.category = 'Sağlık'
LIMIT 1
ON CONFLICT (id) DO NOTHING;

-- Insert some likes
INSERT INTO public.likes (
  id,
  user_id,
  post_id,
  created_at
)
SELECT 
  gen_random_uuid(),
  'b2c3d4e5-f6a7-8901-bcde-f23456789012',
  p.id,
  NOW() - INTERVAL '30 minutes'
FROM public.posts p 
WHERE p.user_id = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
LIMIT 2
ON CONFLICT (id) DO NOTHING;