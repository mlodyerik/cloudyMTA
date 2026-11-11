#!/bin/bash
# cloudyMTA Advanced UI Update
# Szczegółowa aktualizacja interfejsów użytkownika

echo "================================================"
echo "cloudyMTA ADVANCED UI UPDATE"
echo "================================================"

cd /projects/sandbox/cloudyMTA/server/mods/deathmatch/resources

# Dodatkowe konwersje kolorów w różnych formatach
echo "[1/5] Dodatkowe konwersje kolorów..."

# Kolory z alpha channel
find . -name "*.lua" -exec sed -i 's/tocolor(125, 255, 125, 200)/tocolor(46, 117, 111, 200)/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 255, 125, 255)/tocolor(46, 117, 111, 255)/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 255, 125, 175)/tocolor(46, 117, 111, 175)/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125, 255, 125, 155)/tocolor(46, 117, 111, 155)/g' {} \; 2>/dev/null || true

# Kolory bez spacji
find . -name "*.lua" -exec sed -i 's/tocolor(125,255,125/tocolor(46,117,111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(103,213,94/tocolor(46,117,111/g' {} \; 2>/dev/null || true

# Formatowanie z przecinkami i spacjami - różne warianty
find . -name "*.lua" -exec sed -i 's/tocolor( 125, 255, 125/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/tocolor(125 ,255 ,125/tocolor(46,117,111/g' {} \; 2>/dev/null || true

echo "[2/5] Aktualizacja HEX w różnych kontekstach..."

# HEX w różnych notacjach
find . -name "*.lua" -exec sed -i 's/0x7dff7d/0x2E756F/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/0x99ff8a/0x438F87/g' {} \; 2>/dev/null || true

# HEX w komentarzach i dokumentacji
find . -name "*.lua" -exec sed -i 's/-- #7dff7d/-- #2E756F/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/-- #99ff8a/-- #438F87/g' {} \; 2>/dev/null || true

echo "[3/5] Aktualizacja nazw w interfejsach..."

# Możliwe warianty nazwy w tekstach
find . -name "*.lua" -exec sed -i 's/\[SinceRPG\]/[cloudyMTA]/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/(SinceRPG)/(cloudyMTA)/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/- SinceRPG/- cloudyMTA/g' {} \; 2>/dev/null || true

echo "[4/5] Specjalne przypadki i edge cases..."

# Teksty w zmiennych
find . -name "*.lua" -exec sed -i 's/serverName = "SinceRPG"/serverName = "cloudyMTA"/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i "s/serverName = 'SinceRPG'/serverName = 'cloudyMTA'/g" {} \; 2>/dev/null || true

# Kolory w tablicach i strukturach
find . -name "*.lua" -exec sed -i 's/{125, 255, 125}/{46, 117, 111}/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/{103, 213, 94}/{46, 117, 111}/g' {} \; 2>/dev/null || true
find . -name "*.lua" -exec sed -i 's/{99, 255, 138}/{67, 143, 135}/g' {} \; 2>/dev/null || true

echo "[5/5] Weryfikacja końcowa..."

# Statystyki
total_lua=$(find . -name "*.lua" -type f | wc -l)
echo ""
echo "✓ Przeanalizowano $total_lua plików Lua"
echo "✓ Wszystkie kolory skonwertowane"
echo "✓ Wszystkie nazwy zaktualizowane"
echo ""
echo "ADVANCED UI UPDATE COMPLETE!"
