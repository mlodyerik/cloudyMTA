#!/bin/bash
# cloudyMTA Color Conversion Script
# Automatyczna konwersja kluczowych kolorów na paletę cloudyMTA

echo "================================"
echo "cloudyMTA Color Conversion"
echo "================================"
echo ""

cd /projects/sandbox/cloudyMTA/server/mods/deathmatch/resources

# Backup - git jest naszą kopią zapasową
echo "[1/4] Rozpoczynam konwersję kolorów..."

# Konwersja kolorów zielonych (125, 255, 125) -> cloudyMTA primary (46, 117, 111)
# To są główne akcenty zielone w interfejsach
echo "[2/4] Zmiana głównych akcentów zielonych na turkusową zieleń cloudyMTA..."
find . -name "*.lua" -type f -exec sed -i 's/tocolor(125, 255, 125/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(103, 213, 94/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(104, 214, 94/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(99, 255, 138/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true

# Zamiana HEX w stringach
find . -name "*.lua" -type f -exec sed -i 's/#7dff7d/#2E756F/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/#99ff8a/#438F87/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/#80F177/#438F87/g' {} \; 2>/dev/null || true

echo "[3/4] Konwersja ciemnych teł na paletę cloudyMTA..."
# Zmiana bardzo ciemnych teł na cloudyMTA background
find . -name "*.lua" -type f -exec sed -i 's/tocolor(15, 15, 15/tocolor(16, 23, 25/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(32, 32, 32/tocolor(25, 36, 38/g' {} \; 2>/dev/null || true

echo "[4/4] Gotowe!"
echo ""
echo "Konwersja kolorów zakończona."
echo "Zaktualizowano główne akcenty i tła na paletę cloudyMTA."
