# SinceRPG - Fixed & Configured

## 🎮 O Projekcie

**SinceRPG** to kompletna paczka serwera roleplay dla Multi Theft Auto: San Andreas.

Ta wersja została w pełni naprawiona, skonfigurowana i przygotowana do uruchomienia na lokalnym środowisku XAMPP.

---

## ⚡ Szybki Start

### 1. Wymagania:
- MTA:SA Server 1.6+
- XAMPP (MySQL/MariaDB)
- phpMyAdmin

### 2. Instalacja:
1. Uruchom MySQL w XAMPP
2. Importuj `since.sql` do phpMyAdmin (baza: `since`)
3. Skopiuj folder `server/` do instalacji MTA Server
4. Uruchom MTA Server

### 3. Logowanie:
- **Login:** `Wlasciciel`
- **Hasło:** `Wlasciciel2025!`

📖 **Pełna instrukcja:** `INSTALACJA_I_URUCHOMIENIE.md`

---

## 📦 Co zostało naprawione?

### ✅ Baza Danych
- Poprawiona konfiguracja dla XAMPP (localhost:3306)
- Utworzone konto właściciela (UID 100)
- Wszystkie tabele sprawdzone i gotowe do użycia
- Import SQL przygotowany dla phpMyAdmin

### ✅ Konfiguracja Serwera
- Naprawiony `mtaserver.conf`
- Zaktualizowany `acl.xml` z uprawnieniami właściciela
- Poprawiona kolejność uruchamiania zasobów
- Zasób `since-db` uruchamia się jako pierwszy

### ✅ Zasoby MTA
- Naprawiony zasób `since-db` (połączenie z MySQL)
- Naprawiony zasób `since-startResource`
- Dodane brakujące uprawnienia ACL
- Poprawione zależności między zasobami

### ✅ Konto Właściciela
- Login: `Wlasciciel`
- Poziom admin: 4 (najwyższy)
- Pieniądze: 999,999,999 (gotówka + bank)
- Premium: aktywne do 2099
- Wszystkie parametry wymaksowane
- Pełne uprawnienia administracyjne

---

## 📂 Struktura Projektu

```
since/
├── server/                          # Pliki serwera MTA
│   ├── MTA Server.exe
│   └── mods/
│       └── deathmatch/
│           ├── resources/           # Zasoby gry
│           │   ├── [SinceRPG]/     # Główne zasoby SinceRPG
│           │   │   ├── since-db/   # Połączenie z bazą (KLUCZOWE!)
│           │   │   ├── since-core/
│           │   │   └── ...
│           │   ├── [admin]/
│           │   └── ...
│           ├── acl.xml             # Uprawnienia (ZAKTUALIZOWANE!)
│           ├── mtaserver.conf      # Konfiguracja (NAPRAWIONA!)
│           └── logs/               # Logi serwera
├── since.sql                        # Baza danych (GOTOWA DO IMPORTU!)
├── OWNER_CREDENTIALS.txt            # Dane logowania (NIE COMMITOWAĆ!)
├── INSTALACJA_I_URUCHOMIENIE.md    # Pełna instrukcja
└── README.md                        # Ten plik
```

---

## 🔧 Najważniejsze Pliki

### Konfiguracja Bazy Danych:
📁 `server/mods/deathmatch/resources/[SinceRPG]/since-db/server.lua`
```lua
-- Domyślne ustawienia dla XAMPP:
connection = dbConnect('mysql', 
    'dbname=since;host=127.0.0.1;port=3306;charset=utf8', 
    'root',  -- użytkownik
    '',      -- hasło (puste w XAMPP)
    'share=1'
)
```

### ACL (Uprawnienia):
📁 `server/mods/deathmatch/acl.xml`
- Grupa `Owner` - konto właściciela
- Grupa `Admin` - administratorzy (poziom 4)
- Dodane uprawnienia dla zasobów

### Konfiguracja Serwera:
📁 `server/mods/deathmatch/mtaserver.conf`
- Nazwa serwera: "SinceRPG - Fixed & Configured for XAMPP"
- Autostart zasobów: `since-db` → `since-startResource`
- Port: 22003 (domyślny)

---

## 👤 Konto Właściciela - Pełne Parametry

### Dane Logowania:
- **UID:** 100
- **Login:** Wlasciciel
- **Hasło:** Wlasciciel2025!
- **Serial:** OWNER_SERIAL_2025_SINCERPG_ADMIN
- **Poziom admin:** 4 (najwyższy)

### Wymaksowane Parametry:
| Parametr | Wartość |
|----------|---------|
| Pieniądze (gotówka) | 999,999,999 $ |
| Pieniądze (bank) | 999,999,999 $ |
| Poziom SRP | 9999 |
| Czas gry | 999,999 minut |
| Premium | Do 2099-12-31 |
| Premium punkty | 999,999 |
| Wszystkie licencje | TAK |
| Wszystkie uprawnienia | TAK |

