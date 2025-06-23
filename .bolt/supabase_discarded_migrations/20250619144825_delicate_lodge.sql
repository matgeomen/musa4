/*
  # Örnek Veri Ekleme

  1. Test Kullanıcıları
    - README.md'de belirtilen test hesapları
    - Normal kullanıcı ve admin hesapları
    - Doğrulanmış profiller

  2. Örnek İçerik
    - Çeşitli kategorilerde gönderiler
    - Dua talepleri
    - Topluluklar ve etkinlikler

  3. Etkileşimler
    - Beğeniler, yorumlar, yer imleri
    - Topluluk üyelikleri
    - Etkinlik katılımları
*/

-- Test kullanıcıları oluştur (sadece yoksa)
DO $$
DECLARE
    user_id_1 uuid := '550e8400-e29b-41d4-a716-446655440001';
    user_id_2 uuid := '550e8400-e29b-41d4-a716-446655440002';
    admin_id uuid := '550e8400-e29b-41d4-a716-446655440003';
    community_id_1 uuid := '660e8400-e29b-41d4-a716-446655440001';
    community_id_2 uuid := '660e8400-e29b-41d4-a716-446655440002';
    event_id_1 uuid := '770e8400-e29b-41d4-a716-446655440001';
    event_id_2 uuid := '770e8400-e29b-41d4-a716-446655440002';
