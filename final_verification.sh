#!/bin/bash
# cloudyMTA Final Verification Script

echo "================================================"
echo "cloudyMTA FINAL VERIFICATION"
echo "================================================"
echo ""

cd /projects/sandbox/cloudyMTA

echo "[1/10] Weryfikacja struktury projektu..."
if [ -d "server/mods/deathmatch/resources/[SinceRPG]" ]; then
    echo "✓ Folder zasobów istnieje"
else
    echo "✗ Brak folderu zasobów!"
fi

echo ""
echo "[2/10] Sprawdzanie plików Lua..."
total_lua=$(find server/mods/deathmatch/resources -name "*.lua" -type f 2>/dev/null | wc -l)
echo "✓ Znaleziono $total_lua plików Lua"

echo ""
echo "[3/10] Sprawdzanie pozostałości SinceRPG..."
sincerpg_count=$(find server/mods/deathmatch/resources -name "*.lua" -exec grep -l "sincerpg\|SinceRPG" {} \; 2>/dev/null | wc -l)
if [ "$sincerpg_count" -eq 0 ]; then
    echo "✓ Brak pozostałości SinceRPG w plikach Lua"
else
    echo "⚠ Znaleziono $sincerpg_count plików z SinceRPG"
fi

echo ""
echo "[4/10] Sprawdzanie kolorów cloudyMTA..."
primary_count=$(find server/mods/deathmatch/resources -name "*.lua" -exec grep -l "46, 117, 111\|#2E756F" {} \; 2>/dev/null | wc -l)
accent_count=$(find server/mods/deathmatch/resources -name "*.lua" -exec grep -l "67, 143, 135\|#438F87" {} \; 2>/dev/null | wc -l)
echo "✓ Kolor primary (#2E756F) w $primary_count plikach"
echo "✓ Kolor accent (#438F87) w $accent_count plikach"

echo ""
echo "[5/10] Sprawdzanie linków..."
discord_count=$(find server/mods/deathmatch/resources -name "*.lua" -exec grep -l "cloudymta" {} \; 2>/dev/null | wc -l)
echo "✓ Nowe linki cloudymta w $discord_count plikach"

echo ""
echo "[6/10] Sprawdzanie plików meta.xml..."
total_xml=$(find server/mods/deathmatch/resources -name "meta.xml" -type f 2>/dev/null | wc -l)
echo "✓ Znaleziono $total_xml plików meta.xml"

echo ""
echo "[7/10] Sprawdzanie konfiguracji serwera..."
if grep -q "cloudyMTA" server/mods/deathmatch/mtaserver.conf 2>/dev/null; then
    echo "✓ mtaserver.conf zaktualizowany"
else
    echo "⚠ mtaserver.conf może wymagać aktualizacji"
fi

echo ""
echo "[8/10] Sprawdzanie systemu kolorystycznego..."
if [ -f "server/mods/deathmatch/resources/[SinceRPG]/[dimsbln]/[main]/since-core/cloudyMTA_colors.lua" ]; then
    echo "✓ Plik cloudyMTA_colors.lua istnieje"
else
    echo "⚠ Brak pliku cloudyMTA_colors.lua"
fi

echo ""
echo "[9/10] Sprawdzanie dokumentacji..."
docs=0
[ -f "README.md" ] && ((docs++)) && echo "✓ README.md"
[ -f "CLOUDYMTA_FINAL_SUMMARY.md" ] && ((docs++)) && echo "✓ CLOUDYMTA_FINAL_SUMMARY.md"
[ -f "CLOUDYMTA_REBRAND_REPORT.md" ] && ((docs++)) && echo "✓ CLOUDYMTA_REBRAND_REPORT.md"
[ -f "CLOUDYMTA_LOGO_INSTRUCTIONS.md" ] && ((docs++)) && echo "✓ CLOUDYMTA_LOGO_INSTRUCTIONS.md"
[ -f "INSTALLATION_GUIDE.md" ] && ((docs++)) && echo "✓ INSTALLATION_GUIDE.md"
echo "→ Dokumentów: $docs/5"

echo ""
echo "[10/10] Podsumowanie statystyk..."
echo ""
echo "================================================"
echo "FINAL STATISTICS"
echo "================================================"
echo "Pliki Lua: $total_lua"
echo "Pliki XML: $total_xml"
echo "Pozostałości SinceRPG: $sincerpg_count"
echo "Użycie koloru primary: $primary_count plików"
echo "Użycie koloru accent: $accent_count plików"
echo "Linki cloudymta: $discord_count plików"
echo "Dokumentacja: $docs/5 plików"
echo ""
echo "================================================"
echo "WERYFIKACJA ZAKOŃCZONA"
echo "================================================"
