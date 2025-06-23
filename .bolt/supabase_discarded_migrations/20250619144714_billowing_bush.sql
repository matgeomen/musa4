/*
  # Tam Veritabanı Şeması Oluşturma

  1. Yeni Tablolar
    - `users` - Kullanıcı profilleri
    - `posts` - Gönderiler
    - `comments` - Yorumlar
    - `likes` - Beğeniler
    - `bookmarks` - Yer imleri
    - `dua_requests` - Dua talepleri
    - `communities` - Topluluklar
    - `community_members` - Topluluk üyelikleri
    - `events` - Etkinlikler
    - `event_attendees` - Etkinlik katılımcıları

  2. Güvenlik
    - Tüm tablolar için RLS etkin
    - Kullanıcı bazlı erişim politikaları
    - Güvenli veri erişimi

  3. İndeksler
    - Performans için gerekli indeksler
    - Benzersizlik kısıtlamaları
    - Arama optimizasyonu
*/

-- Gerekli uzantıları etkinleştir
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- updated_at sütunu için fonksiyon
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Kullanıcılar tablosu
CREATE TABLE IF NOT EXISTS users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text UNIQUE NOT NULL,
    name text NOT NULL,
    username text UNIQUE NOT NULL,
    avatar_url text,
    bio text,
    location text,
    website text,
    verified boolean DEFAULT false,
    role text DEFAULT 'user' CHECK (role IN ('user', 'admin', 'moderator')),
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Gönderiler tablosu
CREATE TABLE IF NOT EXISTS posts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content text NOT NULL,
    type text DEFAULT 'text' CHECK (type IN ('text', 'image', 'video')),
    media_url text,
    category text DEFAULT 'Genel',
    tags text[] DEFAULT '{}',
    likes_count integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    shares_count integer DEFAULT 0,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Dua talepleri tablosu
