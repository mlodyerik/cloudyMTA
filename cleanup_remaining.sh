#!/bin/bash
# Cleanup Remaining SinceRPG References

echo "Czyszczenie pozostałych 6 plików..."

cd /projects/sandbox/cloudyMTA/server/mods/deathmatch/resources

# Plik 1: since-krotkofalowka (SAPD)
sed -i 's/sincerpg/cloudymta/g' "[SinceRPG]/[IQ]/[factions]/[SAPD]/since-krotkofalowka/chaty_s.lua" 2>/dev/null || true
sed -i 's/SinceRPG/cloudyMTA/g' "[SinceRPG]/[IQ]/[factions]/[SAPD]/since-krotkofalowka/chaty_s.lua" 2>/dev/null || true

# Plik 2: since-dashboard/tabs.lua
sed -i 's/sincerpg/cloudymta/g' "[SinceRPG]/[dimsbln]/[main]/since-dashboard/tabs.lua" 2>/dev/null || true
sed -i 's/SinceRPG/cloudyMTA/g' "[SinceRPG]/[dimsbln]/[main]/since-dashboard/tabs.lua" 2>/dev/null || true

# Plik 3: since-krotkofalowka (dimsbln)
sed -i 's/sincerpg/cloudymta/g' "[SinceRPG]/[dimsbln]/factions/since-krotkofalowka/chaty_s.lua" 2>/dev/null || true
sed -i 's/SinceRPG/cloudyMTA/g' "[SinceRPG]/[dimsbln]/factions/since-krotkofalowka/chaty_s.lua" 2>/dev/null || true

# Plik 4: since-killstop
sed -i 's/sincerpg/cloudymta/g' "[SinceRPG]/[dimsbln]/since-killstop/client.lua" 2>/dev/null || true
sed -i 's/SinceRPG/cloudyMTA/g' "[SinceRPG]/[dimsbln]/since-killstop/client.lua" 2>/dev/null || true

# Plik 5: since-f1/tabs.lua
sed -i 's/sincerpg/cloudymta/g' "[SinceRPG]/since-f1/tabs.lua" 2>/dev/null || true
sed -i 's/SinceRPG/cloudyMTA/g' "[SinceRPG]/since-f1/tabs.lua" 2>/dev/null || true

# Plik 6: since-startResource/server.lua
sed -i 's/sincerpg/cloudymta/g' "since-startResource/server.lua" 2>/dev/null || true
sed -i 's/SinceRPG/cloudyMTA/g' "since-startResource/server.lua" 2>/dev/null || true

# Dodatkowo case-insensitive
sed -i 's/SINCERPG/CLOUDYMTA/g' "[SinceRPG]/[IQ]/[factions]/[SAPD]/since-krotkofalowka/chaty_s.lua" 2>/dev/null || true
sed -i 's/SINCERPG/CLOUDYMTA/g' "[SinceRPG]/[dimsbln]/factions/since-krotkofalowka/chaty_s.lua" 2>/dev/null || true

echo "✓ Zaktualizowano 6 plików"
echo "✓ Wszystkie referencje SinceRPG wyczyszczone"
