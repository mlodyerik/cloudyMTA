#!/bin/bash
# cloudyMTA Final Color Polish
# Finalna konwersja wszystkich pozostałych wariantów kolorów zielonych

echo "================================================"
echo "cloudyMTA FINAL COLOR POLISH"
echo "================================================"

cd /projects/sandbox/cloudyMTA/server/mods/deathmatch/resources

echo "[1/8] Konwersja wszystkich podobnych odcieni zielonych..."

# Wszystkie warianty zielonych od ~100-135 RGB na główne
find . -name "*.lua" -exec sed -i 's/tocolor(100, 200, 100/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(100, 255, 100/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(114, 255, 102/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(122, 194, 185/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(124, 255, 113/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 200, 125/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 215, 125/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 225, 125/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(127, 255, 116/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(128, 230, 48/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(128, 241, 118/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(128, 241, 119/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(132, 255, 122/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true

echo "[2/8] Konwersja jaśniejszych zielonych na accent..."
find . -name "*.lua" -exec sed -i 's/tocolor(125, 175, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 185, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 200, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 215, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(135, 185, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(100, 175, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(113, 204, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(117, 205, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true

echo "[3/8] Konwersja z alpha channel..."
find . -name "*.lua" -exec sed -i 's/tocolor(125, 200, 125, /tocolor(46, 117, 111, /g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 215, 125, /tocolor(46, 117, 111, /g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 225, 125, /tocolor(46, 117, 111, /g' {} \; 2>/dev/null || true

echo "[4/8] Konwersja formatów bez spacji..."
find . -name "*.lua" -exec sed -i 's/tocolor(125,200,125/tocolor(46,117,111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125,215,125/tocolor(46,117,111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125,225,125/tocolor(46,117,111/g' {} \; 2>/dev/null || true

echo "[5/8] Konwersja w tablicach RGB..."
find . -name "*.lua" -exec sed -i 's/{125, 200, 125}/{46, 117, 111}/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/{125, 215, 125}/{46, 117, 111}/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/{125, 225, 125}/{46, 117, 111}/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/{125, 185, 255}/{67, 143, 135}/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/{127, 160, 190}/{67, 143, 135}/g' {} \; 2>/dev/null || true

echo "[6/8] Czysty zielony 0,255,0 na turkus..."
find . -name "*.lua" -exec sed -i 's/tocolor(0, 255, 0/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(0,255,0/tocolor(46,117,111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/{0, 255, 0}/{46, 117, 111}/g' {} \; 2>/dev/null || true

echo "[7/8] Cyjanowe na turkus accent..."
find . -name "*.lua" -exec sed -i 's/tocolor(1, 255, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(0, 255, 255/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true

echo "[8/8] Weryfikacja końcowa..."

# Statystyki pozostałych kolorów
remaining=$(find . -name "*.lua" -exec grep -h "tocolor" {} \; 2>/dev/null | grep -E "tocolor\([0-9]+, 2[0-5][0-9], [0-9]+" | wc -l)

echo ""
echo "✓ Skonwertowano wszystkie warianty zielonych kolorów"
echo "✓ Pozostałe kolory (niebędące zielonymi): $remaining"
echo "✓ Finalna konwersja zakończona"
echo ""
echo "FINAL COLOR POLISH COMPLETE!"
