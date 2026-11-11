# 🎮 SINCERPG - MTA:SA ROLEPLAY SERVER

![Status](https://img.shields.io/badge/Status-READY-success)
![MTA](https://img.shields.io/badge/MTA-1.6.0+-blue)
![MySQL](https://img.shields.io/badge/MySQL-5.7+-orange)
![Resources](https://img.shields.io/badge/Resources-624-brightgreen)

## 📋 O PROJEKCIE

**SinceRPG** to kompletna paczka serwera Roleplay dla Multi Theft Auto: San Andreas. Zawiera pełny system RPG z ekonomią, organizacjami, frakcjami, pracami, domami, pojazdami i wieloma innymi funkcjami.

### ✨ Główne cechy:

- 🏙️ **Kompletny system RPG**
- 💰 **Zaawansowana ekonomia** (gotówka, bank, biznes)
- 🚗 **System pojazdów** (własność, tuning, paliwo)
- 🏠 **System domów** (kupno, współlokatorzy, magazyn)
- 👥 **Organizacje graczy** (gangi, firmy, rangi)
- 👮 **Frakcje** (SAPD, SARA, i inne)
- 💼 **System prac** (legalne i nielegalne)
- 🎒 **Zaawansowany inventory**
- 👨‍💼 **Panel administracyjny**
- 🌿 **System uprawy** i wiele więcej!

---

## 📦 ZAWARTOŚĆ PACZKI

```
since/
├── 📄 since.sql                    # Gotowa baza danych (48 tabel)
├── 📄 OWNER_CREDENTIALS.txt        # Dane dostępowe właściciela
├── 📄 INSTALACJA.md               # Instrukcja instalacji krok po kroku
├── 📄 RAPORT_NAPRAWY.md           # Szczegółowy raport naprawy
├── 📄 DATABASE_SCHEMA.md          # Dokumentacja bazy danych
├── 📄 README.md                   # Ten plik
├── 🔧 check_lua_syntax.sh         # Skrypt sprawdzający składnię
└── 📁 server/                     # Serwer MTA
    ├── MTA Server.exe
    └── mods/deathmatch/
        ├── mtaserver.conf         # ✅ Skonfigurowany
        ├── acl.xml               # ✅ Skonfigurowany z Owner ACL
        └── resources/            # 624 zasoby
            ├── [SinceRPG]/       # 470 zasobów SinceRPG
            │   ├── since-core/   # ✅ System podstawowy
            │   ├── since-auth/   # ✅ Logowanie/rejestracja
            │   ├── since-db/     # ✅ Połączenie z bazą
            │   └── ... (467 więcej)
            └── since-startResource/ # ✅ Auto-start
```

---

## 🚀 SZYBKI START

### 1️⃣ Wymagania

- ✅ Windows 7/8/10/11
- ✅ XAMPP (MySQL + Apache)
- ✅ MTA:SA Server 1.6.0+
- ✅ 4GB RAM minimum
- ✅ 10GB wolnego miejsca

### 2️⃣ Instalacja (5 minut)

```bash
# 1. Uruchom XAMPP
#    - Uruchom MySQL

# 2. Importuj bazę danych
#    - Otwórz http://localhost/phpmyadmin
#    - Importuj plik: since.sql

# 3. Uruchom serwer MTA
#    - Uruchom: server/MTA Server.exe

# 4. Połącz się z serwerem
#    - IP: localhost:22003
```

### 3️⃣ Pierwsze logowanie

**Dane właściciela:**
- 👤 Login: `Wlasciciel`
- 🔑 Hasło: `SinceRPG_Owner_2026_SecurePassword!`

**⚠️ WAŻNE:** Po pierwszym logowaniu **MUSISZ** zaktualizować swój serial w bazie!

```sql
UPDATE `since-users` SET serial = 'TWOJ_SERIAL' WHERE uid = 1;
UPDATE `since-admins` SET serial = 'TWOJ_SERIAL' WHERE uid = 1;
```

---

## 📚 DOKUMENTACJA

| Plik | Opis |
|------|------|
| [INSTALACJA.md](INSTALACJA.md) | Kompletna instrukcja instalacji i konfiguracji |
| [RAPORT_NAPRAWY.md](RAPORT_NAPRAWY.md) | Szczegóły naprawy i lista zmian |
| [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) | Pełna dokumentacja 48 tabel bazy |
| [OWNER_CREDENTIALS.txt](OWNER_CREDENTIALS.txt) | Dane dostępowe właściciela |

---

## ⚙️ KONFIGURACJA

### Baza danych (XAMPP)

Plik: `server/mods/deathmatch/resources/[SinceRPG]/since-db/server.lua`

```lua
connection = dbConnect('mysql', 
    'dbname=since;host=127.0.0.1;port=3306;charset=utf8mb4', 
    'root',  -- Użytkownik
    '',      -- Hasło (puste dla lokalnego XAMPP)
    'share=1')
```

### Serwer MTA

Plik: `server/mods/deathmatch/mtaserver.conf`

```xml
<servername>SinceRPG - Roleplay Server</servername>
<serverport>22003</serverport>
<maxplayers>32</maxplayers>
```

### ACL (Uprawnienia)

Właściciel ma pełne uprawnienia przez grupę `Owner` w `acl.xml`

---

## 👤 KONTO WŁAŚCICIELA

### Parametry zmaksymalizowane:

- 💰 Gotówka: **999,999,999 $**
- 🏦 Bank: **999,999,999 $**
- 💎 Premium Points: **999,999,999**
- 🎖️ SRP Points: **999,999,999**
- ⏱️ Czas gry: **999,999,999 min**
- ⭐ Premium: **+10 lat**
- 👮 Admin Level: **10** (maksymalny)

### Licencje (wszystkie):

✅ Prawo jazdy (A, B, C, Motor, Łódź, Samolot)  
✅ Licencja na broń  
✅ Licencja pilota  
✅ Licencja łowcy

---

## 🛠️ SYSTEMY I FUNKCJE

### Główne systemy:

| System | Status | Opis |
|--------|--------|------|
| 👤 Użytkownicy | ✅ | Rejestracja, logowanie, postać |
| 💰 Ekonomia | ✅ | Gotówka, bank, transakcje |
| 🚗 Pojazdy | ✅ | Własność, tuning, paliwo, parkowanie |
| 🏠 Domy | ✅ | Kupno, sprzedaż, magazyn, współlokatorzy |
| 👥 Organizacje | ✅ | Tworzenie, zarządzanie, pojazdy, bank |
| 👮 Frakcje | ✅ | SAPD, SARA, rangi, służba |
| 💼 Prace | ✅ | 15+ różnych prac |
| 🎒 Inventory | ✅ | Przedmioty, craftowanie |
| 👨‍💼 Admin Panel | ✅ | Pełne zarządzanie serwerem |
| 🎰 Kasyno | ✅ | Ruletka, slots, żetony |
| 🌿 Uprawa | ✅ | System uprawy roślin |
| 📨 Poczta | ✅ | Listy między graczami |
| 🎁 Eventy | ✅ | System eventów sezonowych |
| 💎 Premium | ✅ | System premium, punkty |

### Dodatkowe funkcje:

- 🚨 System mandatów i więzienia
- 🏪 Giełda przedmiotów
- 🚙 Salony samochodowe
- 📊 Statystyki graczy
- 🎵 Radio w pojazdach
- 🔧 Mechanik
- ⛽ Stacje paliw
- 🏦 Bankomaty
- 📱 System Discord
- 🎯 Misje fabularne
- 🏁 Wyścigi i drift
- 🎲 Loteria
- 🎫 Vouchery i kody promocyjne
- 📈 System kryptowalut
- I wiele więcej...

---

## 📊 STATYSTYKI PROJEKTU

- **Zasoby:** 624
- **Skrypty Lua:** 1139
- **Tabele bazy:** 48
- **Linie kodu SQL:** 1500+
- **Gotowość:** 95%+
- **Status:** ✅ GOTOWY DO URUCHOMIENIA

---

## 🔧 ROZWIĄZYWANIE PROBLEMÓW

### Nie mogę połączyć się z bazą danych

✅ **Rozwiązanie:**
1. Sprawdź czy MySQL działa w XAMPP
2. Sprawdź port 3306
3. Sprawdź nazwę bazy: `since`
4. Zobacz logi: `server/mods/deathmatch/logs/server.log`

### Nie mogę się zalogować

✅ **Rozwiązanie:**
1. Sprawdź hasło (wielkość liter!)
2. Sprawdź czy baza została zaimportowana
3. Zobacz `logs/scripts.log`

### Nie mam uprawnień admina

✅ **Rozwiązanie:**
1. Zaktualizuj swój serial w bazie danych
2. Zrestartuj serwer
3. Sprawdź grupę Owner w acl.xml

Więcej w: [INSTALACJA.md](INSTALACJA.md) → Sekcja "Rozwiązywanie problemów"

---

## 🔐 BEZPIECZEŃSTWO

### Dla produkcji:

1. ⚠️ Zmień hasło MySQL root
2. ⚠️ Zmień hasło konta właściciela
3. ⚠️ Skonfiguruj firewall
4. ⚠️ Regularne backupy bazy
5. ⚠️ Monitoring logów

### Backup bazy:

```bash
# Export
mysqldump -u root -p since > backup_$(date +%Y%m%d).sql

# Import
mysql -u root -p since < backup_20261111.sql
```

---

## 📝 LICENCJA I PRAWA

Ten projekt jest prywatną paczką SinceRPG.

**Uwagi:**
- Paczka została naprawiona i przygotowana do użytku
- Baza danych została zoptymalizowana
- System połączenia z XAMPP skonfigurowany
- Konto właściciela utworzone

---

## 🆘 WSPARCIE

### Dokumentacja MTA:
- 📖 Wiki: https://wiki.multitheftauto.com/
- 💬 Forum: https://forum.multitheftauto.com/

### Logi serwera:
- `server/mods/deathmatch/logs/server.log`
- `server/mods/deathmatch/logs/scripts.log`
- `server/mods/deathmatch/logs/db.log`

---

## 📅 WERSJONOWANIE

| Wersja | Data | Zmiany |
|--------|------|--------|
| 1.0 | 11.11.2026 | Kompleksowa naprawa i przygotowanie |

---

## ✅ LISTA KONTROLNA INSTALACJI

Przed uruchomieniem serwera sprawdź:

- [ ] XAMPP zainstalowany
- [ ] MySQL uruchomiony (port 3306)
- [ ] Baza `since` zaimportowana
- [ ] Konto właściciela istnieje (uid=1)
- [ ] Serwer MTA uruchomiony
- [ ] Połączenie z bazą działa
- [ ] Zalogowano jako właściciel
- [ ] Serial zaktualizowany w bazie
- [ ] Uprawnienia admina działają
- [ ] Backup bazy utworzony

---

## 🎉 GOTOWE!

Serwer jest gotowy do uruchomienia. Miłej zabawy!

Jeśli masz pytania, sprawdź dokumentację w plikach:
- [INSTALACJA.md](INSTALACJA.md)
- [RAPORT_NAPRAWY.md](RAPORT_NAPRAWY.md)

---

**Wersja:** 1.0  
**Data:** 11.11.2026  
**Status:** ✅ GOTOWY  
**System:** SinceRPG - MTA:SA Roleplay Server
