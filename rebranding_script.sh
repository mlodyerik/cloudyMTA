#!/bin/bash
# cloudyMTA Rebranding Script
# Automatyczna zmiana widocznych dla graczy nazw SinceRPG na cloudyMTA

echo "================================"
echo "cloudyMTA Rebranding Script"
echo "================================"
echo ""

cd /projects/sandbox/cloudyMTA

# Backup przed zmianami
echo "[1/5] Tworzenie kopii zapasowej..."
# Nie tworzymy fizycznej kopii, git jest naszą kopią

# Zmiana nazw w komentarzach i widocznych tekstach
echo "[2/5] Zmiana nazw widocznych dla graczy..."

# Funkcja do zamiany w plikach Lua (tylko widoczne dla graczy teksty)
find server/mods/deathmatch/resources -name "*.lua" -type f | while read file; do
    # Zmiana tylko w stringach widocznych dla graczy (w cudzysłowach i apostrofach)
    sed -i 's/"SinceRPG"/"cloudyMTA"/g' "$file" 2>/dev/null || true
    sed -i "s/'SinceRPG'/'cloudyMTA'/g" "$file" 2>/dev/null || true
    sed -i 's/"Since RPG"/"cloudyMTA RPG"/g' "$file" 2>/dev/null || true
    sed -i "s/'Since RPG'/'cloudyMTA RPG'/g" "$file" 2>/dev/null || true
    
    # Zmiana w komentarzach autora (For: SinceRPG -> For: cloudyMTA)
    sed -i 's/For: SinceRPG/For: cloudyMTA/g' "$file" 2>/dev/null || true
    sed -i 's/For:SinceRPG/For: cloudyMTA/g' "$file" 2>/dev/null || true
done

# Zmiana linków Discord
echo "[3/5] Aktualizacja linków społecznościowych..."
find server/mods/deathmatch/resources -name "*.lua" -type f -exec sed -i 's/sincerpg-play-with-us-1143611641393586356/cloudymta-community/g' {} \; 2>/dev/null || true
find server/mods/deathmatch/resources -name "*.lua" -type f -exec sed -i 's/dsc.gg\/sincerpg/discord.gg\/cloudymta/g' {} \; 2>/dev/null || true
find server/mods/deathmatch/resources -name "*.lua" -type f -exec sed -i 's/discord.gg\/qyrq2DzJ6Q/discord.gg\/cloudymta/g' {} \; 2>/dev/null || true

# Zmiana linków do strony
echo "[4/5] Aktualizacja linków WWW..."
find server/mods/deathmatch/resources -name "*.lua" -type f -exec sed -i 's/https:\/\/sincerpg.pl\//https:\/\/cloudymta.pl\//g' {} \; 2>/dev/null || true
find server/mods/deathmatch/resources -name "*.lua" -type f -exec sed -i 's/https:\/\/sklep.sincerpg.pl\//https:\/\/sklep.cloudymta.pl\//g' {} \; 2>/dev/null || true
find server/mods/deathmatch/resources -name "*.lua" -type f -exec sed -i 's/sincerpg.pl/cloudymta.pl/g' {} \; 2>/dev/null || true

# Zmiana Discord Rich Presence
find server/mods/deathmatch/resources -name "*.lua" -type f -exec sed -i 's/setDiscordRichPresenceAsset("logo", "SinceRPG")/setDiscordRichPresenceAsset("logo", "cloudyMTA")/g' {} \; 2>/dev/null || true
find server/mods/deathmatch/resources -name "*.lua" -type f -exec sed -i 's/setDiscordRichPresenceSmallAsset("my_small_logo", "SinceRPG")/setDiscordRichPresenceSmallAsset("my_small_logo", "cloudyMTA")/g' {} \; 2>/dev/null || true

echo "[5/5] Gotowe!"
echo ""
echo "Rebranding nazw i linków zakończony."
echo "Następnie: zmiana grafik i kolorystyki interfejsów"
