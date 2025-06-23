/*
  # Sample Data for Islamic Social Platform

  1. Test Users
    - Regular user: ahmet@example.com
    - Admin user: admin@islamic.com

  2. Sample Content
    - Posts from test users
    - Dua requests
    - Communities
    - Events

  Note: This data is for development and testing purposes only.
*/

-- Insert test users (these will be created via auth trigger when they sign up)
-- The actual user creation happens through Supabase Auth, but we can prepare some sample content

-- Sample categories for posts
INSERT INTO posts (user_id, content, category, tags, created_at) 
SELECT 
    u.id,
    'Selamün aleyküm kardeşlerim! Bu güzel platformda hep birlikte İslami değerlerimizi paylaşacağız inşallah. 🤲',
    'Genel',
    ARRAY['selam', 'kardeşlik', 'İslam'],
    now() - interval '2 hours'
FROM users u 
WHERE u.email = 'ahmet@example.com'
ON CONFLICT DO NOTHING;

-- Sample dua request categories
DO $$
BEGIN
    -- Only insert if we have users (they might not exist yet)
    IF EXISTS (SELECT 1 FROM users LIMIT 1) THEN
        -- Insert sample dua requests
        INSERT INTO dua_requests (user_id, title, content, category, is_urgent, tags, created_at)
        SELECT 
            u.id,
            'Hasta Annem İçin Dua',
            'Selamün aleyküm kardeşlerim. Annem hastanede tedavi görüyor. Şifa bulması için dualarınızı rica ediyorum. Allah razı olsun.',
            'Sağlık',
            true,
            ARRAY['sağlık', 'şifa', 'anne'],
            now() - interval '1 hour'
        FROM users u 
        WHERE u.email = 'ahmet@example.com'
        LIMIT 1
        ON CONFLICT DO NOTHING;

        -- Insert sample community
        INSERT INTO communities (name, description, category, created_by, created_at)
        SELECT 
            'İstanbul Gençlik Topluluğu',
            'İstanbul''da yaşayan genç Müslümanların bir araya geldiği topluluk. Birlikte etkinlikler düzenliyor, sohbetler yapıyoruz.',
            'Gençlik',
            u.id,
            now() - interval '3 days'
        FROM users u 
        WHERE u.email = 'admin@islamic.com'
        LIMIT 1
        ON CONFLICT DO NOTHING;

        -- Insert sample event
        INSERT INTO events (
            title, description, type, date, time, 
            location_name, location_address, location_city,
            organizer_name, capacity, created_by, created_at
        )
        SELECT 
            'Cuma Sohbeti',
            'Her Cuma akşamı düzenlediğimiz sohbet programımıza davetlisiniz. Bu hafta konumuz: "Gençlerin İslami Hayattaki Yeri"',
            'Sohbet',
            CURRENT_DATE + interval '3 days',
            '20:00',
            'Merkez Camii',
            'Fatih Mahallesi, Camii Sokak No:1',
            'İstanbul',
            'İstanbul Gençlik Topluluğu',
            50,
            u.id,
            now() - interval '1 day'
        FROM users u 
        WHERE u.email = 'admin@islamic.com'
        LIMIT 1
        ON CONFLICT DO NOTHING;
    END IF;
END $$;

-- Create some sample interactions (likes, comments) if users exist
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE email = 'ahmet@example.com') AND 
       EXISTS (SELECT 1 FROM posts LIMIT 1) THEN
        
        -- Sample comment
        INSERT INTO comments (user_id, post_id, content, created_at)
        SELECT 
            u.id,
            p.id,
            'Aleykümselam kardeşim! Çok güzel bir platform olmuş maşallah. 👍',
            now() - interval '30 minutes'
        FROM users u, posts p
        WHERE u.email = 'admin@islamic.com' 
        AND p.content LIKE '%Selamün aleyküm%'
        LIMIT 1
        ON CONFLICT DO NOTHING;

        -- Sample prayer comment on dua request
        INSERT INTO comments (user_id, dua_request_id, content, is_prayer, created_at)
        SELECT 
            u.id,
            d.id,
            'Allah şifa versin inşallah. Dualarımdasın kardeşim. 🤲',
            true,
            now() - interval '15 minutes'
        FROM users u, dua_requests d
        WHERE u.email = 'admin@islamic.com' 
        AND d.title LIKE '%Hasta Annem%'
        LIMIT 1
        ON CONFLICT DO NOTHING;
    END IF;
END $$;

-- Update counters based on actual data
UPDATE posts SET 
    comments_count = (SELECT COUNT(*) FROM comments WHERE post_id = posts.id),
    likes_count = (SELECT COUNT(*) FROM likes WHERE post_id = posts.id);

UPDATE dua_requests SET 
    comments_count = (SELECT COUNT(*) FROM comments WHERE dua_request_id = dua_requests.id),
    prayers_count = (SELECT COUNT(*) FROM comments WHERE dua_request_id = dua_requests.id AND is_prayer = true);

UPDATE communities SET 
    member_count = (SELECT COUNT(*) FROM community_members WHERE community_id = communities.id);

UPDATE events SET 
    attendees_count = (SELECT COUNT(*) FROM event_attendees WHERE event_id = events.id);