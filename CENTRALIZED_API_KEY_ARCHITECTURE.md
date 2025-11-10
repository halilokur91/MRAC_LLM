# 🔑 Merkezi API Anahtarı Mimarisi

## 📋 Genel Bakış

API anahtarı artık **tek bir merkezi kaynaktan** yönetiliyor:
- ✅ **Tek Kaynak:** `config.json` dosyası
- ✅ **Tek Yönetici:** `SettingsManager` sınıfı
- ✅ **Tek Erişim Noktası:** `app.settingsManager.getApiKey()`

## 🏗️ Mimari Yapı

### Veri Akışı

```
Kullanıcı Girişi (GUI)
         ↓
   Save Settings
         ↓
   SettingsManager.setApiKey()
         ↓
   ┌─────────────────────────┐
   │   config.json           │  ← TEK KAYNAK
   │   {                     │
   │     "apiKey": "sk-..." │
   │     "model": "gpt-4o"  │
   │   }                     │
   └─────────────────────────┘
         ↓
   SettingsManager.getApiKey()
         ↓
   ┌─────────────────────────────────┐
   │  Tüm API Çağrıları              │
   │  • ChatManager                  │
   │  • Model Recommendations        │
   │  • Chat Messages                │
   │  • callGptApi_combined()        │
   └─────────────────────────────────┘
```

## 📂 Dosya Yapısı

### 1. config.json (Veri Deposu)
```json
{
  "apiKey": "sk-proj-...",
  "model": "gpt-4o-mini"
}
```

### 2. SettingsManager.m (Merkezi Yönetici)
```matlab
% API anahtarını kaydetme
settingsManager.setApiKey('sk-proj-...');
settingsManager.setModel('gpt-4o-mini');
settingsManager.saveSettings();

% API anahtarını alma
apiKey = settingsManager.getApiKey();
model = settingsManager.getModel();
apiConfig = settingsManager.getApiConfig();
```

### 3. GlobalSettings.m (Singleton Instance)
```matlab
% Global singleton instance
settings = GlobalSettings();
apiKey = settings.getApiKey();
```

## 🔧 Kullanım Örnekleri

### ✅ DOĞRU: Merkezi Erişim

```matlab
% MRACApp.m içinde - DOĞRU
apiConfig = struct(...
    'apiKey', app.settingsManager.getApiKey(), ...
    'model', app.settingsManager.getModel(), ...
    'temperature', 0.7
);
```

```matlab
% API anahtarı kontrolü - DOĞRU
currentApiKey = app.settingsManager.getApiKey();
if ~isempty(currentApiKey) && app.settingsManager.validateApiKey(currentApiKey)
    % API işlemleri...
end
```

### ❌ YANLIŞ: Yerel Property Kullanımı

```matlab
% ESKİ YOL - ARTIK KULLANILMIYOR
app.apiKey = 'sk-proj-...';  % ❌ Property kaldırıldı

% ESKİ YOL - ARTIK KULLANILMIYOR
apiConfig = struct('apiKey', app.apiKey, ...);  % ❌ Kullanma
```

## 🎯 Değişiklikler

### MRACApp.m Değişiklikleri

#### Property Kaldırıldı
```matlab
% ESKİ:
apiKey  char = '';  % ❌ KALDIRILDI

% YENİ:
% apiKey removed - use app.settingsManager.getApiKey() instead
```

#### Tüm Kullanımlar Güncellendi
```matlab
% ESKİ:
if ~isempty(app.apiKey)
    apiConfig = struct('apiKey', app.apiKey, ...);
end

% YENİ:
currentApiKey = app.settingsManager.getApiKey();
if ~isempty(currentApiKey)
    apiConfig = struct('apiKey', currentApiKey, ...);
end
```

### Güncellenen Fonksiyonlar

1. **getGptModelRecommendation()**
   - ✅ `app.settingsManager.getApiKey()` kullanıyor
   - ✅ `app.settingsManager.getModel()` kullanıyor

2. **SaveSettingsButtonPushed()**
   - ✅ Sadece `settingsManager.setApiKey()` kullanıyor
   - ✅ `app.apiKey` ataması kaldırıldı

3. **startupFcn()**
   - ✅ Başlangıçta sadece `settingsManager`'dan yüklüyor
   - ✅ GUI alanlarını merkezi ayarlardan dolduruyor

4. **SendButtonPushed()**
   - ✅ API anahtarını `settingsManager`'dan alıyor

5. **getGptModelAdvice()**
   - ✅ API anahtarı kontrolü merkezi

6. **testSimpleApiCall()**
   - ✅ Test için merkezi ayarları kullanıyor

## 🔍 Avantajlar

### 1. Tek Kaynak (Single Source of Truth)
- ❌ **Önce:** API anahtarı 3 yerde tutuluyordu (app.apiKey, config.json, settingsManager)
- ✅ **Şimdi:** Sadece `config.json` ve `settingsManager`

### 2. Tutarlılık
- ✅ Her yerde aynı API anahtarı kullanılıyor
- ✅ Güncellemeler anında her yere yansıyor

### 3. Güvenlik
- ✅ API anahtarı sadece dosyada saklanıyor
- ✅ Memory'de gereksiz kopyalar yok

### 4. Bakım Kolaylığı
- ✅ Değişiklik yapmak için tek nokta
- ✅ Debug etmesi kolay

## 🧪 Test Senaryoları