BEGIN
    -- Test kullanıcıları ekle (sadece yoksa)
    INSERT INTO users (id, email, name, username, bio, location, verified, role) VALUES
    (user_id_1, 'ahmet@example.com', 'Ahmet Yılmaz', 'ahmetyilmaz', 'İslami değerlere bağlı bir kardeşiniz. Hayır işlerinde aktif olmaya çalışıyorum.', 'İstanbul', true, 'user'),
    (user_id_2, 'fatma@example.com', 'Fatma Kaya', 'fatmakaya', 'Kur''an kursu öğretmeni. İlim öğrenmeyi ve öğretmeyi seviyorum.', 'Ankara', true, 'user'),
    (admin_id, 'admin@islamic.com', 'Platform Yöneticisi', 'islamadmin', 'İslami paylaşım platformunun yöneticisi', 'İstanbul', true, 'admin')
    ON CONFLICT (email) DO NOTHING;

    -- Örnek gönderiler
    INSERT INTO posts (id, user_id, content, category, tags, likes_count, comments_count) VALUES
    ('880e8400-e29b-41d4-a716-446655440001', user_id_1, 'Selamün aleyküm kardeşlerim! Bu güzel platformda olmaktan çok mutluyum. Allah hepimizi hayırda birleştirsin. 🤲', 'Genel', ARRAY['selam', 'kardeşlik'], 15, 3),
    ('880e8400-e29b-41d4-a716-446655440002', user_id_2, 'Bugün çok güzel bir hadis okudum: "Müslüman, elinden ve dilinden Müslümanların emin olduğu kimsedir." (Buhari) 📖', 'Hadis', ARRAY['hadis', 'İslam', 'öğüt'], 28, 7),
    ('880e8400-e29b-41d4-a716-446655440003', admin_id, 'İslami paylaşım platformumuza hoş geldiniz! Burada güzel paylaşımlar yapabilir, kardeşlerimizle etkileşimde bulunabilirsiniz. 🕌', 'Duyuru', ARRAY['hoşgeldin', 'platform', 'duyuru'], 42, 12),
    ('880e8400-e29b-41d4-a716-446655440004', user_id_1, 'Ramazan ayı yaklaşıyor. Hazırlıklarımızı yapmaya başlayalım. Oruç tutmaya niyetlenenler için güzel bir rehber hazırladım. 🌙', 'Ramazan', ARRAY['ramazan', 'hazırlık', 'oruç'], 35, 8),
    ('880e8400-e29b-41d4-a716-446655440005', user_id_2, 'Çocuklarımıza Kur''an-ı Kerim öğretirken sabırlı olmak çok önemli. Her çocuğun öğrenme hızı farklıdır. 👶📚', 'Eğitim', ARRAY['eğitim', 'çocuk', 'kuran'], 22, 5)
    ON CONFLICT (id) DO NOTHING;

    -- Örnek dua talepleri
    INSERT INTO dua_requests (id, user_id, title, content, category, tags, is_urgent, prayers_count, comments_count) VALUES
    ('990e8400-e29b-41d4-a716-446655440001', user_id_1, 'Annem için şifa duası', 'Sevgili kardeşlerim, annem hasta. Şifa bulması için dualarınızı rica ediyorum. Allah hepimizi hastalıklardan korusun.', 'Sağlık', ARRAY['sağlık', 'şifa', 'anne'], true, 45, 12),
    ('990e8400-e29b-41d4-a716-446655440002', user_id_2, 'İş bulma konusunda dua', 'Uzun süredir iş arıyorum. Hayırlı bir iş bulabilmem için dua eder misiniz? Allah rızkımızı bol etsin.', 'İş', ARRAY['iş', 'rızık', 'hayır'], false, 23, 6),
    ('990e8400-e29b-41d4-a716-446655440003', user_id_1, 'Evlilik için dua', 'Hayırlı bir eş bulabilmem için dualarınızı istiyorum. Allah hepimizi hayırlı eşlerle buluştursun.', 'Evlilik', ARRAY['evlilik', 'eş', 'hayır'], false, 18, 4)
    ON CONFLICT (id) DO NOTHING;

    -- Örnek topluluklar
    INSERT INTO communities (id, name, description, category, created_by, member_count, location) VALUES
    (community_id_1, 'İstanbul Gençlik Topluluğu', 'İstanbul''da yaşayan genç Müslümanların buluşma noktası. Birlikte etkinlikler düzenliyor, sohbetler yapıyoruz.', 'Gençlik', user_id_1, 156, 'İstanbul'),
    (community_id_2, 'Kur''an Öğrenme Grubu', 'Kur''an-ı Kerim öğrenmek isteyenler için oluşturulmuş topluluk. Hafızlık ve tecvid dersleri düzenliyoruz.', 'Eğitim', user_id_2, 89, 'Ankara')
    ON CONFLICT (id) DO NOTHING;

    -- Topluluk üyelikleri
    INSERT INTO community_members (community_id, user_id, role) VALUES
    (community_id_1, user_id_1, 'admin'),
    (community_id_1, user_id_2, 'member'),
    (community_id_1, admin_id, 'member'),
    (community_id_2, user_id_2, 'admin'),
    (community_id_2, user_id_1, 'member')
    ON CONFLICT (community_id, user_id) DO NOTHING;

    -- Örnek etkinlikler
    INSERT INTO events (id, title, description, type, date, time, location_name, location_address, location_city, organizer_name, organizer_contact, capacity, attendees_count, price, tags, created_by) VALUES
    (event_id_1, 'Cuma Sohbeti', 'Her Cuma akşamı düzenlediğimiz İslami sohbet programı. Bu hafta konumuz: "Sabır ve Şükür"', 'Sohbet', CURRENT_DATE + INTERVAL '3 days', '20:00', 'Merkez Camii', 'Atatürk Caddesi No:15', 'İstanbul', 'Ahmet Yılmaz', 'ahmet@example.com', 50, 23, 0, ARRAY['sohbet', 'cuma', 'sabır'], user_id_1),
    (event_id_2, 'Kur''an Kursu Açılışı', 'Yeni dönem Kur''an kursumuzun açılış programı. Tüm yaş grupları için kurslarımız mevcut.', 'Eğitim', CURRENT_DATE + INTERVAL '7 days', '14:00', 'Eğitim Merkezi', 'Kızılay Meydanı No:8', 'Ankara', 'Fatma Kaya', 'fatma@example.com', 100, 67, 0, ARRAY['kuran', 'eğitim', 'kurs'], user_id_2)
    ON CONFLICT (id) DO NOTHING;

    -- Etkinlik katılımcıları
    INSERT INTO event_attendees (event_id, user_id) VALUES
    (event_id_1, user_id_1),
    (event_id_1, user_id_2),
    (event_id_2, user_id_2),
    (event_id_2, admin_id)
    ON CONFLICT (event_id, user_id) DO NOTHING;

    -- Örnek yorumlar
    INSERT INTO comments (id, user_id, post_id, content) VALUES
    ('aa0e8400-e29b-41d4-a716-446655440001', user_id_2, '880e8400-e29b-41d4-a716-446655440001', 'Çok güzel bir paylaşım, Allah razı olsun kardeşim! 🤲'),
    ('aa0e8400-e29b-41d4-a716-446655440002', admin_id, '880e8400-e29b-41d4-a716-446655440002', 'Maşallah çok güzel bir hadis. Paylaştığınız için teşekkürler.'),
    ('aa0e8400-e29b-41d4-a716-446655440003', user_id_1, '880e8400-e29b-41d4-a716-446655440003', 'Hoş geldiniz mesajı için teşekkürler!')
    ON CONFLICT (id) DO NOTHING;

    -- Dua yorumları (dualar)
    INSERT INTO comments (id, user_id, dua_request_id, content, is_prayer) VALUES
    ('aa0e8400-e29b-41d4-a716-446655440004', user_id_2, '990e8400-e29b-41d4-a716-446655440001', 'Anneniz için dua ediyorum, Allah şifa versin. 🤲', true),
    ('aa0e8400-e29b-41d4-a716-446655440005', admin_id, '990e8400-e29b-41d4-a716-446655440002', 'Allah hayırlı bir iş nasip etsin kardeşim.', true),
    ('aa0e8400-e29b-41d4-a716-446655440006', user_id_2, '990e8400-e29b-41d4-a716-446655440003', 'Allah hayırlı bir eş nasip etsin inşallah.', true)
    ON CONFLICT (id) DO NOTHING;

    -- Örnek beğeniler
    INSERT INTO likes (user_id, post_id) VALUES
    (user_id_2, '880e8400-e29b-41d4-a716-446655440001'),
    (admin_id, '880e8400-e29b-41d4-a716-446655440001'),
    (user_id_1, '880e8400-e29b-41d4-a716-446655440002'),
    (admin_id, '880e8400-e29b-41d4-a716-446655440003')
    ON CONFLICT (user_id, post_id) DO NOTHING;

    -- Dua beğenileri (dualar)
    INSERT INTO likes (user_id, dua_request_id) VALUES
    (user_id_2, '990e8400-e29b-41d4-a716-446655440001'),
    (admin_id, '990e8400-e29b-41d4-a716-446655440001'),
    (user_id_1, '990e8400-e29b-41d4-a716-446655440002'),
    (admin_id, '990e8400-e29b-41d4-a716-446655440003')
    ON CONFLICT (user_id, dua_request_id) DO NOTHING;

    -- Örnek yer imleri
    INSERT INTO bookmarks (user_id, post_id) VALUES
    (user_id_1, '880e8400-e29b-41d4-a716-446655440002'),
    (user_id_2, '880e8400-e29b-41d4-a716-446655440003'),
    (admin_id, '880e8400-e29b-41d4-a716-446655440004')
    ON CONFLICT (user_id, post_id) DO NOTHING;

    -- Dua yer imleri
    INSERT INTO bookmarks (user_id, dua_request_id) VALUES
    (user_id_1, '990e8400-e29b-41d4-a716-446655440002'),
    (user_id_2, '990e8400-e29b-41d4-a716-446655440003'),
    (admin_id, '990e8400-e29b-41d4-a716-446655440001')
    ON CONFLICT (user_id, dua_request_id) DO NOTHING;

END $$;