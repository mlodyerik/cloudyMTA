# SinceRPG - Instrukcja Instalacji i Uruchomienia

## Wersja: Fixed & Configured for XAMPP
## Data: 2026-11-11

---

## 📋 Wymagania

### Oprogramowanie wymagane:
1. **MTA:SA Server 1.6** lub nowszy
2. **XAMPP** (Apache + MySQL/MariaDB)
   - MySQL/MariaDB musi być uruchomiony
   - Port: 3306 (domyślny)
3. **phpMyAdmin** (wbudowany w XAMPP)

### Zalecane parametry systemu:
- System: Windows 7/10/11, Linux
- RAM: minimum 2GB
- HDD: minimum 5GB wolnej przestrzeni

---

## 🔧 Instalacja Krok po Kroku

### KROK 1: Uruchomienie XAMPP i MySQL

1. Zainstaluj XAMPP z oficjalnej strony: https://www.apachefriends.org/
2. Uruchom XAMPP Control Panel
3. Uruchom moduł **MySQL** (kliknij "Start")
4. Sprawdź czy MySQL działa - kontrolka powinna być zielona
5. Opcjonalnie uruchom **Apache** jeśli chcesz używać phpMyAdmin

### KROK 2: Import Bazy Danych

1. Otwórz przeglądarkę i przejdź do: `http://localhost/phpmyadmin`
2. Zaloguj się (domyślnie user: `root`, hasło: **puste**)
3. Kliknij "New" (Nowa) aby utworzyć bazę danych
4. Nazwa bazy: `since`
5. Encoding: `utf8mb4_general_ci`
6. Kliknij "Create"
7. Wybierz utworzoną bazę `since`
8. Przejdź do zakładki "Import"
9. Wybierz plik `since.sql` z katalogu głównego paczki
10. Kliknij "Go" / "Wykonaj"
11. Poczekaj na zakończenie importu (może potrwać 1-2 minuty)

**UWAGA:** Jeśli ustawiłeś hasło dla użytkownika root w MySQL, musisz zaktualizować plik:
`server/mods/deathmatch/resources/[SinceRPG]/since-db/server.lua`

Zmień linię:
```lua
connection = dbConnect('mysql', 'dbname=since;host=127.0.0.1;port=3306;charset=utf8', 'root', '', 'share=1')
```

Na (wpisz swoje hasło):
```lua
connection = dbConnect('mysql', 'dbname=since;host=127.0.0.1;port=3306;charset=utf8', 'root', 'TWOJE_HASLO', 'share=1')
```

### KROK 3: Konfiguracja Serwera MTA

1. Skopiuj całą zawartość katalogu `server/` do folderu instalacji MTA:SA Server
2. Upewnij się że struktura katalogów jest prawidłowa:
   ```
   [Folder MTA Server]/
   ├── MTA Server.exe
   ├── mods/
   │   └── deathmatch/
   │       ├── resources/
   │       │   ├── [SinceRPG]/
   │       │   ├── [admin]/
   │       │   └── ...
   │       ├── acl.xml
   │       ├── mtaserver.conf
   │       └── ...
   └── ...
   ```

### KROK 4: Pierwsze Uruchomienie Serwera

1. Uruchom `MTA Server.exe`
2. Sprawdź logi w oknie konsoli
3. Poszukaj komunikatu: `[since-db] Successfully connected with MySQL database: since`
4. Jeśli widzisz ten komunikat - połączenie z bazą działa!
5. Poczekaj aż wszystkie zasoby się załadują

**W przypadku błędów:**
- Sprawdź czy MySQL w XAMPP jest uruchomiony
- Sprawdź plik `server/mods/deathmatch/logs/server.log`
- Sprawdź plik `server/mods/deathmatch/logs/scripts.log`
- Sprawdź plik `server/mods/deathmatch/logs/db.log`

---

## 👤 Logowanie jako Właściciel

### Dane Logowania Właściciela:
- **Login:** `Wlasciciel`
- **Hasło:** `Wlasciciel2025!`
- **Poziom administracyjny:** 4 (najwyższy)
- **UID:** 100

### Parametry Postaci Właściciela (Wymaksowane):
- Pieniądze gotówka: 999,999,999 $
- Pieniądze w banku: 999,999,999 $
- Poziom SRP: 9999
- Czas gry: 999,999 minut
- Premium: aktywne do 2099-12-31
- Premium punkty: 999,999
- Wszystkie parametry: MAKSYMALNE

### Uprawnienia Administracyjne:
✅ Pełny dostęp do panelu administracyjnego
✅ Wszystkie komendy administracyjne
✅ Zarządzanie graczami
✅ Zarządzanie pojazdami
✅ Zarządzanie ekonomią
✅ Banowanie/odbanowywanie
✅ Kickowanie graczy
✅ Teleportacja
✅ Nadawanie pieniędzy
✅ Modyfikacja pogody/czasu
✅ Uruchamianie/zatrzymywanie zasobów
✅ Dostęp do ACL
✅ Pełny dostęp do wszystkich systemów serwera

**WAŻNE:** Zmień hasło po pierwszym zalogowaniu w grze!

---

## 🔒 Bezpieczeństwo

1. **NIE UDOSTĘPNIAJ** danych logowania właściciela nikomu
2. **Zmień hasło** właściciela po pierwszym zalogowaniu
3. Plik `OWNER_CREDENTIALS.txt` zawiera wszystkie dane - **przechowuj go bezpiecznie**
4. **Nie dodawaj** pliku `OWNER_CREDENTIALS.txt` do publicznego repozytorium Git
5. Regularnie rób **backup bazy danych**

