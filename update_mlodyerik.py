#!/usr/bin/env python3
"""
Skrypt do modyfikacji bazy danych SinceRPG dla użytkownika mlodyerik:
- Wymaksowanie konta (pieniądze, bank, SRP, poziom)
- Dodanie wszystkich praw jazdy (A, B, C, L)
- Dodanie full tuningu do Elegy (model 562, ID 23)
"""

import sys

def update_database():
    # Wczytaj plik SQL
    with open('sincemoj.sql', 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    print("Modyfikuję bazę danych dla mlodyerik...")
    
    # Linia 6644: Użytkownik mlodyerik
    # Pozycje w wierszu:
    # uid=8, login, nick, password, serial, ip, money, skin, bankMoney, registerDate, playedTime, premium, srp, inventory, licenses, ...
    
    old_user_line = lines[6643]  # Indeks 6643 to linia 6644
    
    # Nowa linia z:
    # - money: 999999999 (zamiast 2221304)
    # - bankMoney: 999999999 (zamiast 1997780222)
    # - srp: 99999 (zamiast 33)
    # - playedTime: 99999 (zamiast 30)
    # - licenses: [ { "A": 1, "B": 1, "C": 1, "L": 1 } ] (zamiast [ [ ] ])
    # - premium: '2099-12-31 23:59:59' (długie premium)
    # - premiumPoints: 999999 (zamiast 0)
    # - wPLN: 999999 (zamiast 0)
    
    new_user_line = "(8, 'mlodyerik', 'mlodyerik', 'B74E2F13ADBBD13A5EF2B7D319F23EEE', 'FD5E8BEDF6B5326A31C5880D403154A1', '192.168.18.116', 999999999, 0, 999999999, '2026-11-11 00:35:06', 99999, '2099-12-31 23:59:59', 99999, '[ [ ] ]', '[ { \"A\": 1, \"B\": 1, \"C\": 1, \"L\": 1 } ]', '', '1307.28125, -1387.994140625, 13.51748085022, 0, 0', '1935878', '[ { \"terrainBlur\": true, \"realWater\": true, \"showUrNametag\": false, \"statusRP\": true, \"showClouds\": true, \"farClip\": true, \"shinyVehs\": true, \"texDetail\": true, \"betterSky\": true, \"oldHUD\": false, \"ssaqShadows\": true, \"showRadars\": false, \"customSmoke\": false } ]', '2026-11-12 01:36:39', 1, 1, '27 SRP', '[ [ ] ]', '[ { \"magazynier\": { \"earned\": 1526, \"time\": 5 } } ]', '[ [ ] ]', '', 999999, '[ { \"crosshair\": { \"line\": 0, \"position\": 0, \"color\": [ 0, 0, 0 ], \"modeT\": false, \"size\": 1 } } ]', '', 0, 0, 0, 'brak', '0000-00-00 00:00:00', 0, '', 0, 0, 0, 0, 0, 999999, '2026-11-11', 1, '[ { \"last\": 8, \"progress\": 0, \"date\": \"0000-00-00\", \"id\": 8, \"daysInRow\": 1 } ]', '', 1, '', NULL, NULL, 0, 0, 0, 'VIP OWNER');\n"
    
    lines[6643] = new_user_line
    print("✓ Zaktualizowano użytkownika mlodyerik:")
    print("  - Pieniądze: 999,999,999$")
    print("  - Bank: 999,999,999$")
    print("  - SRP: 99,999")
    print("  - Czas gry: 99,999 godzin")
    print("  - Premium: do 2099-12-31")
    print("  - Punkty premium: 999,999")
    print("  - wPLN: 999,999")
    print("  - Prawa jazdy: A, B, C, L (wszystkie)")
    print("  - Klasa: VIP OWNER")
    
    # Linia 6705: Elegy (ID 23, model 562)
    # Dodajmy full tuning do Elegy
    old_elegy_line = lines[6704]  # Indeks 6704 to linia 6705
    
    # Full tuning dla Elegy - wszystkie możliwe modyfikacje
    # W MTA SA Elegy może mieć: exhaust (1037), spoiler (1147), roof (1038), side_skirts (1036), front_bumper (1171), rear_bumper (1149), wheels
    new_elegy_line = "(23, 562, 'do local _={count=100,tank=100};return _;end', 'do local _={paintjob=3};return _;end', '', 'do local _={0,0};return _;end', 'do local _={driver=\"Brak\",mileage=0,engine=3};return _;end', '', 1, 8, 0, 'do local _={0,0,0,255,0,255,255,0,255,0,0,255};return _;end', 'do local _={0,255,0};return _;end', 'do local _={exhaust=1037,spoiler=1147,roof=1038,side_skirts=1036,front_bumper=1171,rear_bumper=1149,wheels=1025,nitro=3,hydraulics=1};return _;end', 'do local _={vinylRim=10,vinylWounds=0,wheelTilt=15,wheelResize=1.2,innerSize=1};return _;end', '2026-11-11 01:42:45', 5, '', 1100000, '[]', 'ELEGY-1', '2026-11-11 01:42:45', '2026-11-11 01:42:45'),\n"
    
    lines[6704] = new_elegy_line
    print("✓ Zaktualizowano Elegy (ID 23):")
    print("  - Silnik: 3.0 (max)")
    print("  - Paintjob: 3")
    print("  - Kolor: Różowo-zielony custom")
    print("  - Świa tła: Zielone")
    print("  - Full tuning: exhaust, spoiler, roof, side skirts, bumpers, custom wheels")
    print("  - Nitro: 3x")
    print("  - Hydraulics: TAK")
    print("  - Szyby: Przyciemnione (5)")
    print("  - Custom felgi i ustawienia kół")
    print("  - Tablice: ELEGY-1")
    
    # Zapisz zmodyfikowany plik
    with open('sincemoj_updated.sql', 'w', encoding='utf-8') as f:
        f.writelines(lines)
    
    print("\n✅ Gotowe! Nowa baza zapisana jako: sincemoj_updated.sql")
    print("\nPodsumowanie zmian:")
    print("=" * 60)
    print("UŻYTKOWNIK: mlodyerik (UID: 8)")
    print("  • Pieniądze gotówką: 999,999,999$")
    print("  • Pieniądze w banku: 999,999,999$")
    print("  • SRP: 99,999 punktów")
    print("  • Czas gry: 99,999 godzin")
    print("  • Premium: aktywne do 31 grudnia 2099")
    print("  • Punkty premium: 999,999")
    print("  • wPLN: 999,999")
    print("  • Prawa jazdy: ✓ A, ✓ B, ✓ C, ✓ L (licencja lotnicza)")
    print("  • Status: VIP OWNER")
    print()
    print("POJAZDY:")
    print("  • Już posiadasz 10 pojazdów (ID 17-26):")
    print("    - Infernus (411) - tablice MLY-001")
    print("    - Cheetah (415) - tablice MLY-002")
    print("    - Banshee (429) - tablice MLY-003")
    print("    - Turismo (451) - tablice MLY-004")
    print("    - ZR-350 (477) - tablice MLY-005")
    print("    - Sultan (560) - tablice MLY-006")
    print("    ⭐ Elegy (562) - FULL TUNED - tablice ELEGY-1")
    print("    - Bullet (541) - tablice MLY-008")
    print("    - Super GT (506) - tablice MLY-009")
    print("    - Comet (480) - tablice MLY-010")
    print()
    print("  ⭐ Elegy ma teraz FULL TUNING:")
    print("    - Silnik 3.0L (maksymalny)")
    print("    - Paintjob #3")
    print("    - Custom kolory (różowo-zielony)")
    print("    - Zielone światła")
    print("    - Wszystkie części: wydech, spoiler, dach, progi, zderzaki")
    print("    - Nitro 3x")
    print("    - Hydraulika")
    print("    - Przyciemnione szyby")
    print("    - Custom felgi i rozszerzenie")
    print("=" * 60)
    print("\nAby użyć tej bazy, zaimportuj plik sincemoj_updated.sql do MySQL")
    
    return 0

if __name__ == '__main__':
    try:
        sys.exit(update_database())
    except Exception as e:
        print(f"❌ Błąd: {e}", file=sys.stderr)
        sys.exit(1)
