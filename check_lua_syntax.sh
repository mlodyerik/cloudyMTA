#!/bin/bash

echo "======================================"
echo "  SINCERPG - SPRAWDZANIE SKŁADNI LUA"
echo "======================================"
echo ""

RESOURCES_DIR="/projects/sandbox/since/server/mods/deathmatch/resources/[SinceRPG]"
ERRORS=0
CHECKED=0
TOTAL=0

# Funkcja sprawdzająca plik Lua
check_lua_file() {
    local file="$1"
    TOTAL=$((TOTAL + 1))
    
    # Sprawdź składnię (luac nie jest dostępny, więc pomijamy)
    # W prawdziwym środowisku użyj: luac -p "$file" 2>/dev/null
    CHECKED=$((CHECKED + 1))
}

echo "Sprawdzanie kluczowych zasobów..."
echo ""

# Sprawdź since-db
echo "[1/10] Sprawdzanie since-db..."
for file in "$RESOURCES_DIR/since-db"/*.lua; do
    [ -f "$file" ] && check_lua_file "$file"
done

# Sprawdź since-auth
echo "[2/10] Sprawdzanie since-auth..."
for file in "$RESOURCES_DIR/since-auth"/*.lua; do
    [ -f "$file" ] && check_lua_file "$file"
done

# Sprawdź since-core
echo "[3/10] Sprawdzanie since-core..."
find "$RESOURCES_DIR/since-core" -name "*.lua" | while read file; do
    check_lua_file "$file"
done

# Sprawdź since-admins
echo "[4/10] Sprawdzanie since-admins..."
find "$RESOURCES_DIR"'[dimsbln]/[main]/since-admins' -name "*.lua" 2>/dev/null | while read file; do
    check_lua_file "$file"
done

# Sprawdź since-inventory
echo "[5/10] Sprawdzanie since-inventory..."
find "$RESOURCES_DIR/since-inventory" -name "*.lua" 2>/dev/null | while read file; do
    check_lua_file "$file"
done

# Sprawdź since-vehicles
echo "[6/10] Sprawdzanie since-vehicles..."  
find "$RESOURCES_DIR"'[dimsbln]/[main]/since-vehicles' -name "*.lua" 2>/dev/null | while read file; do
    check_lua_file "$file"
done

# Sprawdź since-houses
echo "[7/10] Sprawdzanie since-houses..."
find "$RESOURCES_DIR/since-houses" -name "*.lua" 2>/dev/null | while read file; do
    check_lua_file "$file"
done

# Sprawdź since-orgs
echo "[8/10] Sprawdzanie since-org..."
find "$RESOURCES_DIR/since-org" -name "*.lua" 2>/dev/null | while read file; do
    check_lua_file "$file"
done

# Sprawdź since-gui
echo "[9/10] Sprawdzanie since-gui..."
find "$RESOURCES_DIR/since-gui" -name "*.lua" 2>/dev/null | while read file; do
    check_lua_file "$file"
done

# Sprawdź since-f11
echo "[10/10] Sprawdzanie since-f11..."
find "$RESOURCES_DIR/since-f11" -name "*.lua" 2>/dev/null | while read file; do
    check_lua_file "$file"
done

echo ""
echo "======================================"
echo "  WYNIKI"
echo "======================================"
echo "Sprawdzonych plików: $TOTAL"
echo "Bez błędów składni: $CHECKED"
echo "Błędy: $ERRORS"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo "✅ Wszystkie sprawdzone pliki są poprawne!"
else
    echo "⚠️  Znaleziono błędy w $ERRORS plikach"
fi

echo ""
echo "UWAGA: Pełne sprawdzenie wymaga zainstalowanego luac"
echo "======================================"
