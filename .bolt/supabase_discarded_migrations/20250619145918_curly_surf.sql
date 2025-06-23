-- Örnek veriler
USE islamic_platform;

-- Test kullanıcıları
INSERT INTO users (id, email, password_hash, name, username, bio, location, verified, role) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'ahmet@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ahmet Yılmaz', 'ahmetyilmaz', 'İslami değerlere bağlı bir kardeşiniz. Hayır işlerinde aktif olmaya çalışıyorum.', 'İstanbul', TRUE, 'user'),
('550e8400-e29b-41d4-a716-446655440002', 'fatma@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Fatma Kaya', 'fatmakaya', 'Kur\'an kursu öğretmeni. İlim öğrenmeyi ve öğretmeyi seviyorum.', 'Ankara', TRUE, 'user'),
('550e8400-e29b-41d4-a716-446655440003', 'admin@islamic.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Platform Yöneticisi', 'islamadmin', 'İslami paylaşım platformunun yöneticisi', 'İstanbul', TRUE, 'admin');

-- Örnek gönderiler
INSERT INTO posts (id, user_id, content, category, tags, likes_count, comments_count) VALUES
('880e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Selamün aleyküm kardeşlerim! Bu güzel platformda olmaktan çok mutluyum. Allah hepimizi hayırda birleştirsin. 🤲', 'Genel', '["selam", "kardeşlik"]', 15, 3),
('880e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'Bugün çok güzel bir hadis okudum: "Müslüman, elinden ve dilinden Müslümanların emin olduğu kimsedir." (Buhari) 📖', 'Hadis', '["hadis", "İslam", "öğüt"]', 28, 7),
('880e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', 'İslami paylaşım platformumuza hoş geldiniz! Burada güzel paylaşımlar yapabilir, kardeşlerimizle etkileşimde bulunabilirsiniz. 🕌', 'Duyuru', '["hoşgeldin", "platform", "duyuru"]', 42, 12);

-- Örnek dua talepleri
INSERT INTO dua_requests (id, user_id, title, content, category, tags, is_urgent, prayers_count, comments_count) VALUES
('990e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Annem için şifa duası', 'Sevgili kardeşlerim, annem hasta. Şifa bulması için dualarınızı rica ediyorum. Allah hepimizi hastalıklardan korusun.', 'Sağlık', '["sağlık", "şifa", "anne"]', TRUE, 45, 12),
('990e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'İş bulma konusunda dua', 'Uzun süredir iş arıyorum. Hayırlı bir iş bulabilmem için dua eder misiniz? Allah rızkımızı bol etsin.', 'İş', '["iş", "rızık", "hayır"]', FALSE, 23, 6);

-- Örnek topluluklar
INSERT INTO communities (id, name, description, category, created_by, member_count, location) VALUES
('660e8400-e29b-41d4-a716-446655440001', 'İstanbul Gençlik Topluluğu', 'İstanbul\'da yaşayan genç Müslümanların buluşma noktası. Birlikte etkinlikler düzenliyor, sohbetler yapıyoruz.', 'Gençlik', '550e8400-e29b-41d4-a716-446655440001', 156, 'İstanbul'),
('660e8400-e29b-41d4-a716-446655440002', 'Kur\'an Öğrenme Grubu', 'Kur\'an-ı Kerim öğrenmek isteyenler için oluşturulmuş topluluk. Hafızlık ve tecvid dersleri düzenliyoruz.', 'Eğitim', '550e8400-e29b-41d4-a716-446655440002', 89, 'Ankara');

-- Örnek etkinlikler
INSERT INTO events (id, title, description, type, date, time, location_name, location_address, location_city, organizer_name, capacity, attendees_count, created_by) VALUES
('770e8400-e29b-41d4-a716-446655440001', 'Cuma Sohbeti', 'Her Cuma akşamı düzenlediğimiz İslami sohbet programı. Bu hafta konumuz: "Sabır ve Şükür"', 'Sohbet', DATE_ADD(CURDATE(), INTERVAL 3 DAY), '20:00', 'Merkez Camii', 'Atatürk Caddesi No:15', 'İstanbul', 'Ahmet Yılmaz', 50, 23, '550e8400-e29b-41d4-a716-446655440001'),
('770e8400-e29b-41d4-a716-446655440002', 'Kur\'an Kursu Açılışı', 'Yeni dönem Kur\'an kursumuzun açılış programı. Tüm yaş grupları için kurslarımız mevcut.', 'Eğitim', DATE_ADD(CURDATE(), INTERVAL 7 DAY), '14:00', 'Eğitim Merkezi', 'Kızılay Meydanı No:8', 'Ankara', 'Fatma Kaya', 100, 67, '550e8400-e29b-41d4-a716-446655440002');

-- Örnek yorumlar
INSERT INTO comments (id, user_id, post_id, content) VALUES
('aa0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440001', 'Çok güzel bir paylaşım, Allah razı olsun kardeşim! 🤲'),
('aa0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440002', 'Maşallah çok güzel bir hadis. Paylaştığınız için teşekkürler.');

-- Dua yorumları
INSERT INTO comments (id, user_id, dua_request_id, content, is_prayer) VALUES
('aa0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440001', 'Anneniz için dua ediyorum, Allah şifa versin. 🤲', TRUE),
('aa0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440002', 'Allah hayırlı bir iş nasip etsin kardeşim.', TRUE);

-- Örnek beğeniler
INSERT INTO likes (user_id, post_id) VALUES
('550e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440001'),
('550e8400-e29b-41d4-a716-446655440003', '880e8400-e29b-41d4-a716-446655440002');

-- Dua beğenileri
INSERT INTO likes (user_id, dua_request_id) VALUES
('550e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440001'),
('550e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440002');