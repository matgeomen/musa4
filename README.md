# İslami Sosyal Paylaşım Platformu

Modern ve kullanıcı dostu bir İslami sosyal medya platformu. React, TypeScript, Tailwind CSS ve Supabase teknolojileri kullanılarak geliştirilmiştir.

## 🌟 Özellikler

### 📱 Temel Özellikler
- **Kullanıcı Yönetimi**: Kayıt olma, giriş yapma, profil yönetimi
- **Gönderi Paylaşımı**: Metin, resim ve video paylaşımı
- **Etkileşim**: Beğeni, yorum, paylaşım sistemi
- **Dua Talepleri**: Özel dua istekleri bölümü
- **Topluluklar**: İslami topluluklar oluşturma ve katılma
- **Etkinlikler**: İslami etkinlik duyuruları ve katılım

### 🎨 Tasarım Özellikleri
- **Çoklu Tema**: Aydınlık, karanlık, İslami ve Ramazan temaları
- **Responsive Tasarım**: Mobil ve masaüstü uyumlu
- **Modern UI**: Tailwind CSS ile şık arayüz
- **Animasyonlar**: Yumuşak geçişler ve mikro etkileşimler

### 🔒 Güvenlik
- **Row Level Security (RLS)**: Supabase ile güvenli veri erişimi
- **Kullanıcı Bazlı İzinler**: Her kullanıcı sadece kendi verilerine erişebilir
- **Rol Tabanlı Yetkilendirme**: Admin, moderatör ve kullanıcı rolleri

## 🚀 Kurulum

### Ön Gereksinimler
- Node.js (v18 veya üzeri)
- npm veya yarn
- Supabase hesabı

### 1. Projeyi Klonlayın
```bash
git clone <repository-url>
cd islamic-social-platform
```

### 2. Bağımlılıkları Yükleyin
```bash
npm install
```

### 3. Supabase Kurulumu

#### 3.1 Supabase Projesi Oluşturun
1. [Supabase](https://supabase.com) hesabınıza giriş yapın
2. "New Project" butonuna tıklayın
3. Proje adını girin (örn: "islamic-social-platform")
4. Güçlü bir veritabanı şifresi belirleyin
5. Bölge seçin (en yakın bölgeyi seçin)
6. "Create new project" butonuna tıklayın

#### 3.2 Veritabanı Şemasını Oluşturun
1. Supabase dashboard'unda "SQL Editor" sekmesine gidin
2. `supabase/migrations/create_complete_schema.sql` dosyasının içeriğini kopyalayın
3. SQL Editor'e yapıştırın ve "Run" butonuna tıklayın
4. `supabase/migrations/create_auth_trigger.sql` dosyasını da aynı şekilde çalıştırın
5. `supabase/migrations/insert_sample_data.sql` dosyasını çalıştırarak örnek verileri ekleyin

#### 3.3 Ortam Değişkenlerini Ayarlayın
1. `.env.example` dosyasını `.env` olarak kopyalayın
2. Supabase dashboard'unda "Settings" > "API" sekmesine gidin
3. "Project URL" ve "anon public" anahtarını kopyalayın
4. `.env` dosyasını düzenleyin:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

### 4. Uygulamayı Başlatın
```bash
npm run dev
```

Uygulama `http://localhost:5173` adresinde çalışacaktır.

## 📊 Veritabanı Şeması

### Tablolar
- **users**: Kullanıcı profilleri
- **posts**: Gönderiler
- **comments**: Yorumlar
- **likes**: Beğeniler
- **bookmarks**: Yer imleri
- **dua_requests**: Dua talepleri
- **communities**: Topluluklar
- **community_members**: Topluluk üyelikleri
- **events**: Etkinlikler
- **event_attendees**: Etkinlik katılımcıları

### Güvenlik Politikaları
Her tablo için Row Level Security (RLS) politikaları tanımlanmıştır:
- Kullanıcılar sadece kendi verilerini düzenleyebilir
- Genel okuma izinleri herkese açık
- Admin kullanıcıları ek yetkilere sahip

## 🛠️ Teknolojiler

### Frontend
- **React 18**: Modern React hooks ve bileşenler
- **TypeScript**: Tip güvenliği
- **Tailwind CSS**: Utility-first CSS framework
- **Lucide React**: Modern ikonlar
- **React Router**: Sayfa yönlendirme

### Backend
- **Supabase**: Backend-as-a-Service
- **PostgreSQL**: Veritabanı
- **Row Level Security**: Güvenlik katmanı
- **Real-time subscriptions**: Canlı güncellemeler

### Geliştirme Araçları
- **Vite**: Hızlı geliştirme sunucusu
- **ESLint**: Kod kalitesi
- **TypeScript**: Tip kontrolü

## 📱 Kullanım

### Test Hesapları
Geliştirme aşamasında kullanabileceğiniz test hesapları:

**Normal Kullanıcı:**
- E-posta: `ahmet@example.com`
- Şifre: `123456`

**Admin Kullanıcı:**
- E-posta: `admin@islamic.com`
- Şifre: `123456`

### Temel İşlevler

#### Gönderi Paylaşma
1. Ana sayfada "Neler düşünüyorsun?" alanına tıklayın
2. İçeriğinizi yazın
3. İsteğe bağlı olarak kategori ve etiket ekleyin
4. "Paylaş" butonuna tıklayın

#### Dua Talebi Oluşturma
1. Sidebar'da "Dua Talepleri" bölümüne gidin
2. "Yeni Dua Talebi" butonuna tıklayın
3. Başlık ve içerik girin
4. Kategori seçin
5. Acil durumsa "Acil" işaretleyin
6. "Paylaş" butonuna tıklayın

#### Topluluk Oluşturma
1. "Topluluklar" sayfasına gidin
2. "Yeni Topluluk" butonuna tıklayın
3. Topluluk bilgilerini doldurun
4. "Oluştur" butonuna tıklayın

## 🎨 Tema Sistemi

Platform 4 farklı tema sunar:
- **Aydınlık**: Klasik beyaz tema
- **Karanlık**: Göz dostu karanlık tema
- **İslami**: Yeşil tonlarında İslami tema
- **Ramazan**: Mor tonlarında özel Ramazan teması

Tema değiştirmek için navbar'daki tema butonlarını kullanın.

## 🔧 Geliştirme

### Proje Yapısı
```
src/
├── components/          # React bileşenleri
├── contexts/           # React context'leri
├── hooks/              # Custom hook'lar
├── lib/                # Yardımcı kütüphaneler
├── types/              # TypeScript tip tanımları
└── styles/             # CSS dosyaları

supabase/
├── migrations/         # Veritabanı migration'ları
└── functions/          # Edge functions (gelecekte)
```

### Yeni Özellik Ekleme
1. Gerekli veritabanı değişikliklerini migration olarak ekleyin
2. TypeScript tiplerini güncelleyin
3. API helper fonksiyonlarını ekleyin
4. React bileşenlerini oluşturun
5. Hook'ları implement edin

### Kod Standartları
- TypeScript kullanın
- ESLint kurallarına uyun
- Bileşenleri küçük ve odaklanmış tutun
- Custom hook'lar kullanarak logic'i ayırın

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 🤝 Katkıda Bulunma

1. Projeyi fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📞 İletişim

Sorularınız için GitHub Issues kullanabilirsiniz.

---

**Not**: Bu platform İslami değerlere uygun içerik paylaşımı için tasarlanmıştır. Lütfen paylaşımlarınızda bu değerlere saygı gösterin.