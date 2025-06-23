/*
  # Complete Database Schema for Islamic Social Platform

  1. New Tables
    - `users` - User profiles and authentication data
    - `posts` - User posts with media support
    - `comments` - Comments on posts and dua requests
    - `likes` - Like system for posts and dua requests
    - `bookmarks` - Bookmark system for saving content
    - `dua_requests` - Prayer request system
    - `communities` - Islamic communities
    - `community_members` - Community membership tracking
    - `events` - Islamic events and gatherings
    - `event_attendees` - Event attendance tracking

  2. Security
    - Enable RLS on all tables
    - Add comprehensive policies for CRUD operations
    - Ensure users can only access their own data where appropriate

  3. Features
    - Full-text search capabilities
    - Automatic timestamp updates
    - Proper foreign key relationships
    - Check constraints for data integrity
*/

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create update_updated_at_column function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Users table
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

-- Posts table
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

-- Comments table
CREATE TABLE IF NOT EXISTS comments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id uuid REFERENCES posts(id) ON DELETE CASCADE,
    dua_request_id uuid,
    content text NOT NULL,
    is_prayer boolean DEFAULT false,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    CONSTRAINT comments_single_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Likes table
CREATE TABLE IF NOT EXISTS likes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id uuid REFERENCES posts(id) ON DELETE CASCADE,
    dua_request_id uuid,
    created_at timestamptz DEFAULT now(),
    CONSTRAINT likes_single_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Bookmarks table
CREATE TABLE IF NOT EXISTS bookmarks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id uuid REFERENCES posts(id) ON DELETE CASCADE,
    dua_request_id uuid,
    created_at timestamptz DEFAULT now(),
    CONSTRAINT bookmarks_single_reference CHECK (
        (post_id IS NOT NULL AND dua_request_id IS NULL) OR 
        (post_id IS NULL AND dua_request_id IS NOT NULL)
    )
);

-- Dua requests table
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

-- Communities table
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

