#!/usr/bin/env bash
# apply-tr.sh — TWRP kaynak koduna Türkçe dil dosyasını uygular
# Kullanım: workspace/ dizininden çalıştırın:
#   bash ../patches/apply-tr.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TR_XML="$SCRIPT_DIR/twrp-tr/tr_strings.xml"

# TWRP'de UI string dosyaları birkaç çözünürlük klasöründe bulunur.
# ME176C ekranı 1280x800 (landscape) — portrait_hdpi teması seçili.
# strings.xml konumları (varsa hepsine kopyala):
TARGETS=(
    "bootable/recovery/gui/devices/1280x800/res/values-tr"
    "bootable/recovery/res/values-tr"
    "bootable/recovery/gui/res/values-tr"
)

echo "==> Türkçe dil dosyası uygulanıyor..."

for dir in "${TARGETS[@]}"; do
    if [ -d "$(dirname "$dir")" ]; then
        mkdir -p "$dir"
        cp "$TR_XML" "$dir/strings.xml"
        echo "  ✓ $dir/strings.xml"
    else
        echo "  - $dir (dizin yok, atlandı)"
    fi
done

# TWRP'nin hangi dil paketlerini derlediğini kontrol et
# ve Türkçe'yi ekle (derlenmiyorsa)
LANGUAGES_MK="bootable/recovery/Android.mk"
if [ -f "$LANGUAGES_MK" ]; then
    if ! grep -q '"tr"' "$LANGUAGES_MK"; then
        sed -i 's/SUPPORTED_LANGUAGES :=/SUPPORTED_LANGUAGES := tr/' "$LANGUAGES_MK" || true
        echo "  ✓ Türkçe dil desteği Android.mk'ya eklendi"
    else
        echo "  ✓ Türkçe zaten tanımlı"
    fi
fi

echo "==> Türkçe yama tamamlandı."