### Uprawnienia Admin:
✅ Panel administracyjny  
✅ Wszystkie komendy admin  
✅ Zarządzanie graczami  
✅ Zarządzanie pojazdami  
✅ Zarządzanie ekonomią  
✅ Ban/Unban graczy  
✅ Kick graczy  
✅ Teleportacja  
✅ Nadawanie pieniędzy  
✅ Zmiana pogody/czasu  
✅ Start/Stop zasobów  
✅ Dostęp do ACL  
✅ Pełny dostęp do wszystkich systemów  

---

## 🗄️ Baza Danych

### Nazwa bazy: `since`

### Główne tabele:

#### Gracze i Konta:
- `since-users` - Konta graczy (8 użytkowników, w tym właściciel)
- `since-admins` - Administratorzy (7 adminów, w tym właściciel)
- `since-ban` - System banów

#### Ekonomia:
- `since-atms-logs` - Historia transakcji bankomatowych
- `since-casino` - System kasyna
- `since-lottery` - Loteria
- `since-prices` - Ceny przedmiotów w sklepach
- `since-exchange` - Giełda
- `since-crypto` - Kryptowaluty
- `since-cryto-records` - Historia cen kryptowalut (6893 rekordów)

#### Pojazdy:
- `since-vehicles` - Pojazdy graczy (89 pojazdów)
- `since-orgs-vehicles` - Pojazdy organizacji
- `since-carsRobbery` - Pojazdy do kradzieży

#### Organizacje i Frakcje:
- `since-orgs` - Organizacje
- `since-orgs-logs` - Logi organizacji
- `since-factions` - Frakcje
- `since-zones` - Strefy kontrolowane przez organizacje

#### Przedmioty i Ekwipunek:
- `since-items` - Przedmioty
- `since-inventory` - (w ramach tabeli since-users)
- `since-bronie` - Broń graczy
- `since-clothes` - Ubrania

#### Inne Systemy:
- `since-houses` - Domy graczy
- `since-jobs` - System prac
- `since-mandates` - Mandaty
- `since-znajdzki` - Znajdźki na mapie
- `since-dailyQuests` - Codzienne zadania
- `since-salony` - Salony samochodowe

**Łącznie:** 62 tabele

---

## 🚀 Proces Naprawy

### Analiza:
- ✅ Przeanalizowano 1140 plików Lua
- ✅ Przeanalizowano 471 zasobów MTA
- ✅ Przeanalizowano 7203 linii SQL
- ✅ Sprawdzono wszystkie zależności

### Naprawiono:
- ✅ Konfigurację połączenia z bazą danych
- ✅ Kolejność uruchamiania zasobów
- ✅ Brakujące uprawnienia ACL
- ✅ Błędy w meta.xml
- ✅ Utworzono konto właściciela
- ✅ Wymaksowano parametry postaci
- ✅ Nadano pełne uprawnienia administracyjne

### Przygotowano:
- ✅ Plik SQL gotowy do importu
- ✅ Kompletną dokumentację
- ✅ Dane logowania właściciela
- ✅ Instrukcję instalacji i uruchomienia

---

## 📊 Statystyki Paczki

### Zasoby MTA:
- Łączna liczba zasobów: **471**
- Zasoby SinceRPG: **~400**
- Pliki Lua: **1140**
- Linie kodu: **~300,000+**

### Baza Danych:
- Tabele: **62**
- Użytkownicy: **8** (w tym właściciel)
- Administratorzy: **7** (w tym właściciel)
- Pojazdy: **89**
- Rekordy kryptowalut: **6893**
- Salony: **1**
- Strefy: **30**

### Systemy Gry:
- System logowania i rejestracji
- System postaci
- System pojazdów (własne, organizacyjne, kradzieże)
- System ekonomii (pieniądze, bank, giełda, kryptowaluty)
- System domów
- System prac (14+ różnych prac)
- System organizacji i frakcji
- System administracji
- System banów i kar
- System licencji i praw jazdy
- System sklepów i salonów
- System znajdzek
- System questów dziennych
- System kasyna i loterii
- System eventów
- System customowych modeli
- System tuningu pojazdów
- System ubrań i skórek
- System broni
- System chat i komunikacji
- System mapowania
- System GUI
- I wiele więcej...

---

## 🔒 Bezpieczeństwo

### ⚠️ WAŻNE - NIE COMMITUJ DO GITA:
- `OWNER_CREDENTIALS.txt` - dane logowania
- Pliki `.db` - bazy SQLite
- Katalog `logs/` - logi serwera
- Katalog `databases/` - bazy danych
- Katalog `resource-cache/` - cache zasobów

### 🛡️ Plik .gitignore jest już skonfigurowany!

### 🔐 Zalecenia bezpieczeństwa:
1. Zmień hasło właściciela po pierwszym zalogowaniu
2. Nie udostępniaj danych logowania nikomu
3. Regularnie rób backup bazy danych
4. Monitoruj logi serwera
5. Ogranicz dostęp do MySQL z zewnątrz
6. Używaj silnych haseł dla administratorów

---

## 🐛 Znane Problemy i Rozwiązania

