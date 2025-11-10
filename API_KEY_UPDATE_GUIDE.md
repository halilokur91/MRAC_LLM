# 🔑 API Anahtarı ve Sohbet Sistemi Güncelleme Rehberi

## ✅ Yapılan Güncellemeler (Tamamlandı)

### 1. GPT Model Seçenekleri Genişletildi
- ✨ **gpt-4o**
- ✨ **gpt-4o-mini** (varsayılan - en ekonomik)
- ✨ **gpt-4-turbo**
- ✨ **gpt-4**
- ✨ **gpt-3.5-turbo**

### 2. API Anahtarı Otomatik Yükleme
- Yeni API anahtarınız `config.json` dosyasına kaydedildi
- Uygulama başlangıcında otomatik yüklenir

### 3. Dinamik Model Seçimi
- Seçtiğiniz model artık tüm GPT çağrılarında kullanılır
- ChatAnalyzer otomatik olarak seçili modeli kullanır

### 4. Gelişmiş Debug Sistemi
- API anahtarı güncellemelerinde detaylı log mesajları
- Sohbet geçmişinde sistem bildirimleri

## 📋 Sohbet Sistemini Aktif Etme Adımları

### Adım 1: API Anahtarını Kaydetme
1. **Ayarlar (Settings)** sekmesine gidin
2. "OpenAI API Key" alanına anahtarınızı girin (zaten kaydedildi)
3. "GPT Model" dropdown'ından model seçin
4. **"Save Settings"** butonuna tıklayın

### Adım 2: Kontrol Edin
**Command Window'da şu mesajları göreceksiniz:**
```
🔄 ChatManager API anahtarı güncelleniyor...
🔍 ChatManager.updateApiKey() başlatıldı
   → SettingsManager kullanılıyor
   → API anahtarı alındı (uzunluk: XXX)
   → API anahtarı geçerli, ChatAnalyzer oluşturuluyor...
   → Seçili model: gpt-4o-mini
✅ ChatAnalyzer oluşturuldu (Model: gpt-4o-mini)
✅ ChatManager: ChatAnalyzer başarıyla oluşturuldu (centralized settings)
   → ChatAnalyzer durumu: true
🏁 ChatManager.updateApiKey() tamamlandı (ChatAnalyzer: true)
✅ ChatManager API anahtarı güncellendi
```

### Adım 3: Sohbet Sekmesinde Test Edin
1. **Sohbet (Chat)** sekmesine geçin
2. Sohbet geçmişinde şu mesajı göreceksiniz:
   ```
   [HH:MM] ✅ Sistem: API anahtarı güncellendi! GPT özellikleri aktif.
   ```
3. Bir mesaj yazın ve gönderin (örn: "merhaba")

## ❌ Sorun Giderme

### "GPT özellikleri aktif değil" Hatası
**Çözüm 1: Command Window'u Kontrol Edin**
- Yukarıdaki başarı mesajlarını görüyor musunuz?
- Herhangi bir hata mesajı var mı?

**Çözüm 2: API Bağlantısını Test Edin**
1. **Ayarlar** sekmesine gidin
2. **"🔗 API Connection Test"** butonuna tıklayın
3. Başarılı olursa, sohbet sistemi de çalışmalı

**Çözüm 3: Uygulamayı Yeniden Başlatın**
1. Uygulamayı kapatın
2. MATLAB Command Window'da şunu çalıştırın:
   ```matlab
   clear all
   MRACApp
   ```
3. Uygulama başlarken otomatik olarak ayarları yükleyecek

**Çözüm 4: Ayarları Manuel Kontrol Edin**
```matlab
% SettingsManager'ı kontrol et
settings = GlobalSettings();
settings.displaySettings();

% Config dosyasını kontrol et
cfg = loadApiConfig();
disp(cfg);
```

## 🎯 Kullanım Önerileri

### Model Seçimi
- **Hızlı Testler:** `gpt-3.5-turbo` veya `gpt-4o-mini`
- **Günlük Kullanım:** `gpt-4o-mini` (önerilen)
- **Üretim/Kritik:** `gpt-4o` veya `gpt-4-turbo`
- **En İyi Sonuçlar:** `gpt-4` (daha yavaş ama en doğru)

### Maliyet Optimizasyonu
- `gpt-4o-mini`: En ucuz, çoğu kullanım için yeterli
- `gpt-3.5-turbo`: Hızlı ve ekonomik, basit sorular için ideal
- `gpt-4o`: Dengeli performans/maliyet
- `gpt-4`: En pahalı, karmaşık analizler için

## 🔧 Teknik Detaylar

### Dosya Yapısı
```
mrac_llm - v3/
├── config.json              # API anahtarı ve model ayarları
├── mrac_settings.mat        # Tüm uygulama ayarları
├── MRACApp.m                # Ana uygulama
└── utils/
    ├── GlobalSettings.m      # Singleton settings manager
    ├── SettingsManager.m     # Merkezi ayar yönetimi
    ├── loadApiConfig.m       # Ayarları yükleme
    ├── saveApiConfig.m       # Ayarları kaydetme
    ├── ChatManager.m         # Sohbet sistemi yöneticisi
    └── ChatAnalyzer.m        # GPT analiz motoru
```

### Ayar Senkronizasyonu
1. **Save Settings** butonu tıklandığında:
   - `SettingsManager` → `mrac_settings.mat` dosyasını günceller
   - `saveApiConfig()` → `config.json` dosyasını günceller
   - `ChatManager.updateApiKey()` → Sohbet sistemini yeniler
   - Sohbet geçmişine bildirim ekler

2. **Uygulama Başlangıcında:**
   - `GlobalSettings()` → Singleton instance oluşturur
   - `loadApiConfig()` → `config.json`'dan ayarları yükler
   - `ChatManager()` → Sohbet sistemini başlatır
   - API anahtarı varsa otomatik aktif olur

## 📞 Destek

Sorun devam ederse:
1. Command Window'daki tüm mesajları kaydedin
2. Hata mesajlarını not edin
3. Kullandığınız işletim sistemini belirtin

---

**Son Güncelleme:** 9 Ekim 2025
**Versiyon:** v3.1
**Durum:** ✅ Tüm güncellemeler tamamlandı

