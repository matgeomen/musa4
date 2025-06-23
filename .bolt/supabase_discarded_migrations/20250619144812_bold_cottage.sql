/*
  # Kimlik Doğrulama Tetikleyicisi

  1. Yeni Kullanıcı Fonksiyonu
    - Auth.users tablosuna eklenen her yeni kullanıcı için otomatik profil oluşturma
    - Metadata'dan kullanıcı bilgilerini alma
    - Hata durumlarında güvenli işleme

  2. Tetikleyici
    - Auth signup sonrası otomatik çalışma
    - Profil oluşturma işlemini otomatikleştirme

  3. İzinler
    - Gerekli fonksiyon izinleri
    - Güvenlik ayarları
*/

-- Yeni kullanıcı işleme fonksiyonu
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
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
        role
    )
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
        COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1) || '_' || substr(NEW.id::text, 1, 8)),
        NEW.raw_user_meta_data->>'avatar_url',
        NEW.raw_user_meta_data->>'bio',
        NEW.raw_user_meta_data->>'location',
        NEW.raw_user_meta_data->>'website',
        COALESCE((NEW.raw_user_meta_data->>'verified')::boolean, false),
        CASE 
            WHEN NEW.email = 'admin@islamic.com' THEN 'admin'::text
            ELSE COALESCE(NEW.raw_user_meta_data->>'role', 'user')::text
        END
    );
    RETURN NEW;
EXCEPTION
    WHEN unique_violation THEN
        -- Kullanıcı zaten mevcut, sadece devam et
        RETURN NEW;
    WHEN OTHERS THEN
        -- Hata durumunda uyarı ver ama auth işlemini engelleme
        RAISE WARNING 'Kullanıcı profili oluşturma hatası: %', SQLERRM;
        RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Mevcut tetikleyiciyi kaldır
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Yeni kullanıcı tetikleyicisi
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- Gerekli izinleri ver
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, service_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;
GRANT ALL ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, authenticated, service_role;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO postgres, anon, authenticated, service_role;