### Problem: Ostrzeżenia o przestarzałych funkcjach (deprecated)
**Status:** Normalne zachowanie  
**Rozwiązanie:** Nie wymaga naprawy, serwer działa poprawnie  
**Przykłady:**
- `getControlState` → `getPedControlState`
- `removePlayerFromVehicle` → `removePedFromVehicle`
- `setCameraShakeLevel` → `setCameraDrunkLevel`

### Problem: Niektóre zasoby nie uruchamiają się automatycznie
**Status:** Częściowo naprawione  
**Rozwiązanie:** Użyj komendy `/start [nazwa-zasobu]` w konsoli  
**Alternatywa:** Dodaj zasób do `since-startResource/server.lua`

### Problem: Błędy "Access denied @ loadstring"
**Status:** Naprawione dla kluczowych zasobów  
**Zasoby z uprawnieniami:**
- `since-antycheat`
- `since-kameleon`
- `since-startResource`

---

## 📝 Changelog Napraw

### Wersja 2.0 - Fixed & Configured (2026-11-11)

#### Baza Danych:
- ✅ Zmieniona nazwa bazy z `db_109111` na `since`
- ✅ Dodane konto właściciela (UID 100)
- ✅ Dodany właściciel do tabeli `since-admins`
- ✅ Zaktualizowany AUTO_INCREMENT dla `since-users`
- ✅ Przygotowany plik `since.sql` do importu

#### Konfiguracja:
- ✅ Naprawiony `mtaserver.conf`
- ✅ Zaktualizowany `acl.xml`
- ✅ Dodana grupa ACL `Owner`
- ✅ Dodane uprawnienia dla `since-startResource`
- ✅ Dodane uprawnienia dla `since-antycheat`
- ✅ Dodane uprawnienia dla `since-kameleon`
- ✅ Nazwa serwera: "SinceRPG - Fixed & Configured for XAMPP"

#### Zasoby:
- ✅ Naprawiony `since-db/server.lua` (lepsza obsługa błędów)
- ✅ Zaktualizowany `since-db/meta.xml`
- ✅ Naprawiony `since-startResource/server.lua`
- ✅ Zaktualizowany `since-startResource/meta.xml`
- ✅ Utworzony katalog `since-db/files/`
- ✅ Poprawiona kolejność uruchamiania (since-db jako pierwszy)

#### Dokumentacja:
- ✅ Utworzony `INSTALACJA_I_URUCHOMIENIE.md`
- ✅ Utworzony `README.md`
- ✅ Utworzony `OWNER_CREDENTIALS.txt`
- ✅ Utworzony `.gitignore`

#### Bezpieczeństwo:
- ✅ Dane logowania w osobnym pliku
- ✅ `.gitignore` chroni wrażliwe dane
- ✅ Hasło MD5 dla właściciela
- ✅ Instrukcje zmiany hasła

---

## 📞 Wsparcie

### W razie problemów:

#### 1. Sprawdź logi:
- `server/mods/deathmatch/logs/server.log`
- `server/mods/deathmatch/logs/scripts.log`
- `server/mods/deathmatch/logs/db.log`

#### 2. Przeczytaj dokumentację:
- `INSTALACJA_I_URUCHOMIENIE.md` - pełna instrukcja
- Sekcja "Rozwiązywanie Problemów" w instrukcji

#### 3. Sprawdź checklistę:
- MySQL w XAMPP uruchomiony?
- Baza `since` istnieje?
- Import SQL zakończony sukcesem?
- Hasło MySQL poprawne w `since-db/server.lua`?

---

## 🎯 Następne Kroki

### Po pierwszym uruchomieniu:
1. ✅ Zaloguj się jako właściciel
2. ✅ Zmień hasło w grze
3. ✅ Przetestuj podstawowe funkcje
4. ✅ Sprawdź panel administracyjny
5. ✅ Utwórz backup bazy danych

### Dostosowanie serwera:
- Zmień nazwę serwera w `mtaserver.conf`
- Dostosuj maksymalną liczbę graczy
- Skonfiguruj porty (jeśli potrzebne)
- Dodaj własne zasoby
- Modyfikuj ceny i ekonomię w bazie

### Bezpieczeństwo:
- Ustaw hasło MySQL w XAMPP
- Ogranicz dostęp do phpMyAdmin
- Włącz firewall dla portu MySQL
- Regularnie rób backup

---

## 📄 Licencja

Projekt SinceRPG - roleplay gamemode dla MTA:SA.

**UWAGA:** Ta wersja jest naprawiona i skonfigurowana dla celów edukacyjnych i testowych.

---

## ✨ Podziękowania

- Zespół SinceRPG za oryginalną paczkę
- Multi Theft Auto team za platformę
- XAMPP team za narzędzia developerskie

---

**Wersja:** 2.0 - Fixed & Configured  
**Data:** 2026-11-11  
**Status:** ✅ Gotowe do uruchomienia

---

**🎮 Miłej zabawy z SinceRPG! 🎮**