---

## 🐛 Rozwiązywanie Problemów

### Błąd: "Failed to connect with database"
**Rozwiązanie:**
1. Sprawdź czy MySQL w XAMPP jest uruchomiony
2. Sprawdź czy baza `since` istnieje w phpMyAdmin
3. Sprawdź hasło w pliku `since-db/server.lua`
4. Sprawdź port MySQL (domyślnie 3306)

### Błąd: "Access denied @ 'startResource'"
**Rozwiązanie:**
1. Poczekaj 30 sekund po uruchomieniu serwera
2. W konsoli wpisz: `aclrequest list since-startResource`
3. W konsoli wpisz: `aclrequest allow since-startResource all`
4. Restart serwera: `restart since-startResource`

### Błąd: "exports: Call to non-running server resource (since-db)"
**Rozwiązanie:**
1. Sprawdź czy zasób `since-db` został uruchomiony
2. W konsoli wpisz: `restart since-db`
3. Poczekaj 10 sekund i wpisz: `restart since-startResource`

### Zasoby nie startują automatycznie
**Rozwiązanie:**
1. Otwórz `mtaserver.conf`
2. Znajdź linię: `<resource src="[SinceRPG]/since-db" startup="1" protected="1" />`
3. Upewnij się że parametr `startup="1"`
4. Znajdź linię: `<resource src="since-startResource" startup="1" protected="1" />`
5. Upewnij się że parametr `startup="1"`

### Logi pokazują wiele błędów Lua
**Rozwiązanie:**
- Większość ostrzeżeń o przestarzałych funkcjach (deprecated) to normalne zachowanie
- Serwer powinien działać pomimo tych ostrzeżeń
- Skup się tylko na błędach typu ERROR, nie WARNING

---

## 📊 Struktura Bazy Danych

Baza `since` zawiera następujące główne tabele:

### Tabele związane z graczami:
- `since-users` - Konta graczy i ich dane postaci
- `since-admins` - Lista administratorów
- `since-ban` - Bany graczy

### Tabele związane z ekonomią:
- `since-atms-logs` - Logi bankomatów
- `since-casino` - Dane kasyna
- `since-lottery` - Loteria
- `since-prices` - Ceny przedmiotów

### Tabele związane z pojazdami:
- `since-vehicles` - Pojazdy graczy
- `since-orgs-vehicles` - Pojazdy organizacji
- `since-carsRobbery` - Pojazdy do kradzieży

### Tabele związane z organizacjami:
- `since-orgs` - Organizacje
- `since-orgs-logs` - Logi organizacji
- `since-factions` - Frakcje

### Inne ważne tabele:
- `since-houses` - Domy graczy
- `since-items` - Przedmioty
- `since-jobs` - Prace
- `since-mandates` - Mandaty
- `since-znajdzki` - Znajdźki

---

## 🆘 Wsparcie

### Logi do sprawdzenia w przypadku problemów:
1. `server/mods/deathmatch/logs/server.log` - Główny log serwera
2. `server/mods/deathmatch/logs/scripts.log` - Błędy Lua
3. `server/mods/deathmatch/logs/db.log` - Logi zapytań do bazy danych

### Przydatne komendy konsoli MTA:
- `start [nazwa-zasobu]` - Uruchom zasób
- `stop [nazwa-zasobu]` - Zatrzymaj zasób
- `restart [nazwa-zasobu]` - Zrestartuj zasób
- `refresh` - Odśwież listę zasobów
- `aclrequest list [zasób]` - Pokaż żądania ACL
- `aclrequest allow [zasób] all` - Nadaj wszystkie uprawnienia
- `debugscript 3` - Włącz szczegółowe logi Lua

---

## ✅ Checklist Instalacji

- [ ] XAMPP zainstalowany
- [ ] MySQL w XAMPP uruchomiony
- [ ] Baza danych `since` utworzona w phpMyAdmin
- [ ] Plik `since.sql` zaimportowany do bazy `since`
- [ ] Import zakończony sukcesem (brak błędów)
- [ ] Pliki serwera MTA skopiowane
- [ ] Hasło MySQL zaktualizowane w `since-db/server.lua` (jeśli potrzebne)
- [ ] MTA Server uruchomiony
- [ ] Komunikat "Successfully connected with database" widoczny w logach
- [ ] Wszystkie zasoby załadowane bez krytycznych błędów
- [ ] Możliwość zalogowania jako właściciel
- [ ] Backup danych logowania utworzony

---

## 📝 Uwagi Końcowe

1. Paczka została naprawiona i skonfigurowana dla lokalnego środowiska XAMPP
2. Wszystkie krytyczne błędy zostały naprawione
3. Konto właściciela ma pełne uprawnienia i wymaksowane parametry
4. System bazy danych jest w pełni skonfigurowany
5. Większość zasobów powinna działać poprawnie

**Jeśli napotkasz problemy, sprawdź logi i skorzystaj z sekcji "Rozwiązywanie Problemów"**

---

**Wersja dokumentacji:** 1.0  
**Data ostatniej aktualizacji:** 2026-11-11  
**Kompatybilność:** MTA:SA 1.6+, XAMPP 8.x, MySQL/MariaDB 10.x+
