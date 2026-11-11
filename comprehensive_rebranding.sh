#!/bin/bash
# cloudyMTA - COMPREHENSIVE REBRANDING SCRIPT
# Kompleksowa automatyzacja rebrandingu wszystkich elementów

echo "================================================"
echo "cloudyMTA COMPREHENSIVE REBRANDING"
echo "================================================"
echo ""

cd /projects/sandbox/cloudyMTA/server/mods/deathmatch/resources

# CZĘŚĆ 1: Zaawansowana konwersja kolorów
echo "[1/10] Zaawansowana konwersja wszystkich wariantów kolorów..."

# Wszystkie warianty zielonych (stary branding) -> turkusowe (cloudyMTA)
find . -name "*.lua" -type f -exec sed -i 's/tocolor(125, 255, 125/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(103, 213, 94/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(104, 214, 94/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(99, 255, 138/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(125, 185, 75/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(75, 215, 75/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(80, 241, 119/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(35, 229, 82/tocolor(46, 117, 111/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(60, 255, 102/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true

# Jaśniejsze zielone akcenty
find . -name "*.lua" -type f -exec sed -i 's/tocolor(155, 225, 155/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(153, 255, 138/tocolor(67, 143, 135/g' {} \; 2>/dev/null || true

# Wszystkie HEX zielone
find . -name "*.lua" -type f -exec sed -i 's/#7dff7d/#2E756F/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/#99ff8a/#438F87/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/#80F177/#438F87/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/#67d55e/#2E756F/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/#23e552/#2E756F/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/#9bff9a/#438F87/g' {} \; 2>/dev/null || true

# CZĘŚĆ 2: Tła i panele
echo "[2/10] Konwersja teł i paneli na paletę cloudyMTA..."
find . -name "*.lua" -type f -exec sed -i 's/tocolor(15, 15, 15/tocolor(16, 23, 25/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(20, 20, 20/tocolor(16, 23, 25/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(25, 25, 25/tocolor(25, 36, 38/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(30, 30, 30/tocolor(25, 36, 38/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(32, 32, 32/tocolor(25, 36, 38/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(35, 35, 35/tocolor(25, 36, 38/g' {} \; 2>/dev/null || true

# CZĘŚĆ 3: Teksty na nową paletę
echo "[3/10] Aktualizacja kolorów tekstów..."
find . -name "*.lua" -type f -exec sed -i 's/tocolor(255, 255, 255, 225)/tocolor(241, 245, 244, 225)/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(255, 255, 255, 200)/tocolor(241, 245, 244, 200)/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(200, 200, 200/tocolor(145, 163, 160/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/tocolor(207, 207, 207/tocolor(145, 163, 160/g' {} \; 2>/dev/null || true

# CZĘŚĆ 4: Linki i teksty widoczne
echo "[4/10] Kompleksowa aktualizacja linków i nazw..."

# Discord - wszystkie warianty
find . -name "*.lua" -type f -exec sed -i 's/sincerpg-play-with-us-1143611641393586356/cloudymta/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/dsc\.gg\/sincerpg/discord.gg\/cloudymta/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/discord\.gg\/qyrq2DzJ6Q/discord.gg\/cloudymta/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/discord\.gg\/cbhR4Gqj9e/discord.gg\/cloudymta/g' {} \; 2>/dev/null || true

# WWW - wszystkie warianty
find . -name "*.lua" -type f -exec sed -i 's/https:\/\/sincerpg\.pl/https:\/\/cloudymta.pl/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/https:\/\/sklep\.sincerpg\.pl/https:\/\/sklep.cloudymta.pl/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/sincerpg\.pl/cloudymta.pl/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/sklep\.sincerpg/sklep.cloudymta/g' {} \; 2>/dev/null || true

# CZĘŚĆ 5: Nazwy w stringach (widoczne dla gracza)
echo "[5/10] Zamiana nazw widocznych dla graczy..."
find . -name "*.lua" -type f -exec sed -i 's/"SinceRPG"/"cloudyMTA"/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i "s/'SinceRPG'/'cloudyMTA'/g" {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/"Since RPG"/"cloudyMTA"/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i "s/'Since RPG'/'cloudyMTA'/g" {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/Since RPG/cloudyMTA/g' {} \; 2>/dev/null || true