CREATE TABLE IF NOT EXISTS dua_requests (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title text NOT NULL,
    content text NOT NULL,
    category text NOT NULL,
    is_urgent boolean DEFAULT false,
    is_anonymous boolean DEFAULT false,
    tags text[] DEFAULT '{}',
    prayers_count integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Yorumlar tablosu
CREATE TABLE IF NOT EXISTS comments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id uuid REFERENCES posts(id) ON DELETE CASCADE,
    dua_request_id uuid REFERENCES dua_requests(id) ON DELETE CASCADE,
    content text NOT NULL,
    is_prayer boolean DEFAULT false,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    CONSTRAINT comments_single_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Beğeniler tablosu
CREATE TABLE IF NOT EXISTS likes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id uuid REFERENCES posts(id) ON DELETE CASCADE,
    dua_request_id uuid REFERENCES dua_requests(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),
    CONSTRAINT likes_single_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Yer imleri tablosu
CREATE TABLE IF NOT EXISTS bookmarks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id uuid REFERENCES posts(id) ON DELETE CASCADE,
    dua_request_id uuid REFERENCES dua_requests(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),
    CONSTRAINT bookmarks_single_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Topluluklar tablosu
CREATE TABLE IF NOT EXISTS communities (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text NOT NULL,
    category text NOT NULL,
    is_private boolean DEFAULT false,
    cover_image text,
    location text,
    member_count integer DEFAULT 1,
    created_by uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Topluluk üyeleri tablosu
CREATE TABLE IF NOT EXISTS community_members (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    community_id uuid NOT NULL REFERENCES communities(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role text DEFAULT 'member' CHECK (role IN ('member', 'admin', 'moderator')),
    joined_at timestamptz DEFAULT now(),
    UNIQUE(community_id, user_id)
);

-- Etkinlikler tablosu
CREATE TABLE IF NOT EXISTS events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    description text NOT NULL,
    type text NOT NULL,
    date date NOT NULL,
    time time NOT NULL,
    location_name text NOT NULL,
    location_address text NOT NULL,
    location_city text NOT NULL,
    organizer_name text NOT NULL,
    organizer_contact text,
    capacity integer DEFAULT 100,
    attendees_count integer DEFAULT 0,
    price numeric(10,2) DEFAULT 0,
    is_online boolean DEFAULT false,
    image_url text,
    tags text[] DEFAULT '{}',
    requirements text[] DEFAULT '{}',
    created_by uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Etkinlik katılımcıları tablosu
CREATE TABLE IF NOT EXISTS event_attendees (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    registered_at timestamptz DEFAULT now(),
    UNIQUE(event_id, user_id)
);

-- Performans için indeksler
CREATE INDEX IF NOT EXISTS users_email_idx ON users(email);
CREATE INDEX IF NOT EXISTS users_username_idx ON users(username);

CREATE INDEX IF NOT EXISTS posts_user_id_idx ON posts(user_id);
CREATE INDEX IF NOT EXISTS posts_created_at_idx ON posts(created_at DESC);
CREATE INDEX IF NOT EXISTS posts_category_idx ON posts(category);

CREATE INDEX IF NOT EXISTS comments_post_id_idx ON comments(post_id);
CREATE INDEX IF NOT EXISTS comments_dua_request_id_idx ON comments(dua_request_id);
CREATE INDEX IF NOT EXISTS comments_user_id_idx ON comments(user_id);
CREATE INDEX IF NOT EXISTS comments_created_at_idx ON comments(created_at DESC);

CREATE INDEX IF NOT EXISTS likes_post_id_idx ON likes(post_id);
CREATE INDEX IF NOT EXISTS likes_dua_request_id_idx ON likes(dua_request_id);
CREATE UNIQUE INDEX IF NOT EXISTS likes_user_post_unique ON likes(user_id, post_id) WHERE post_id IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS likes_user_dua_request_unique ON likes(user_id, dua_request_id) WHERE dua_request_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS bookmarks_post_id_idx ON bookmarks(post_id);
CREATE INDEX IF NOT EXISTS bookmarks_dua_request_id_idx ON bookmarks(dua_request_id);
CREATE UNIQUE INDEX IF NOT EXISTS bookmarks_user_post_unique ON bookmarks(user_id, post_id) WHERE post_id IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS bookmarks_user_dua_request_unique ON bookmarks(user_id, dua_request_id) WHERE dua_request_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS dua_requests_user_id_idx ON dua_requests(user_id);
CREATE INDEX IF NOT EXISTS dua_requests_created_at_idx ON dua_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS dua_requests_category_idx ON dua_requests(category);
CREATE INDEX IF NOT EXISTS dua_requests_urgent_idx ON dua_requests(is_urgent);

CREATE INDEX IF NOT EXISTS communities_created_by_idx ON communities(created_by);
CREATE INDEX IF NOT EXISTS communities_created_at_idx ON communities(created_at DESC);
CREATE INDEX IF NOT EXISTS communities_category_idx ON communities(category);

CREATE INDEX IF NOT EXISTS community_members_community_id_idx ON community_members(community_id);
CREATE INDEX IF NOT EXISTS community_members_user_id_idx ON community_members(user_id);

CREATE INDEX IF NOT EXISTS events_created_by_idx ON events(created_by);
CREATE INDEX IF NOT EXISTS events_date_idx ON events(date);
CREATE INDEX IF NOT EXISTS events_type_idx ON events(type);
CREATE INDEX IF NOT EXISTS events_city_idx ON events(location_city);

CREATE INDEX IF NOT EXISTS event_attendees_event_id_idx ON event_attendees(event_id);
CREATE INDEX IF NOT EXISTS event_attendees_user_id_idx ON event_attendees(user_id);

-- updated_at tetikleyicileri
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at
    BEFORE UPDATE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dua_requests_updated_at
    BEFORE UPDATE ON dua_requests
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_communities_updated_at
    BEFORE UPDATE ON communities
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security'yi etkinleştir
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE dua_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_attendees ENABLE ROW LEVEL SECURITY;

-- Kullanıcılar için güvenlik politikaları
CREATE POLICY "Herkes kullanıcı bilgilerini okuyabilir" ON users
    FOR SELECT TO public USING (true);

CREATE POLICY "Kullanıcılar kendi verilerini okuyabilir" ON users
    FOR SELECT TO authenticated USING (auth.uid() = id);

CREATE POLICY "Kullanıcılar kendi verilerini güncelleyebilir" ON users
    FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY "Kullanıcılar kendi profilini oluşturabilir" ON users
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

CREATE POLICY "Kayıt sırasında kullanıcı oluşturma" ON users
    FOR INSERT TO public WITH CHECK (true);

CREATE POLICY "Servis rolü kullanıcı oluşturabilir" ON users
    FOR INSERT TO service_role WITH CHECK (true);

-- Gönderiler için güvenlik politikaları
CREATE POLICY "Herkes gönderileri okuyabilir" ON posts
    FOR SELECT TO public USING (true);

CREATE POLICY "Kullanıcılar gönderi oluşturabilir" ON posts
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi gönderilerini güncelleyebilir" ON posts
    FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi gönderilerini silebilir" ON posts
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Yorumlar için güvenlik politikaları
CREATE POLICY "Herkes yorumları okuyabilir" ON comments
    FOR SELECT TO public USING (true);

CREATE POLICY "Kullanıcılar yorum yapabilir" ON comments
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi yorumlarını güncelleyebilir" ON comments
    FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi yorumlarını silebilir" ON comments
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Beğeniler için güvenlik politikaları
CREATE POLICY "Kullanıcılar beğenileri görebilir" ON likes
    FOR SELECT TO authenticated USING (true);

CREATE POLICY "Kullanıcılar beğeni yapabilir" ON likes
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi beğenilerini silebilir" ON likes
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Yer imleri için güvenlik politikaları
CREATE POLICY "Kullanıcılar kendi yer imlerini görebilir" ON bookmarks
    FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar yer imi oluşturabilir" ON bookmarks
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi yer imlerini silebilir" ON bookmarks
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Dua talepleri için güvenlik politikaları
CREATE POLICY "Herkes dua taleplerini okuyabilir" ON dua_requests
    FOR SELECT TO public USING (true);

CREATE POLICY "Kullanıcılar dua talebi oluşturabilir" ON dua_requests
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi dua taleplerini güncelleyebilir" ON dua_requests
    FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi dua taleplerini silebilir" ON dua_requests
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Topluluklar için güvenlik politikaları
CREATE POLICY "Herkes açık toplulukları görebilir" ON communities
    FOR SELECT TO public USING (NOT is_private);

CREATE POLICY "Kimlik doğrulanmış kullanıcılar toplulukları görebilir" ON communities
    FOR SELECT TO authenticated USING (true);

CREATE POLICY "Kullanıcılar topluluk oluşturabilir" ON communities
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Oluşturanlar topluluklarını güncelleyebilir" ON communities
    FOR UPDATE TO authenticated USING (auth.uid() = created_by);

CREATE POLICY "Oluşturanlar topluluklarını silebilir" ON communities
    FOR DELETE TO authenticated USING (auth.uid() = created_by);

-- Topluluk üyeleri için güvenlik politikaları
CREATE POLICY "Herkes topluluk üyeliklerini görebilir" ON community_members
    FOR SELECT TO public USING (true);

CREATE POLICY "Kullanıcılar topluluklara katılabilir" ON community_members
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar topluluktan ayrılabilir" ON community_members
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Topluluk yöneticileri üyelikleri yönetebilir" ON community_members
    FOR ALL TO authenticated USING (
        EXISTS (
            SELECT 1 FROM community_members cm 
            WHERE cm.community_id = community_members.community_id 
            AND cm.user_id = auth.uid() 
            AND cm.role = 'admin'
        )
    );

-- Etkinlikler için güvenlik politikaları
CREATE POLICY "Herkes etkinlikleri görebilir" ON events
    FOR SELECT TO public USING (true);

CREATE POLICY "Kullanıcılar etkinlik oluşturabilir" ON events
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Oluşturanlar etkinliklerini güncelleyebilir" ON events
    FOR UPDATE TO authenticated USING (auth.uid() = created_by);

CREATE POLICY "Oluşturanlar etkinliklerini silebilir" ON events
    FOR DELETE TO authenticated USING (auth.uid() = created_by);

-- Etkinlik katılımcıları için güvenlik politikaları
CREATE POLICY "Herkes etkinlik katılımcılarını görebilir" ON event_attendees
    FOR SELECT TO public USING (true);

CREATE POLICY "Kullanıcılar etkinliklere katılabilir" ON event_attendees
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar etkinlikten ayrılabilir" ON event_attendees
    FOR DELETE TO authenticated USING (auth.uid() = user_id);