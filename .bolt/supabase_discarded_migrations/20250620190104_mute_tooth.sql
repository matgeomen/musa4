/*
  # Create Sample Users for Authentication

  1. New Users
    - Creates sample users in auth.users table
    - Creates corresponding profiles in public.users table
    - Sets up proper authentication credentials

  2. Security
    - Uses service_role permissions to insert auth users
    - Maintains RLS policies for user data
    - Creates secure password hashes

  3. Test Accounts
    - ahmet@example.com (regular user)
    - admin@islamic.com (admin user)
    - Both with password: 123456
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
  'b2c3d4e5-f6g7-8901-bcde-f23456789012',
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
  'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=150',
  'İslami değerlere bağlı bir kardeşiniz. Allah''ın rızasını kazanmaya çalışıyorum.',
  'İstanbul, Türkiye',
  NULL,
  true,
  'user',
  NOW(),
  NOW()
),
(
  'b2c3d4e5-f6g7-8901-bcde-f23456789012',
  'admin@islamic.com',
  'Platform Yöneticisi',
  'adminuser',
  'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=150',
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
  'b2c3d4e5-f6g7-8901-bcde-f23456789012',
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