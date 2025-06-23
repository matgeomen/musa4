-- İslami Sosyal Platform Veritabanı Şeması
-- MySQL için oluşturulmuştur

CREATE DATABASE IF NOT EXISTS islamic_platform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE islamic_platform;

-- Kullanıcılar tablosu
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    location VARCHAR(255),
    website VARCHAR(255),
    verified BOOLEAN DEFAULT FALSE,
    role ENUM('user', 'admin', 'moderator') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username)
);

-- Gönderiler tablosu
CREATE TABLE IF NOT EXISTS posts (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    content TEXT NOT NULL,
    type ENUM('text', 'image', 'video') DEFAULT 'text',
    media_url TEXT,
    category VARCHAR(100) DEFAULT 'Genel',
    tags JSON,
    likes_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    shares_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_category (category)
);

-- Dua talepleri tablosu
CREATE TABLE IF NOT EXISTS dua_requests (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    is_urgent BOOLEAN DEFAULT FALSE,
    is_anonymous BOOLEAN DEFAULT FALSE,
    tags JSON,
    prayers_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_category (category),
    INDEX idx_urgent (is_urgent)
);

-- Yorumlar tablosu
CREATE TABLE IF NOT EXISTS comments (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    post_id VARCHAR(36) NULL,
    dua_request_id VARCHAR(36) NULL,
    content TEXT NOT NULL,
    is_prayer BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (dua_request_id) REFERENCES dua_requests(id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id),
    INDEX idx_dua_request_id (dua_request_id),
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at DESC),
    CONSTRAINT chk_single_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Beğeniler tablosu
CREATE TABLE IF NOT EXISTS likes (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    post_id VARCHAR(36) NULL,
    dua_request_id VARCHAR(36) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (dua_request_id) REFERENCES dua_requests(id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id),
    INDEX idx_dua_request_id (dua_request_id),
    UNIQUE KEY unique_user_post (user_id, post_id),
    UNIQUE KEY unique_user_dua (user_id, dua_request_id),
    CONSTRAINT chk_like_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Yer imleri tablosu
CREATE TABLE IF NOT EXISTS bookmarks (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    post_id VARCHAR(36) NULL,
    dua_request_id VARCHAR(36) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (dua_request_id) REFERENCES dua_requests(id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id),
    INDEX idx_dua_request_id (dua_request_id),
    UNIQUE KEY unique_user_post_bookmark (user_id, post_id),
    UNIQUE KEY unique_user_dua_bookmark (user_id, dua_request_id),
    CONSTRAINT chk_bookmark_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Topluluklar tablosu
CREATE TABLE IF NOT EXISTS communities (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    is_private BOOLEAN DEFAULT FALSE,
    cover_image TEXT,
    location VARCHAR(255),
    member_count INT DEFAULT 1,
    created_by VARCHAR(36) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_created_by (created_by),
    INDEX idx_created_at (created_at DESC),
    INDEX idx_category (category)
);

-- Topluluk üyeleri tablosu
CREATE TABLE IF NOT EXISTS community_members (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    community_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    role ENUM('member', 'admin', 'moderator') DEFAULT 'member',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (community_id) REFERENCES communities(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_community_user (community_id, user_id),
    INDEX idx_community_id (community_id),
    INDEX idx_user_id (user_id)
);

-- Etkinlikler tablosu
CREATE TABLE IF NOT EXISTS events (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    type VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    location_name VARCHAR(255) NOT NULL,
    location_address TEXT NOT NULL,
    location_city VARCHAR(100) NOT NULL,
    organizer_name VARCHAR(255) NOT NULL,
    organizer_contact VARCHAR(255),
    capacity INT DEFAULT 100,
    attendees_count INT DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0,
    is_online BOOLEAN DEFAULT FALSE,
    image_url TEXT,
    tags JSON,
    requirements JSON,
    created_by VARCHAR(36) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_created_by (created_by),
    INDEX idx_date (date),
    INDEX idx_type (type),
    INDEX idx_city (location_city)
);

-- Etkinlik katılımcıları tablosu
CREATE TABLE IF NOT EXISTS event_attendees (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    event_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_event_user (event_id, user_id),
    INDEX idx_event_id (event_id),
    INDEX idx_user_id (user_id)
);

-- Oturumlar tablosu (session yönetimi için)
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at)
);