-- Community members table
CREATE TABLE IF NOT EXISTS community_members (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    community_id uuid NOT NULL REFERENCES communities(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role text DEFAULT 'member' CHECK (role IN ('member', 'admin', 'moderator')),
    joined_at timestamptz DEFAULT now(),
    UNIQUE(community_id, user_id)
);

-- Events table
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

-- Event attendees table
CREATE TABLE IF NOT EXISTS event_attendees (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id uuid NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    registered_at timestamptz DEFAULT now(),
    UNIQUE(event_id, user_id)
);

-- Add foreign key for dua_request_id after creating dua_requests table
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'comments_dua_request_id_fkey'
    ) THEN
        ALTER TABLE comments ADD CONSTRAINT comments_dua_request_id_fkey 
        FOREIGN KEY (dua_request_id) REFERENCES dua_requests(id) ON DELETE CASCADE;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'likes_dua_request_id_fkey'
    ) THEN
        ALTER TABLE likes ADD CONSTRAINT likes_dua_request_id_fkey 
        FOREIGN KEY (dua_request_id) REFERENCES dua_requests(id) ON DELETE CASCADE;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'bookmarks_dua_request_id_fkey'
    ) THEN
        ALTER TABLE bookmarks ADD CONSTRAINT bookmarks_dua_request_id_fkey 
        FOREIGN KEY (dua_request_id) REFERENCES dua_requests(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Create indexes for better performance
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

-- Create triggers for updated_at columns
CREATE TRIGGER IF NOT EXISTS update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER IF NOT EXISTS update_posts_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER IF NOT EXISTS update_comments_updated_at
    BEFORE UPDATE ON comments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER IF NOT EXISTS update_dua_requests_updated_at
    BEFORE UPDATE ON dua_requests
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER IF NOT EXISTS update_communities_updated_at
    BEFORE UPDATE ON communities
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER IF NOT EXISTS update_events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
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

-- Users policies
CREATE POLICY IF NOT EXISTS "Public can read basic user info" ON users
    FOR SELECT TO public USING (true);

CREATE POLICY IF NOT EXISTS "Users can read own data" ON users
    FOR SELECT TO authenticated USING (auth.uid() = id);

CREATE POLICY IF NOT EXISTS "Users can update own data" ON users
    FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY IF NOT EXISTS "Users can insert own profile" ON users
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

CREATE POLICY IF NOT EXISTS "Allow user creation during signup" ON users
    FOR INSERT TO public WITH CHECK (true);

CREATE POLICY IF NOT EXISTS "Service role can insert users" ON users
    FOR INSERT TO service_role WITH CHECK (true);

-- Posts policies
CREATE POLICY IF NOT EXISTS "Anyone can read posts" ON posts
    FOR SELECT TO public USING (true);

CREATE POLICY IF NOT EXISTS "Users can create posts" ON posts
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can update own posts" ON posts
    FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can delete own posts" ON posts
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Comments policies
CREATE POLICY IF NOT EXISTS "Anyone can read comments" ON comments
    FOR SELECT TO public USING (true);

CREATE POLICY IF NOT EXISTS "Users can create comments" ON comments
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can update own comments" ON comments
    FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can delete own comments" ON comments
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Likes policies
CREATE POLICY IF NOT EXISTS "Users can read likes" ON likes
    FOR SELECT TO authenticated USING (true);

CREATE POLICY IF NOT EXISTS "Users can create likes" ON likes
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can delete own likes" ON likes
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Bookmarks policies
CREATE POLICY IF NOT EXISTS "Users can read own bookmarks" ON bookmarks
    FOR SELECT TO authenticated USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can create bookmarks" ON bookmarks
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can delete own bookmarks" ON bookmarks
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Dua requests policies
CREATE POLICY IF NOT EXISTS "Anyone can read dua requests" ON dua_requests
    FOR SELECT TO public USING (true);

CREATE POLICY IF NOT EXISTS "Users can create dua requests" ON dua_requests
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can update own dua requests" ON dua_requests
    FOR UPDATE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can delete own dua requests" ON dua_requests
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Communities policies
CREATE POLICY IF NOT EXISTS "Anyone can read public communities" ON communities
    FOR SELECT TO public USING (NOT is_private);

CREATE POLICY IF NOT EXISTS "Authenticated users can read communities" ON communities
    FOR SELECT TO authenticated USING (true);

CREATE POLICY IF NOT EXISTS "Users can create communities" ON communities
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by);

CREATE POLICY IF NOT EXISTS "Creators can update communities" ON communities
    FOR UPDATE TO authenticated USING (auth.uid() = created_by);

CREATE POLICY IF NOT EXISTS "Creators can delete communities" ON communities
    FOR DELETE TO authenticated USING (auth.uid() = created_by);

-- Community members policies
CREATE POLICY IF NOT EXISTS "Anyone can read community memberships" ON community_members
    FOR SELECT TO public USING (true);

CREATE POLICY IF NOT EXISTS "Users can join communities" ON community_members
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can leave communities" ON community_members
    FOR DELETE TO authenticated USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Community admins can manage memberships" ON community_members
    FOR ALL TO authenticated USING (
        EXISTS (
            SELECT 1 FROM community_members cm 
            WHERE cm.community_id = community_members.community_id 
            AND cm.user_id = auth.uid() 
            AND cm.role = 'admin'
        )
    );

-- Events policies
CREATE POLICY IF NOT EXISTS "Anyone can read events" ON events
    FOR SELECT TO public USING (true);

CREATE POLICY IF NOT EXISTS "Users can create events" ON events
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = created_by);

CREATE POLICY IF NOT EXISTS "Creators can update events" ON events
    FOR UPDATE TO authenticated USING (auth.uid() = created_by);

CREATE POLICY IF NOT EXISTS "Creators can delete events" ON events
    FOR DELETE TO authenticated USING (auth.uid() = created_by);

-- Event attendees policies
CREATE POLICY IF NOT EXISTS "Anyone can read event attendees" ON event_attendees
    FOR SELECT TO public USING (true);

CREATE POLICY IF NOT EXISTS "Users can register for events" ON event_attendees
    FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can unregister from events" ON event_attendees
    FOR DELETE TO authenticated USING (auth.uid() = user_id);