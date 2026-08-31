# ME176C Türkçe TWRP — GitHub Actions Build

ASUS MeMO Pad 7 (ME176C / K013) için GitHub Actions üzerinde derlenen,
sade Türkçe özelleştirilmiş TWRP recovery.

---

## 1. Kurulum (bir kerelik)

### 1a. Bu repoyu fork'la

GitHub'da **Fork** butonuna bas. Kendi hesabına kopyalanacak.

### 1b. Device tree repo URL'sini ayarla

`me176c-dev/android_device_asus_K013` reposu arşivlendiğinden önce
onu da fork'la, sonra kendi repo'nda şu secret'ı ekle:

```
Settings → Secrets and variables → Actions → New repository secret

İsim : DEVICE_TREE_URL
Değer: https://github.com/SENIN_KULLANICI_ADIN/android_device_asus_K013
```

> Eğer eklemezsen workflow varsayılan olarak orijinal (arşivlenmiş) repoyu
> kullanır — bu da çalışır ama değişiklik yapamassın.

---

## 2. Build nasıl başlatılır?

1. GitHub'da repo sayfana git
2. **Actions** sekmesine tıkla
3. Sol taraftan **ME176C TWRP Build** seç
4. **Run workflow** butonuna bas
5. İstersen seçenekleri ayarla:
   - **Build hedefi:** `recovery` (normal TWRP imajı)
   - **Temiz build:** sadece cache sıfırlamak istiyorsan işaretle
6. **Run workflow** ile başlat

Build yaklaşık **45–90 dakika** sürer (ilk seferinde).
Sonraki build'ler ccache sayesinde daha hızlı olur.

---

## 3. Çıktıyı indir

Build bitince:

- **Actions → ilgili run → Artifacts** bölümünden `twrp-me176c-X.zip` indir
- İçindeki `recovery.img` dosyasını tabletime flash'la

Veya otomatik olarak bir **Release** oluşturulur, oradan da indirebilirsin.

---

## 4. Tablete flash'lama

```bash
# Tableti Fastboot moduna geçir
# (Volume Down + Power → backlight yanınca Power'ı bırak)

fastboot devices                      # bağlantı kontrolü
fastboot flash recovery recovery.img  # flash'la
fastboot reboot recovery              # recovery'ye gir
```

> ⚠️ Önce `me176c-boot` kurulu olmalı. Bootloader unlock gerektirir.

---

## 5. Türkçe yamayı güncelleme

`patches/twrp-tr/tr_strings.xml` dosyasını düzenleyip commit'le.
Workflow otomatik olarak `patches/apply-tr.sh` scriptini çalıştırır.

---

## Teknik Detaylar

| Özellik | Değer |
|---|---|
| Cihaz | ASUS MeMO Pad 7 ME176C (K013) |
| CPU | Intel Atom Z3745 (Bay Trail, x86) |
| TWRP tabanı | 3.3.x Unofficial |
| Android tabanı | 9.0 Pie (LineageOS 16.0 kernel 4.19) |
| Ekran | 1280×800 portrait_hdpi teması |
| Build ortamı | Ubuntu 20.04 (GitHub Actions) |

---

## Sorun giderme

**Build "No space left" hatası verirse:**  
Workflow'daki "Gereksiz paketleri temizle" adımına daha fazla silme komutu ekle.

**"repo sync" uzun sürüyorsa:**  
`-j4` yerine `-j2` kullan (daha yavaş ama daha kararlı).

**ccache çalışmıyorsa:**  
Workflow'da `CLEAN_BUILD: true` ile bir kez temiz build al.