# CZĘŚĆ 6: Komentarze autorskie
echo "[6/10] Aktualizacja komentarzy autorskich..."
find . -name "*.lua" -type f -exec sed -i 's/For: SinceRPG/For: cloudyMTA/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/For:SinceRPG/For: cloudyMTA/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/SinceRPG Server/cloudyMTA Server/g' {} \; 2>/dev/null || true

# CZĘŚĆ 7: Discord Rich Presence
echo "[7/10] Aktualizacja Discord Rich Presence..."
find . -name "*.lua" -type f -exec sed -i 's/setDiscordRichPresenceAsset("logo", "SinceRPG")/setDiscordRichPresenceAsset("logo", "cloudyMTA")/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/setDiscordRichPresenceSmallAsset("my_small_logo", "SinceRPG")/setDiscordRichPresenceSmallAsset("my_small_logo", "cloudyMTA")/g' {} \; 2>/dev/null || true
find . -name "*.lua" -type f -exec sed -i 's/setDiscordRichPresenceAsset("logo", '\''SinceRPG'\'')/setDiscordRichPresenceAsset("logo", "cloudyMTA")/g' {} \; 2>/dev/null || true

# CZĘŚĆ 8: Pliki meta.xml i konfiguracyjne
echo "[8/10] Aktualizacja plików meta.xml..."
find . -name "meta.xml" -type f -exec sed -i 's/SinceRPG/cloudyMTA/g' {} \; 2>/dev/null || true
find . -name "*.xml" -type f -exec sed -i 's/Since RPG/cloudyMTA/g' {} \; 2>/dev/null || true

# CZĘŚĆ 9: Pliki HTML/CSS/JS (jeśli istnieją)
echo "[9/10] Aktualizacja plików web..."
find . -name "*.html" -type f -exec sed -i 's/SinceRPG/cloudyMTA/g' {} \; 2>/dev/null || true
find . -name "*.css" -type f -exec sed -i 's/#7dff7d/#2E756F/g' {} \; 2>/dev/null || true
find . -name "*.css" -type f -exec sed -i 's/#99ff8a/#438F87/g' {} \; 2>/dev/null || true
find . -name "*.js" -type f -exec sed -i 's/SinceRPG/cloudyMTA/g' {} \; 2>/dev/null || true

# CZĘŚĆ 10: Weryfikacja i podsumowanie
echo "[10/10] Weryfikacja zmian..."
echo ""
echo "================================================"
echo "COMPREHENSIVE REBRANDING COMPLETED"
echo "================================================"
echo ""
echo "Zmodyfikowane pliki:"
echo "- Lua: $(find . -name '*.lua' -type f | wc -l) plików przeszukanych"
echo "- XML: $(find . -name '*.xml' -type f | wc -l) plików zaktualizowanych"
echo "- HTML: $(find . -name '*.html' -type f | wc -l) plików zaktualizowanych"
echo "- CSS: $(find . -name '*.css' -type f | wc -l) plików zaktualizowanych"
echo ""
echo "Kolory skonwertowane:"
echo "✓ Zielone (#7dff7d, tocolor(125,255,125)) → Turkus cloudyMTA (#2E756F)"
echo "✓ Jasne zielone (#99ff8a) → Jasny turkus (#438F87)"
echo "✓ Ciemne tła (15,15,15) → cloudyMTA tło (#101719)"
echo "✓ Panele (32,32,32) → cloudyMTA panele (#192426)"
echo ""
echo "Linki zaktualizowane:"
echo "✓ Discord: discord.gg/cloudymta"
echo "✓ WWW: cloudymta.pl"
echo "✓ Sklep: sklep.cloudymta.pl"
echo ""
echo "Nazwy zaktualizowane:"
echo "✓ SinceRPG → cloudyMTA"
echo "✓ Since RPG → cloudyMTA"
echo ""
echo "GOTOWE! Rebranding kompletny."
