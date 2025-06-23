# Supabase Kurulum Talimatları

Bu dosya, İslami Sosyal Platform projesini Supabase ile entegre etmek için gerekli adımları içerir.

## 1. Supabase Projesi Oluşturma

### 1.1 Hesap Oluşturma
1. [Supabase](https://supabase.com) sitesine gidin
2. "Start your project" butonuna tıklayın
3. GitHub hesabınızla giriş yapın veya yeni hesap oluşturun

### 1.2 Yeni Proje Oluşturma
1. Dashboard'da "New Project" butonuna tıklayın
2. Organizasyon seçin (kişisel hesabınız)
3. Proje bilgilerini doldurun:
   - **Name**: `islamic-social-platform`
   - **Database Password**: Güçlü bir şifre oluşturun (kaydedin!)
   - **Region**: Size en yakın bölgeyi seçin (örn: Europe West)
4. "Create new project" butonuna tıklayın
5. Proje oluşturulmasını bekleyin (2-3 dakika)

## 2. Veritabanı Şemasını Oluşturma

### 2.1 SQL Editor'ı Açma
1. Supabase dashboard'unda sol menüden "SQL Editor" sekmesine tıklayın
2. "New query" butonuna tıklayın

### 2.2 Migration Dosyalarını Çalıştırma

**ADIM 1: Ana Şemayı Oluşturun**
1. `supabase/migrations/create_complete_schema.sql` dosyasının içeriğini kopyalayın
2. SQL Editor'e yapıştırın
3. "Run" butonuna tıklayın
4. Başarılı mesajını bekleyin

**ADIM 2: Auth Tetikleyicisini Ekleyin**
1. Yeni bir query açın
2. `supabase/migrations/create_auth_trigger.sql` dosyasının içeriğini kopyalayın
3. SQL Editor'e yapıştırın
4. "Run" butonuna tıklayın

**ADIM 3: RPC Fonksiyonlarını Ekleyin**
1. Yeni bir query açın
2. `supabase/migrations/create_rpc_functions.sql` dosyasının içeriğini kopyalayın
3. SQL Editor'e yapıştırın
4. "Run" butonuna tıklayın

**ADIM 4: Örnek Verileri Ekleyin**
1. Yeni bir query açın
2. `supabase/migrations/insert_sample_data.sql` dosyasının içeriğini kopyalayın
3. SQL Editor'e yapıştırın
4. "Run" butonuna tıklayın

### 2.3 Tabloları Kontrol Etme
1. Sol menüden "Table Editor" sekmesine tıklayın
2. Aşağıdaki tabloların oluştuğunu kontrol edin:
   - users
   - posts
   - dua_requests
   - likes
   - comments
   - bookmarks
   - communities
   - community_members
   - events
   - event_attendees

## 3. API Anahtarlarını Alma

### 3.1 Proje Ayarları
1. Sol menüden "Settings" sekmesine tıklayın
2. "API" alt sekmesine tıklayın

### 3.2 Anahtarları Kopyalama
1. **Project URL**: `https://your-project-id.supabase.co` formatında
2. **anon public**: `eyJ...` ile başlayan uzun anahtar

## 4. Ortam Değişkenlerini Ayarlama

### 4.1 .env Dosyası Oluşturma
1. Proje ana dizininde `.env` dosyası oluşturun
2. `.env.example` dosyasını referans alın
3. Aşağıdaki içeriği ekleyin:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### 4.2 Gerçek Değerleri Yerleştirme
1. `your-project-id` kısmını gerçek proje ID'niz ile değiştirin
2. `your-anon-key-here` kısmını gerçek anon anahtarınız ile değiştirin

## 5. Uygulamayı Test Etme

### 5.1 Geliştirme Sunucusunu Başlatma
```bash
npm run dev
```

### 5.2 Test Hesapları
Aşağıdaki test hesaplarını kullanabilirsiniz:

**Normal Kullanıcı:**
- E-posta: `ahmet@example.com`
- Şifre: `123456`

**Admin Kullanıcı:**
- E-posta: `admin@islamic.com`
- Şifre: `123456`

### 5.3 Fonksiyonları Test Etme
1. Giriş yapın
2. Yeni gönderi oluşturun
3. Gönderiyi beğenin
4. Yorum ekleyin
5. Dua talebi oluşturun
6. Topluluk oluşturun
7. Etkinlik oluşturun

## 6. Sorun Giderme

### 6.1 Yaygın Hatalar

**"Invalid API key" Hatası:**
- `.env` dosyasındaki anahtarları kontrol edin
- Supabase dashboard'dan anahtarları yeniden kopyalayın
- Sunucuyu yeniden başlatın (`npm run dev`)

**"Database error" Hatası:**
- Migration dosyalarının doğru çalıştığını kontrol edin
- SQL Editor'da hata mesajlarını inceleyin
- Tabloların oluştuğunu Table Editor'da kontrol edin

**"Auth error" Hatası:**
- Auth tetikleyicisinin çalıştığını kontrol edin
- Users tablosunun oluştuğunu kontrol edin
- RLS politikalarının aktif olduğunu kontrol edin

### 6.2 Veritabanını Sıfırlama
Eğer bir şeyler ters giderse:

1. SQL Editor'da şu komutu çalıştırın:
```sql
-- Tüm tabloları sil (DİKKAT: Tüm veriler silinir!)
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
```

2. Migration dosyalarını tekrar çalıştırın

### 6.3 Destek
- [Supabase Dokümantasyonu](https://supabase.com/docs)
- [Supabase Discord](https://discord.supabase.com)
- [GitHub Issues](https://github.com/supabase/supabase/issues)

## 7. Üretim Ortamı

### 7.1 Güvenlik Ayarları
1. RLS politikalarını gözden geçirin
2. API anahtarlarını güvenli tutun
3. CORS ayarlarını yapılandırın

### 7.2 Performans Optimizasyonu
1. İndeksleri kontrol edin
2. Query performansını izleyin
3. Connection pooling ayarlayın

### 7.3 Backup
1. Otomatik backup'ları aktif edin
2. Point-in-time recovery ayarlayın
3. Düzenli backup testleri yapın

---

Bu talimatları takip ederek Supabase entegrasyonunu başarıyla tamamlayabilirsiniz. Herhangi bir sorunla karşılaştığınızda, yukarıdaki sorun giderme bölümünü inceleyin.