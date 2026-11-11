# cloudyMTA - Kompleksowa Instrukcja Instalacji i Uruchomienia

## 📋 Spis Treści
1. [Wymagania](#wymagania)
2. [Instalacja Krok po Kroku](#instalacja-krok-po-kroku)
3. [Konfiguracja Bazy Danych](#konfiguracja-bazy-danych)
4. [Uruchomienie Serwera](#uruchomienie-serwera)
5. [Logowanie](#logowanie)
6. [Rozwiązywanie Problemów](#rozwiązywanie-problemów)

---

## Wymagania

### Oprogramowanie
- **MTA:SA Server** 1.6 lub nowszy
- **XAMPP** (MySQL/MariaDB + phpMyAdmin)
- **Windows** 10/11 lub Windows Server
- **PHP** 7.4+ (included in XAMPP)

### Specyfikacja Sprzętowa (Minimum)
- **CPU**: Intel Core i3 / AMD Ryzen 3 (2 rdzenie)
- **RAM**: 4 GB
- **Dysk**: 10 GB wolnej przestrzeni (SSD zalecany)
- **Sieć**: Stabilne połączenie internetowe (upload 10 Mbps+)

### Specyfikacja Sprzętowa (Zalecana)
- **CPU**: Intel Core i5 / AMD Ryzen 5 (4+ rdzenie)
- **RAM**: 8 GB+
- **Dysk**: 20 GB+ wolnej przestrzeni (SSD)
- **Sieć**: Stabilne połączenie internetowe (upload 50 Mbps+)

---

## Instalacja Krok po Kroku

### Krok 1: Pobranie i Przygotowanie

1. **Pobierz cloudyMTA**
   - Z GitHub: `https://github.com/mlodyerik/cloudyMTA`
   - Lub użyj archiwum `cloudyMTA_Phase1.zip`

2. **Rozpakuj archiwum**
   ```
   cloudyMTA.zip → C:\cloudyMTA\
   ```

3. **Sprawdź strukturę folderów**
   ```
   C:\cloudyMTA\
   ├── server/
   │   ├── MTA Server.exe
   │   ├── core.dll
   │   └── mods/
   │       └── deathmatch/
   │           ├── mtaserver.conf
   │           └── resources/
   │               └── [SinceRPG]/
   ├── db_109111.sql
   └── README.md
   ```

### Krok 2: Instalacja XAMPP

1. **Pobierz XAMPP**
   - Strona: https://www.apachefriends.org/
   - Wybierz wersję z PHP 7.4 lub 8.0

2. **Zainstaluj XAMPP**
   - Domyślna lokalizacja: `C:\xampp\`
   - Zaznacz: Apache, MySQL, phpMyAdmin
   - Kliknij "Install"

3. **Uruchom XAMPP Control Panel**
   - Znajdź: `C:\xampp\xampp-control.exe`
   - Uruchom jako Administrator

4. **Wystartuj usługi**
   - Kliknij "Start" przy **Apache**
   - Kliknij "Start" przy **MySQL**
   - Poczekaj aż status zmieni się na "Running" (zielony)

### Krok 3: Instalacja MTA:SA Server

1. **Pobierz MTA Server**
   - Strona: https://multitheftauto.com/
   - Sekcja "Downloads" → "MTA:SA Server"
   - Wybierz najnowszą wersję (1.6+)

2. **Zainstaluj MTA Server**
   - Domyślna lokalizacja: `C:\Program Files\MTA San Andreas 1.6\server\`
   - Lub własna lokalizacja: `C:\MTA-Server\`

3. **Weryfikacja instalacji**
   - Znajdź plik: `MTA Server.exe`
   - Znajdź plik: `core.dll`
   - Znajdź folder: `mods\deathmatch\`

---

## Konfiguracja Bazy Danych

### Krok 1: Dostęp do phpMyAdmin

1. **Otwórz przeglądarkę**
   - Adres: `http://localhost/phpmyadmin`

2. **Zaloguj się**
   - **Użytkownik**: `root`
   - **Hasło**: (puste - nie wpisuj nic)
   - Kliknij "Zaloguj się" / "Go"

### Krok 2: Tworzenie Bazy Danych

1. **Kliknij "Nowa" (New)**
   - Znajduje się w lewym panelu

2. **Utwórz bazę danych**
   - Nazwa: `since`
   - Kodowanie: `utf8mb4_general_ci`
   - Kliknij "Utwórz" / "Create"

### Krok 3: Import Danych

1. **Wybierz bazę `since`**
   - Kliknij na nazwę w lewym panelu

2. **Przejdź do zakładki "Import"**

3. **Wybierz plik SQL**
   - Kliknij "Choose File" / "Wybierz plik"
   - Znajdź: `C:\cloudyMTA\db_109111.sql`
   - Wybierz plik

4. **Importuj**
   - Zostaw domyślne ustawienia
   - Przewiń na dół
   - Kliknij "Go" / "Wykonaj"

5. **Poczekaj na zakończenie**
   - Import może zająć 1-2 minuty
   - Komunikat sukcesu: "Import has been successfully finished"

6. **Weryfikacja**
   - Kliknij "Struktura" / "Structure"
   - Powinieneś zobaczyć listę tabel (około 100+)
   - Sprawdź czy istnieje tabela `since-accounts`

### Krok 4: Weryfikacja Konta Właściciela

1. **Przejdź do tabeli `since-accounts`**
   - Kliknij na nazwę tabeli w lewym panelu

2. **Kliknij "Przeglądaj" / "Browse"**

3. **Znajdź konto mlodyerik**
   - `uid = 100`
   - `login = mlodyerik`
   - `password = (hash)`
   - `serial = FD5E8BEDF6B5326A31C5880D403154A1`

4. **Sprawdź ACL**
   - Tabela: `since-acl`
   - Powinien być wpis dla `login = mlodyerik` z grupą `Admin` lub `SuperAdmin`

---

## Uruchomienie Serwera

### Krok 1: Kopiowanie Plików cloudyMTA

**Opcja A: Zastąpienie całego folderu `mods`**
```
Skopiuj: C:\cloudyMTA\server\mods\
Do: C:\Program Files\MTA San Andreas 1.6\server\mods\
(Zastąp wszystkie pliki)
```

**Opcja B: Kopiowanie tylko zasobów**
```
Skopiuj: C:\cloudyMTA\server\mods\deathmatch\resources\[SinceRPG]\
Do: C:\Program Files\MTA San Andreas 1.6\server\mods\deathmatch\resources\[SinceRPG]\

Skopiuj: C:\cloudyMTA\server\mods\deathmatch\mtaserver.conf
Do: C:\Program Files\MTA San Andreas 1.6\server\mods\deathmatch\mtaserver.conf
```

### Krok 2: Konfiguracja Połączenia z Bazą Danych

1. **Otwórz plik konfiguracyjny zasobu `since-db`**
   ```
   Lokalizacja: server\mods\deathmatch\resources\[SinceRPG]\since-db\server.lua
   ```

2. **Sprawdź ustawienia połączenia**
   ```lua
   -- Domyślne ustawienia dla XAMPP
   local host = "localhost"
   local port = 3306
   local username = "root"
   local password = ""
   local database = "since"
   ```

3. **Zapisz plik** (jeśli cokolwiek zmieniłeś)

### Krok 3: Uruchomienie Serwera MTA

1. **Otwórz folder serwera**
   ```
   C:\Program Files\MTA San Andreas 1.6\server\
   ```

2. **Uruchom `MTA Server.exe`**
   - Kliknij prawym → "Uruchom jako administrator"

3. **Poczekaj na uruchomienie**
   - Konsola MTA Server się otworzy
   - Poczekaj na komunikaty:
     ```
     [INFO] Resources: 100/100 loaded
     [INFO] Server started and is ready to accept connections!
     [INFO] Server is now on ASE port: 22126
     ```

4. **Sprawdź błędy**
   - Jeśli widzisz błędy czerwone, sprawdź [Rozwiązywanie Problemów](#rozwiązywanie-problemów)

### Krok 4: Sprawdzenie Logów

1. **Log serwera**
   ```
   Lokalizacja: server\mods\deathmatch\logs\server.log
   ```

2. **Log skryptów**
   ```
   Lokalizacja: server\mods\deathmatch\logs\scripts.log
   ```

3. **Log autoryzacji**
   ```
   Lokalizacja: server\mods\deathmatch\logs\server_auth.log
   ```

---

## Logowanie

### Krok 1: Połączenie z Serwerem

1. **Uruchom MTA:SA Client**

2. **Przejdź do "Browse Servers"**

3. **Dodaj serwer ręcznie**
   - Kliknij "Add server to favorites"
   - **IP**: `localhost` lub `127.0.0.1`
   - **Port**: `22003` (domyślny)
   - Kliknij "Add"

4. **Połącz się z serwerem**
   - Znajdź serwer na liście: `cloudyMTA - Nowoczesny serwer RPG`
   - Kliknij "Connect"

### Krok 2: Logowanie jako Właściciel

1. **Ekran logowania cloudyMTA**
   - Zobaczysz nowoczesny interfejs z logo cloudyMTA

2. **Wprowadź dane**
   - **Login**: `mlodyerik`
   - **Hasło**: `mlodyerik2025`

3. **Kliknij "Wejdź do gry"**

4. **Wybór spawnu**
   - Wybierz lokalizację (strzałki lub kursor)
   - Potwierdź (Enter)

### Krok 3: Weryfikacja Uprawnień

1. **Sprawdź panel administracyjny**
   - Naciśnij: **F1** (lub komendę `/panel`)

2. **Sprawdź dostępne komendy**
   - Wpisz: `/help`
   - Powinieneś zobaczyć komendy administracyjne

3. **Sprawdź ACL**
   - Wpisz: `/aclrequest list mlodyerik`
   - Powinieneś być w grupie Admin/SuperAdmin

---

## Rozwiązywanie Problemów

### Problem: Serwer nie startuje

**Objawy**:
- Konsola MTA Server zamyka się natychmiast
- Błąd: "Could not find core.dll"

**Rozwiązanie**:
1. Sprawdź czy `core.dll` istnieje w folderze `server\`
2. Uruchom jako Administrator
3. Sprawdź czy port 22003 nie jest zajęty

### Problem: Błąd połączenia z bazą danych

**Objawy**:
- Log: `[ERROR] Database connection failed`
- Nie można się zalogować

**Rozwiązanie**:
1. Sprawdź czy MySQL w XAMPP jest uruchomiony (zielony)
2. Sprawdź ustawienia w `since-db\server.lua`:
   ```lua
   host = "localhost"
   username = "root"
   password = ""  -- puste dla XAMPP
   database = "since"
   ```
3. Sprawdź czy baza `since` istnieje w phpMyAdmin
4. Zrestartuj serwer MTA

### Problem: Nie można się zalogować (błędne hasło)

**Objawy**:
- Komunikat: "Nieprawidłowe hasło"
- Konto istnieje w bazie

**Rozwiązanie**:
1. Sprawdź czy serial w grze pasuje do seriala w bazie:
   - W grze: F8 (konsola) → wpisz `serial`
   - W bazie: tabela `since-accounts` → kolumna `serial`
2. Jeśli serial się nie zgadza:
   - Zmień serial w bazie na aktualny z gry
   - Lub użyj przycisku "Stwórz konto" i zarejestruj nowe

### Problem: Brak uprawnień administracyjnych

**Objawy**:
- Nie działa `/panel` lub `/help`
- Brak dostępu do komend admina

**Rozwiązanie**:
1. Sprawdź plik `acl.xml`:
   ```
   Lokalizacja: server\mods\deathmatch\acl.xml
   ```
2. Znajdź sekcję `<group name="Admin">`
3. Dodaj swój login:
   ```xml
   <group name="Admin">
       <acl name="Moderator"></acl>
       <acl name="SuperModerator"></acl>
       <acl name="Admin"></acl>
       <object name="user.mlodyerik"></object>
   </group>
   ```
4. Zapisz plik
5. Zrestartuj serwer MTA
6. Lub użyj komendy w konsoli serwera: `aclrequest allow mlodyerik Admin`

### Problem: Zasoby nie ładują się

**Objawy**:
- Log: `[ERROR] Unable to start resource: since-xxx`
- Większość zasobów nie działa

**Rozwiązanie**:
1. Sprawdź czy `since-db` uruchomił się jako pierwszy:
   - Powinien być wpis w `mtaserver.conf`:
     ```xml
     <resource src="[SinceRPG]/since-db" startup="1" protected="1" />
     ```
2. Sprawdź logi w `logs\scripts.log`
3. Sprawdź czy wszystkie pliki zasobów są na miejscu
4. Zrestartuj serwer MTA

### Problem: Port 22003 zajęty

**Objawy**:
- Błąd: "Failed to bind server on port 22003"

**Rozwiązanie**:
1. Zmień port w `mtaserver.conf`:
   ```xml
   <serverport>22004</serverport>
   ```
2. Pamiętaj użyć nowego portu przy łączeniu z grą
3. Lub zamknij aplikację zajmującą port 22003

### Problem: Wolne ładowanie zasobów

**Objawy**:
- Serwer startuje bardzo długo (>5 minut)
- Zasoby ładują się po kolei

**Rozwiązanie**:
1. To normalne zachowanie przy pierwszym uruchomieniu
2. Poczekaj cierpliwie
3. Kolejne uruchomienia będą szybsze (cache)
4. Jeśli problem się powtarza:
   - Sprawdź dysk (SSD zalecany)
   - Zwiększ priorytet procesu MTA Server

---

## Porady i Wskazówki

### Bezpieczeństwo

1. **Zmień domyślne hasło**
   ```sql
   UPDATE `since-accounts` SET `password` = MD5('nowe_haslo') WHERE `login` = 'mlodyerik';
   ```

2. **Ustaw hasło na bazę MySQL**
   - W phpMyAdmin → Użytkownicy → Zmień hasło dla `root`
   - Zaktualizuj hasło w `since-db\server.lua`

3. **Konfiguracja firewall**
   - Otwórz porty: 22003 (UDP), 22005 (HTTP)
   - Lub używaj tylko lokalnie (localhost)

### Optymalizacja

1. **Wydajność serwera**
   - Zmień `bandwidth_reduction` w `mtaserver.conf`:
     ```xml
     <bandwidth_reduction>maximum</bandwidth_reduction>
     ```

2. **Limity graczy**
   - Zmień `maxplayers` w `mtaserver.conf`:
     ```xml
     <maxplayers>50</maxplayers>
     ```

3. **Backup bazy danych**
   - Regularnie eksportuj bazę `since` z phpMyAdmin
   - Zachowaj kopie zapasowe plików serwera

### Dalsze Kroki

1. **Dostosuj serwer**
   - Zmień nazwę serwera w `mtaserver.conf`
   - Dodaj opis i tagi

2. **Testuj systemy**
   - Przetestuj wszystkie mechaniki
   - Sprawdź systemy frakcyjne
   - Zweryfikuj ekonomię

3. **Zaproś graczy**
   - Skonfiguruj publiczny dostęp (jeśli chcesz)
   - Ustaw hasło serwera (opcjonalnie)

---

## FAQ (Najczęściej Zadawane Pytania)

**Q: Czy mogę używać cloudyMTA na serwerze dedykowanym?**  
A: Tak, cloudyMTA działa na Windows Server. Upewnij się, że masz zainstalowane wszystkie wymagane komponenty.

**Q: Czy muszę używać XAMPP?**  
A: Nie, możesz użyć dowolnego serwera MySQL/MariaDB. XAMPP jest tylko zalecany dla lokalnej instalacji.

**Q: Jak dodać nowych administratorów?**  
A: Zmodyfikuj plik `acl.xml` i dodaj użytkowników do grupy `Admin`, lub użyj komend ACL w konsoli serwera.

**Q: Czy mogę zmienić port serwera?**  
A: Tak, w pliku `mtaserver.conf` zmień wartość `<serverport>`.

**Q: Jak zaktualizować serwer MTA?**  
A: Pobierz nową wersję z multitheftauto.com i zastąp pliki (zachowaj folder `resources` i konfiguracje).

**Q: Gdzie znajdę więcej pomocy?**  
A: Sprawdź oficjalną dokumentację MTA:SA na wiki.multitheftauto.com lub społeczność na forum.multitheftauto.com.

---

## Dodatkowe Zasoby

- **MTA:SA Wiki**: https://wiki.multitheftauto.com/
- **MTA:SA Forum**: https://forum.multitheftauto.com/
- **cloudyMTA GitHub**: https://github.com/mlodyerik/cloudyMTA
- **Discord cloudyMTA**: https://discord.gg/cloudymta

---

## Kontakt i Wsparcie

Jeśli napotkasz problemy, które nie są opisane w tej instrukcji:

1. Sprawdź logi serwera (`logs/server.log`, `logs/scripts.log`)
2. Wyszukaj błąd na MTA:SA Wiki lub Forum
3. Skontaktuj się przez Discord cloudyMTA
4. Utwórz issue na GitHub

---

© 2026 cloudyMTA - Professional MTA:SA Roleplay Server

**Wersja dokumentu**: 1.0  
**Data ostatniej aktualizacji**: 2026-11-11
