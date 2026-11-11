# INSTALACJA I KONFIGURACJA SINCERPG

## WYMAGANIA SYSTEMOWE

- Windows 7/8/10/11
- XAMPP (Apache + MySQL/MariaDB)
- MTA San Andreas Server 1.6.0 lub nowszy
- Minimum 4GB RAM
- 10GB wolnego miejsca na dysku

## KROK 1: INSTALACJA XAMPP

1. Pobierz XAMPP z oficjalnej strony: https://www.apachefriends.org/
2. Zainstaluj XAMPP (domyślnie do `C:\xampp\`)
3. Uruchom XAMPP Control Panel
4. Uruchom **Apache** i **MySQL**
5. Sprawdź, czy MySQL działa na porcie **3306**

## KROK 2: KONFIGURACJA BAZY DANYCH

### 2.1. Import bazy danych

1. Otwórz przeglądarkę i wejdź na: **http://localhost/phpmyadmin**
2. Zaloguj się (domyślnie użytkownik: `root`, hasło: puste)
3. Kliknij "Nowa" lub "New" aby utworzyć nową bazę danych
4. Jeśli baza `since` już istnieje, usuń ją najpierw
5. Kliknij zakładkę **Import**
6. Wybierz plik `since.sql` z katalogu głównego serwera
7. Kliknij **Wykonaj** (Go)
8. Poczekaj na zakończenie importu

### 2.2. Weryfikacja importu

Sprawdź czy baza zawiera wszystkie tabele:

```sql
USE since;
SHOW TABLES;
```

Powinieneś zobaczyć około 48 tabel, w tym:
- `since-users`
- `since-admins`
- `since-vehicles`
- `since-houses`
- `since-orgs`
- itd.

### 2.3. Weryfikacja konta właściciela

Sprawdź czy konto właściciela zostało utworzone:

```sql
SELECT uid, login, nick FROM `since-users` WHERE uid = 1;
```

Powinno zwrócić:
- **uid**: 1
- **login**: Wlasciciel
- **nick**: Wlasciciel

## KROK 3: KONFIGURACJA POŁĄCZENIA Z BAZĄ

Plik `server/mods/deathmatch/resources/[SinceRPG]/since-db/server.lua` jest już skonfigurowany dla lokalnego XAMPP:

```lua
connection = dbConnect('mysql', 'dbname=since;host=127.0.0.1;port=3306;charset=utf8mb4', 'root', '', 'share=1')
```

**UWAGA dla produkcji:**
- Zmień hasło użytkownika root w MySQL
- Zaktualizuj dane dostępowe w pliku `since-db/server.lua`

## KROK 4: URUCHOMIENIE SERWERA MTA

1. Przejdź do katalogu: `server/`
2. Uruchom **MTA Server.exe**
3. Poczekaj na załadowanie wszystkich zasobów (624 zasoby)
4. Sprawdź konsole czy nie ma krytycznych błędów

### Oczekiwane komunikaty:

```
[SinceRPG] Successfully connected with database
[SinceRPG] Database: since | Host: 127.0.0.1:3306
```

## KROK 5: PIERWSZE LOGOWANIE

1. Uruchom klienta MTA San Andreas
2. Połącz się z serwerem (domyślnie localhost:22003)
3. W oknie logowania wybierz **"Zarejestruj się"**
4. **ZAMIAST** rejestracji, użyj danych właściciela:
   - **Login**: `Wlasciciel`
   - **Hasło**: `SinceRPG_Owner_2026_SecurePassword!`

### WAŻNE - Aktualizacja serialu:

Po pierwszym zalogowaniu **MUSISZ** zaktualizować swój serial w bazie danych:

1. W grze użyj komendy `/serial` lub sprawdź w F8
2. Skopiuj swój serial (np. `ABC123DEF456...`)
3. W phpMyAdmin wykonaj:

```sql
UPDATE `since-users` SET serial = 'TWOJ_PRAWDZIWY_SERIAL' WHERE uid = 1;
UPDATE `since-admins` SET serial = 'TWOJ_PRAWDZIWY_SERIAL' WHERE uid = 1;
```

4. Zrestartuj serwer MTA

## KROK 6: WERYFIKACJA UPRAWNIEŃ

Po ponownym zalogowaniu:

1. Naciśnij **F1** - powinien otworzyć się panel administracyjny
2. Wypróbuj komendy:
   - `/veh 411` - dać pojazd
   - `/heal` - uzdrowiź się
   - `/goto X Y Z` - teleportacja
   - `/akill` - lista komend admina

## KROK 7: KONFIGURACJA ZAAWANSOWANA (OPCJONALNA)

### Zmiana nazwy serwera

Edytuj: `server/mods/deathmatch/mtaserver.conf`

```xml
<servername>TWOJA NAZWA SERWERA</servername>
```

### Zmiana hasła do serwera

```xml
<password>TWOJE_HASLO</password>
```

### Zmiana maksymalnej liczby graczy

```xml
<maxplayers>64</maxplayers>
```

## KROK 8: BACKUP

**KRYTYCZNIE WAŻNE:**

Regularnie twórz backup:

1. **Baza danych:**
   - phpMyAdmin → Eksport → Zapisz jako `backup_YYYY-MM-DD.sql`

2. **Pliki serwera:**
   - Cały katalog `server/mods/deathmatch/`

3. **Częstotliwość:**
   - Codziennie (automatyczny backup przez skrypt)
   - Przed każdą aktualizacją
   - Po ważnych zmianach

## ROZWIĄZYWANIE PROBLEMÓW

### Problem: Nie mogę połączyć się z bazą danych

**Rozwiązanie:**
1. Sprawdź czy MySQL działa w XAMPP Control Panel
2. Sprawdź port w konfiguracji (domyślnie 3306)
3. Sprawdź użytkownika i hasło
4. Zobacz logi: `server/mods/deathmatch/logs/server.log`

### Problem: Nie mogę się zalogować jako właściciel

**Rozwiązanie:**
1. Sprawdź czy baza została poprawnie zaimportowana
2. Sprawdź dane logowania (wielkość liter ma znaczenie!)
3. Sprawdź czy serial w bazie jest ustawiony na placeholder
4. Zobacz logi: `server/mods/deathmatch/logs/scripts.log`

### Problem: Nie mam uprawnień administratora

**Rozwiązanie:**
1. Zaktualizuj swój serial w tabeli `since-users` i `since-admins`
2. Sprawdź czy jesteś w grupie Owner w `acl.xml`
3. Zrestartuj serwer

### Problem: Brak połączenia z serwerem

**Rozwiązanie:**
1. Sprawdź czy port 22003 (UDP) jest otwarty
2. Sprawdź firewall
3. Sprawdź czy serwer się uruchomił (konsola)

### Problem: Zasoby się nie ładują

**Rozwiązanie:**
1. Sprawdź logi: `logs/server.log` i `logs/scripts.log`
2. Użyj komendy w konsoli: `refresh`
3. Zrestartuj konkretny zasób: `restart NAZWA_ZASOBU`

## PARAMETRY POSTACI WŁAŚCICIELA

Wszystkie parametry są już ustawione na maksimum:

- 💰 Pieniądze gotówką: **999,999,999 $**
- 🏦 Pieniądze w banku: **999,999,999 $**
- 💎 Punkty premium: **999,999,999**
- 🎖️ Punkty SRP: **999,999,999**
- ⏱️ Czas gry: **999,999,999 minut**
- ⭐ Premium: **ważne przez 10 lat**
- 🪪 Wszystkie licencje: **odblokowane**
- 👮 Poziom admina: **10 (maksymalny)**

## BEZPIECZEŃSTWO

### Dla serwera produkcyjnego:

1. **Zmień hasło MySQL root:**
   ```sql
   SET PASSWORD FOR 'root'@'localhost' = PASSWORD('SILNE_HASLO');
   ```

2. **Zmień hasło konta właściciela w grze**

3. **Ogranicz dostęp do phpMyAdmin:**
   - Edytuj `C:\xampp\phpMyAdmin\config.inc.php`
   - Dodaj authentication

4. **Firewall:**
   - Otwórz tylko potrzebne porty: 22003 (UDP), 22005 (TCP)

5. **Backupy automatyczne:**
   - Zainstaluj cron job dla backupów bazy

## WSPARCIE

W razie problemów sprawdź:

1. **Dokumentację MTA:** https://wiki.multitheftauto.com/
2. **Forum MTA:** https://forum.multitheftauto.com/
3. **Logi serwera:** `server/mods/deathmatch/logs/`

## LISTA KONTROLNA INSTALACJI

- [ ] XAMPP zainstalowany i uruchomiony
- [ ] MySQL działa na porcie 3306
- [ ] Baza `since` zaimportowana pomyślnie
- [ ] Konto właściciela istnieje w bazie
- [ ] Serwer MTA uruchomiony bez błędów
- [ ] Połączenie z bazą danych działa
- [ ] Udało się zalogować jako właściciel
- [ ] Serial zaktualizowany w bazie danych
- [ ] Uprawnienia administratora działają
- [ ] Backup bazy danych utworzony
- [ ] Hasło zmienione (produkcja)

---

**Data utworzenia:** 2026-11-11  
**Wersja:** 1.0  
**System:** SinceRPG MTA:SA Server
