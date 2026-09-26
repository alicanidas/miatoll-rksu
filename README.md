# RKSU + SUSFS v2.3.0 Kernel — miatoll (joyeuse, MIUI 14 stock)

Redmi Note 9 Pro (**joyeuse**) + stock **MIUI 14** (son sürüm) uyumlu,
maksimum gizlilik odaklı kinesis tabanlı kernel:

| Bileşen | Sürüm | Kaynak |
|---|---|---|
| Taban kernel | 4.14.343-openela (kinesis-MIUIv4) | [clarencelol/kernel_xiaomi_sm6250](https://github.com/clarencelol/kernel_xiaomi_sm6250) (`kinesis-MIUIv4` dalı) |
| KernelSU | **ReSukiSU** (güncel main, 26 Eyl 2026) + manuel hook | [ReSukiSU/ReSukiSU](https://github.com/ReSukiSU/ReSukiSU) |
| SUSFS | **v2.3.0** (4.14 portu) | [JackA1ltman/NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd) |
| NoMount | **v2.0.0** (built-in) | [maxsteeel/nomount](https://github.com/maxsteeel/nomount) |
| WLAN | qcacld-3.0 yeniden derlenir (`wlan.ko` pakete dahil) | kernel içi |

Kamera/DTS dosyalarına **dokunulmadı** (potato kernel'deki kamera bozulma sorunu
bu pakette olmaz — dtb + kamera driver'ları kinesis-MIUIv4'ten birebir gelir).

## 1. Derleme (GitHub Actions — önerilen)

1. Bu klasörü yeni bir GitHub repona yükle.
2. **Actions** → **"Build miatoll RKSU kernel"** → **Run workflow**.
3. ~15-25 dk bekle → **Artifacts** → `RKSU-SUSFS-kinesis-miatoll` →
   `RKSU-SUSFS-kinesis-miatoll-joyeuse-YYYYMMDD.zip` indir.

## 2. Flash (OrangeFox / TWRP)

> ⚠️ Önce **boot + vendor** yedeği al. Bootloader açık olmalı.

1. Zip'i flashla, reboot. `wlan.ko` otomatik kurulur.

## 3. Kurulum sonrası (YKB/banka gizliliği için tam liste)

1. **ReSukiSU Manager APK:**
   [Releases](https://github.com/ReSukiSU/ReSukiSU/releases) (spoof/gizli paket önerilir)
2. **susfs4ksu modülü:** [sidex15/susfs4ksu-module](https://github.com/sidex15/susfs4ksu-module/releases)
   → WebUI'dan aç: `sus_path`, `sus_mount`, `open_redirect`, `spoof_uname`
   (kernel string!), `spoof_cmdline`, Hide Symbols → Boot'ta etkin + post-fs-data
3. **NoMount v2.0.0 modülü:** [releases](https://github.com/maxsteeel/nomount/releases)
4. Manager'da bankaya **Umount modules** açık
5. **HMA:** LSPosed (JingMatrix) + HMA blacklist template (root uygulamaları) → bankaya uygula
6. **TrickyStore + geçerli keybox** (bootloader/PI spoof) — hedef: banka + GMS
7. USB debug KAPALI, Geliştirici seçenekleri KAPALI, VPN kapalı
8. Banka daha önce root gördüyse **uygulama verisini temizle**

> SUSFS varken Shamiko / Zygisk Assistant kullanma (çatışır).

## 4. Paket içeriği

```
patches/
  01-clean-old-hooks.patch  # tabandaki eski KSU hook bloklarını temizler
  02-rksu.patch             # ReSukiSU + manuel hook (11 dosya) + bağlantılar
  03-susfs-v2.3.0.patch     # SUSFS v2.3.0 kernel yaması (4.14)
  04-nomount-v2.0.0.patch   # NoMount v2.0.0 (fs/nomount + bağlantılar)
  05-defconfig.patch        # KSU + SUSFS + NOMOUNT + WLAN=m
.github/workflows/build.yml
build.sh                    # lokal derleme (Ubuntu)
anykernel.sh                # miatoll AK3
```

## Kaynaklar / teşekkür

- @clarencekopitiam / audemars — kinesis ([clarencerepo](https://t.me/clarencerepo))
- [ReSukiSU](https://github.com/ReSukiSU/ReSukiSU) — RKSU
- [simonpunk/susfs4ksu](https://gitlab.com/simonpunk/susfs4ksu) — SUSFS
- [JackA1ltman](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd) — 4.14 v2.3.0 portu + hook scripti
- [maxsteeel/nomount](https://github.com/maxsteeel/nomount) — NoMount
- [osm0sis/AnyKernel3](https://github.com/osm0sis/AnyKernel3), [Neutron-Toolchains](https://github.com/Neutron-Toolchains/antman)