### Test 1: API Anahtarı Kaydetme
```matlab
% 1. Ayarlar sekmesine git
% 2. API anahtarını gir
% 3. Save Settings'e tıkla
% 4. Command Window'da kontrol et:

settings = GlobalSettings();
settings.displaySettings();

% Beklenen çıktı:
% • apiKey: sk-proj-Dk...Ud8A (length: 164)
% • model: gpt-4o-mini
```

### Test 2: API Anahtarı Kullanımı
```matlab
% Herhangi bir GPT özelliğini kullan:
% - Model önerisi
% - Sohbet
% - Analiz

% Command Window'da şunu görmelisiniz:
% → API anahtarı alındı (uzunluk: 164)
% → API anahtarı geçerli, ChatAnalyzer oluşturuluyor...
% ✅ ChatAnalyzer oluşturuldu
```

### Test 3: Uygulama Yeniden Başlatma
```matlab
clear all
MRACApp

% Başlangıçta otomatik yükleme:
% ✅ Centralized settings manager initialized
% ✅ Settings loaded from config.json
% ✅ API configuration loaded
```

## 📊 Veri Akış Diyagramı

```
┌──────────────────────────────────────────────────────────┐
│                    KULLANICI ARAYÜZÜ                      │
│  ┌─────────────────────────────────────────────────┐    │
│  │  Ayarlar Sekmesi                                 │    │
│  │  [API Key: ___________]  [Model: gpt-4o-mini ▼] │    │
│  │  [Save Settings] [Test Connection]              │    │
│  └─────────────────────────────────────────────────┘    │
└───────────────────┬──────────────────────────────────────┘
                    ↓
┌───────────────────────────────────────────────────────────┐
│              SETTINGSMANAGER (Merkezi Yönetim)            │
│  • setApiKey(key)                                         │
│  • getApiKey() → key                                      │
│  • setModel(model)                                        │
│  • getModel() → model                                     │
│  • saveSettings() → config.json + mrac_settings.mat       │
│  • validateApiKey(key) → boolean                          │
└───────────────────┬───────────────────────────────────────┘
                    ↓
┌───────────────────────────────────────────────────────────┐
│                  KALICI DEPOLAMA                          │
│  ┌─────────────────┐        ┌────────────────────┐       │
│  │  config.json    │        │ mrac_settings.mat  │       │
│  │  {              │        │ settings struct    │       │
│  │   "apiKey":".." │        │ • apiKey           │       │
│  │   "model":".."  │        │ • model            │       │
│  │  }              │        │ • temperature      │       │
│  └─────────────────┘        └────────────────────┘       │
└───────────────────┬───────────────────────────────────────┘
                    ↓
┌───────────────────────────────────────────────────────────┐
│                   TÜKETİCİLER                             │
│  ┌──────────────┐  ┌────────────────┐  ┌──────────────┐ │
│  │ ChatManager  │  │ Model Advice   │  │ Chat System  │ │
│  │ .updateApi   │  │ .getGptModel   │  │ .sendChat    │ │
│  │  Key()       │  │  Recommendation│  │  Message()   │ │
│  └──────────────┘  └────────────────┘  └──────────────┘ │
│          ↓                  ↓                  ↓          │
│  ┌────────────────────────────────────────────────────┐  │
│  │        callGptApi_combined(prompt, apiConfig)      │  │
│  │        apiConfig.apiKey = settingsManager.getKey() │  │
│  └────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────┘
```

## 🚀 Kullanım Kılavuzu

### Yeni API Özelliği Eklerken

```matlab
function myNewGptFeature(app)
    % 1. API anahtarını merkezi yerden al
    currentApiKey = app.settingsManager.getApiKey();
    
    % 2. Kontrol et
    if isempty(currentApiKey)
        fprintf('❌ API anahtarı yok\n');
        return;
    end
    
    % 3. API config oluştur
    apiConfig = struct(...
        'apiKey', app.settingsManager.getApiKey(), ...
        'model', app.settingsManager.getModel(), ...
        'temperature', 0.7
    );
    
    % 4. API çağrısı yap
    response = callGptApi_combined(prompt, apiConfig);
end
```

### Model Değiştirirken

```matlab
% GUI'den model seçildiğinde
app.settingsManager.setModel('gpt-4o');
app.settingsManager.saveSettings();

% Otomatik olarak:
% 1. config.json güncellenir
% 2. ChatManager yenilenir
% 3. Sonraki tüm API çağrıları yeni modeli kullanır
```

## 📝 Özet

| Özellik | Öncesi | Sonrası |
|---------|--------|---------|
| API Anahtarı Yerleri | 3 (app.apiKey, config.json, settings) | 1 (config.json) |
| Erişim Şekli | `app.apiKey` | `app.settingsManager.getApiKey()` |
| Günceleme | Manuel, karmaşık | Otomatik, merkezi |
| Senkronizasyon | Manuel | Otomatik |
| Bakım | Zor, dağınık | Kolay, merkezi |

## ✅ Kontrol Listesi

Merkezi API yönetimi için:
- [x] `app.apiKey` property'si kaldırıldı
- [x] Tüm kullanımlar `app.settingsManager.getApiKey()` ile değiştirildi
- [x] `SaveSettingsButtonPushed()` sadece merkezi ayarları kullanıyor
- [x] `startupFcn()` merkezi ayarlardan yüklüyor
- [x] Tüm GPT özellikleri merkezi API anahtarı kullanıyor
- [x] Debug mesajları eklendi
- [x] Dokümantasyon hazırlandı

---

**Son Güncelleme:** 9 Ekim 2025  
**Versiyon:** v3.2 - Centralized API Key Architecture  
**Durum:** ✅ Implementasyon tamamlandı

