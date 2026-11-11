# SCHEMAT BAZY DANYCH SINCERPG

## INFORMACJE OGÓLNE

- **Nazwa bazy:** `since`
- **Charset:** utf8mb4
- **Collation:** utf8mb4_general_ci
- **Silnik:** InnoDB
- **Liczba tabel:** 48
- **Wersja:** 1.0

---

## TABELE GŁÓWNE

### 1. since-users (GŁÓWNA TABELA GRACZY)

**Opis:** Przechowuje wszystkie dane użytkowników/postaci

| Kolumna | Typ | Klucz | Domyślna | Opis |
|---------|-----|-------|----------|------|
| uid | INT(11) | PRIMARY | AUTO_INC | Unikalny ID użytkownika |
| login | VARCHAR(100) | UNIQUE | - | Login do konta |
| nick | VARCHAR(50) | INDEX | - | Nick w grze |
| password | VARCHAR(32) | - | - | Hasło (MD5) |
| serial | VARCHAR(100) | UNIQUE | - | Serial MTA |
| ip | VARCHAR(45) | - | - | Adres IP |
| money | BIGINT(20) | - | 5000 | Gotówka |
| bankMoney | BIGINT(20) | - | 0 | Pieniądze w banku |
| skin | INT(11) | - | 0 | ID skina |
| registerDate | TIMESTAMP | - | NOW() | Data rejestracji |
| playedTime | INT(11) | - | 0 | Czas gry (minuty) |
| premium | TIMESTAMP | - | 0 | Data ważności premium |
| srp | INT(11) | - | 0 | Punkty SRP |
| premiumPoints | BIGINT(20) | - | 0 | Punkty premium |
| inventory | TEXT | - | [] | Ekwipunek (JSON) |
| licenses | TEXT | - | [] | Licencje (JSON) |
| lastPos | TEXT | - | 0,0,0,0,0 | Ostatnia pozycja |
| jobStats | TEXT | - | [] | Statystyki prac (JSON) |
| data | TEXT | - | [] | Dodatkowe dane (JSON) |
| fat | INT(11) | - | 0 | Tłuszcz (body) |
| miesnie | INT(11) | - | 0 | Mięśnie (body) |
| topHours | BIGINT(20) | - | 0 | Top godziny |
| wPLN | BIGINT(20) | - | 0 | Wirtualne PLN |
| + 30 more columns | ... | ... | ... | ... |

**Indeksy:**
- PRIMARY KEY (uid)
- UNIQUE KEY (login)
- UNIQUE KEY (serial)
- INDEX (nick)

---

### 2. since-admins (ADMINISTRATORZY)

**Opis:** Lista administratorów serwera

| Kolumna | Typ | Klucz | Domyślna | Opis |
|---------|-----|-------|----------|------|
| id | INT(11) | PRIMARY | AUTO_INC | ID admina |
| serial | TEXT | - | - | Serial |
| nick | VARCHAR(255) | - | - | Nick |
| level | TINYINT(1) | INDEX | - | Poziom (1-10) |
| actived | TIMESTAMP | - | 0 | Ostatnia aktywność |
| added | TIMESTAMP | - | NOW() | Data dodania |
| uid | BIGINT(20) | INDEX | - | ID użytkownika |
| reporty | BIGINT(20) | - | 0 | Liczba reportów |
| stats | TEXT | - | [] | Statystyki (JSON) |

**Poziomy administratora:**
- 1-2: Helper/Moderator
- 3-4: Support/Admin Jr
- 5-6: Admin
- 7-8: Head Admin
- 9: Super Admin
- 10: Owner

---

### 3. since-vehicles (POJAZDY PRYWATNE)

**Opis:** Pojazdy graczy

| Kolumna | Typ | Klucz | Domyślna | Opis |
|---------|-----|-------|----------|------|
| id | INT(11) | PRIMARY | AUTO_INC | ID pojazdu |
| owner | BIGINT(20) | INDEX | - | UID właściciela |
| model | INT(11) | - | - | ID modelu pojazdu |
| position | TEXT | - | 0,0,0 | Pozycja X,Y,Z |
| rotation | INT(11) | - | 0 | Rotacja |
| color | TEXT | - | [255,255,255,255,255,255] | Kolory (JSON) |
| upgrades | TEXT | - | [] | Tuning (JSON) |
| paintjob | INT(11) | - | 3 | Lakier (0-3) |
| plate | VARCHAR(20) | INDEX | - | Tablica rejestracyjna |
| hp | INT(11) | - | 1000 | HP pojazdu |
| fuel | INT(11) | - | 100 | Paliwo (%) |
| locked | INT(11) | - | 1 | Zamknięty (0/1) |
| variant | TEXT | - | [255,255] | Warianty |
| handling | INT(11) | - | 0 | ID handlingu |
| wheels | INT(11) | - | 0 | ID felg |
| neon | TEXT | - | [] | Neony (JSON) |
| interior | INT(11) | - | 0 | Interior |
| dimension | INT(11) | - | 0 | Dimension |
| mileage | BIGINT(20) | - | 0 | Przebieg (km) |

---

### 4. since-houses (DOMY)

**Opis:** Domy i nieruchomości graczy

| Kolumna | Typ | Klucz | Domyślna | Opis |
|---------|-----|-------|----------|------|
| id | INT(11) | PRIMARY | AUTO_INC | ID domu |
| owner | INT(11) | INDEX | - | UID właściciela |
| position | TEXT | - | - | Pozycja X,Y,Z |
| interior | INT(11) | - | - | ID interioru |
| items | TEXT | - | - | Przedmioty w domu |
| locked | INT(11) | - | 1 | Zamknięty (0/1) |
| price | INT(11) | - | - | Cena |
| members | TEXT | - | [] | Współlokatorzy (JSON) |
| houseType | INT(11) | - | 0 | Typ domu |
| chestItems | TEXT | - | [] | Skrzynia (JSON) |
| balance | BIGINT(20) | - | 0 | Saldo domu |

---

### 5. since-orgs (ORGANIZACJE)

**Opis:** Organizacje graczy (gangi, firmy)

| Kolumna | Typ | Klucz | Domyślna | Opis |
|---------|-----|-------|----------|------|
| uid | INT(11) | PRIMARY | AUTO_INC | ID organizacji |
| owner | BIGINT(20) | INDEX | - | UID właściciela |
| name | TEXT | - | - | Nazwa organizacji |
| tag | TEXT | - | - | Tag [TAG] |
| color | TEXT | - | - | Kolor RGB |
| members | TEXT | - | [] | Członkowie (JSON) |
| bank | BIGINT(20) | - | 0 | Saldo organizacji |
| level | INT(11) | - | 1 | Poziom (1-10) |
| exp | BIGINT(20) | - | 0 | Doświadczenie |
| spawn | TEXT | - | - | Spawn X,Y,Z |
| ranks | TEXT | - | [] | Rangi (JSON) |
| vehicles | TEXT | - | [] | Pojazdy (JSON) |
| parking | TEXT | - | - | Parking X,Y,Z |
| skin | INT(11) | - | 0 | Skin organizacji |

---

## TABELE SYSTEMOWE

### 6. since-factions (FRAKCJE)

Powiązania graczy z frakcjami (SAPD, SARA, etc.)

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID wpisu |
| uid | BIGINT(20) INDEX | UID gracza |
| faction | INT(11) INDEX | ID frakcji |
| rank | INT(11) | Ranga |
| duty | INT(11) | Na służbie (0/1) |

### 7. since-jobs (PRACE)

Aktywne prace graczy

| Kolumna | Typ | Opis |
|---------|-----|------|
| uid | BIGINT(20) PRIMARY | UID gracza |
| job | INT(11) INDEX | ID pracy |

### 8. since-items (PRZEDMIOTY)

Przedmioty w ekwipunku graczy

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID przedmiotu |
| owner | BIGINT(20) INDEX | UID właściciela |
| itemName | TEXT | Nazwa przedmiotu |
| data | TEXT | Dane (JSON) |
| slotType | INT(11) | Typ slotu |

---

## TABELE MODERACYJNE

### 9. since-ban (BANY)

System banów

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID bana |
| serial | TEXT | Serial zbanowanego |
| reason | TEXT | Powód |
| time | TIMESTAMP | Do kiedy |
| type | INT(11) INDEX | Typ (1=temporary, 2=permanent) |
| admin | TEXT | UID admina |
| admin_name | TEXT | Nick admina |
| admin_serial | TEXT | Serial admina |
| sid | INT(11) INDEX | UID zbanowanego |
| ipAdress | VARCHAR(255) | IP |

### 10. since-mandates (MANDATY)

Mandaty od policji

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID mandatu |
| uid | BIGINT(20) INDEX | UID ukaranego |
| reason | TEXT | Powód |
| price | BIGINT(20) | Kwota |
| officer | TEXT | Policjant |
| date | DATETIME | Data wystawienia |
| paid | INT(11) INDEX | Opłacony (0/1) |

### 11. since-jail (WIĘZIENIE)

Gracze w więzieniu

| Kolumna | Typ | Opis |
|---------|-----|------|
| uid | BIGINT(20) PRIMARY | UID więźnia |
| time | INT(11) | Czas (minuty) |
| admin | TEXT | Admin/Policjant |
| reason | TEXT | Powód |

### 12. since-punishments (KARY)

Historia kar

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID kary |
| uid | BIGINT(20) INDEX | UID ukaranego |
| type | VARCHAR(50) INDEX | Typ (kick/ban/warn/jail) |
| reason | TEXT | Powód |
| admin | TEXT | Admin |
| date | DATETIME | Data |
| time | INT(11) | Czas trwania |

---

## TABELE EKONOMICZNE

### 13. since-casino (KASYNO)

Żetony kasyna

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID |
| sid | INT(11) INDEX | UID gracza |
| zetony | BIGINT(11) | Liczba żetonów |

### 14. since-exchange (GIEŁDA)

Ogłoszenia giełdy

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID ogłoszenia |
| owner | BIGINT(20) INDEX | UID sprzedającego |
| itemName | TEXT | Nazwa przedmiotu |
| data | TEXT | Dane (JSON) |
| category | TEXT | Kategoria |
| price | BIGINT(20) | Cena |
| special | INT(11) | Specjalna (0/1) |

### 15. since-salony (SALONY SAMOCHODOWE)

Salony graczy

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID salonu |
| owner | BIGINT(20) INDEX | UID właściciela |
| name | TEXT | Nazwa |
| position | TEXT | Pozycja X,Y,Z |
| balance | BIGINT(20) | Saldo |
| vehicles | TEXT | Pojazdy (JSON) |
| members | TEXT | Pracownicy (JSON) |

### 16. since-prices (CENY)

Ceny przedmiotów na serwerze

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID |
| itemName | VARCHAR(100) UNIQUE | Nazwa przedmiotu |
| price | INT(11) | Cena |

---

## TABELE AKTYWNOŚCI

### 17. since-atms-logs (LOGI BANKOMATÓW)

Historia operacji bankowych

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID logu |
| uid | VARCHAR(255) INDEX | UID gracza |
| serial | VARCHAR(255) | Serial |
| ip | VARCHAR(255) | IP |
| icon | VARCHAR(255) | Ikona operacji |
| color | VARCHAR(255) | Kolor |
| text | VARCHAR(255) | Opis operacji |
| amount | BIGINT(20) | Kwota |
| date | DATETIME INDEX | Data |

### 18. since-orgs-logs (LOGI ORGANIZACJI)

Historia działań w organizacjach

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID logu |
| org | INT(11) INDEX | ID organizacji |
| text | TEXT | Treść logu |
| date | DATETIME | Data |

### 19. since-players-records (REKORDY GRACZY)

Rekordy graczy (drifty, wyścigi, etc.)

| Kolumna | Typ | Opis |
|---------|-----|------|
| uid | BIGINT(20) PRIMARY | UID gracza |
| data | TEXT | Dane (JSON) |

---

## TABELE DODATKOWE

### 20. since-vouchers (VOUCHERY)

Kody rabatowe/vouchery

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID |
| code | VARCHAR(50) UNIQUE | Kod |
| type | INT(11) | Typ nagrody |
| value | INT(11) | Wartość |
| used | INT(11) | Użyty (0/1) |
| usedBy | BIGINT(20) | Przez kogo |

### 21. since_promocodes (KODY PROMOCYJNE)

Kody promocyjne

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID |
| code | VARCHAR(50) UNIQUE | Kod |
| reward | TEXT | Nagroda (JSON) |
| uses | INT(11) | Użycia |
| maxUses | INT(11) | Max użyć |
| active | INT(11) | Aktywny (0/1) |

### 22. since-lottery (LOTERIA)

Zakłady loterii

| Kolumna | Typ | Opis |
|---------|-----|------|
| uid | BIGINT(20) INDEX | UID gracza |
| number | INT(11) | Liczba |

### 23. since-discord (DISCORD)

Integracja Discord

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID |
| serial | VARCHAR(255) INDEX | Serial MTA |
| discordID | VARCHAR(255) INDEX | Discord ID |
| notifications | INT(11) | Powiadomienia (0/1) |

---

## TABELE ZAAWANSOWANE

### 24. since-weed (MARIHUANA)

System uprawy

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID rośliny |
| owner | BIGINT(20) INDEX | UID właściciela |
| stage | INT(11) | Etap wzrostu |
| water | INT(11) | Woda |
| fertilizer | INT(11) | Nawóz |
| spotID | INT(11) | ID miejsca |

### 25. since-znajdzki (ZNAJDŹKI)

Ukryte przedmioty na mapie

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID |
| position | TEXT | Pozycja X,Y,Z |
| name | VARCHAR(100) | Nazwa |
| found | INT(11) | Znalezione (0/1) |

### 26. since-zones (STREFY)

Strefy terytorialne

| Kolumna | Typ | Opis |
|---------|-----|------|
| id | INT(11) PRIMARY | ID strefy |
| name | VARCHAR(100) | Nazwa |
| owner | BIGINT(20) INDEX | UID właściciela/org |
| position | TEXT | Pozycja X,Y,Z |
| size | TEXT | Rozmiar |

---

## POZOSTAŁE TABELE (22-48)

Lista pozostałych tabel:

27. since-14mili - System pracy/pojazdu 14mili
28. since-bronie - Broń graczy
29. since-carsRobbery - Kradzione pojazdy
30. since-clothes - Ubrania
31. since-cryto-records - Historia kryptowalut
32. since-dailySaver - Daily rewards
33. since-drift - Statystyki driftu
34. since-farm - Farma
35. since-gift - Prezenty
36. since-importExport - Import/Export
37. since-killstop - System killstop
38. since-listy - Poczta
39. since-mdt - Mobile Data Terminal
40. since-newyear - Event noworoczny
41. since-orgs-vehicles - Pojazdy organizacji
42. since-policeParking - Parking policyjny
43. since-stereo - Radio w aucie
44. since-weed-plants - Zebrane rośliny
45. since-weed-spots - Miejsca uprawy
46. since-zonesNew - Nowe strefy
47. since_active-payments - Aktywne płatności
48. payments - Płatności

---

## RELACJE MIĘDZY TABELAMI

### Główne relacje:

```
since-users (uid)
    ├─→ since-admins (uid)
    ├─→ since-vehicles (owner)
    ├─→ since-houses (owner)
    ├─→ since-orgs (owner)
    ├─→ since-factions (uid)
    ├─→ since-jobs (uid)
    ├─→ since-items (owner)
    ├─→ since-mandates (uid)
    ├─→ since-jail (uid)
    ├─→ since-ban (sid)
    └─→ [wszystkie inne tabele gracza]

since-orgs (uid)
    ├─→ since-orgs-vehicles (org)
    ├─→ since-orgs-logs (org)
    └─→ since-zones (owner)
```

---

## INDEKSY I OPTYMALIZACJA

### PRIMARY KEYS:
Każda tabela ma PRIMARY KEY (id lub uid)

### UNIQUE KEYS:
- since-users: login, serial
- since-vouchers: code
- since_promocodes: code
- since-prices: itemName

### INDEX KEYS (najważniejsze):
- since-users: nick
- since-admins: uid, level
- since-vehicles: owner, plate
- since-houses: owner
- since-orgs: owner
- since-factions: uid, faction
- since-jobs: job
- since-items: owner
- since-ban: sid, type
- since-mandates: uid, paid
- [i wiele innych...]

---

## TYPY DANYCH

### Używane typy:

- **INT(11)** - liczby całkowite (ID, flagi, liczniki)
- **BIGINT(20)** - duże liczby (pieniądze, uid, statystyki)
- **TINYINT(1)** - bool/flagi (0 lub 1)
- **VARCHAR(n)** - teksty o określonej długości
- **TEXT** - teksty bez limitu (JSON, opisy)
- **TIMESTAMP** - daty z czasem
- **DATETIME** - daty (bez automatycznej konwersji UTC)

### JSON w TEXT:

Wiele kolumn TEXT zawiera JSON:
- `[]` - pusta tablica
- `{}` - pusty obiekt
- Stringi JSON do serializacji danych

---

## BACKUP I MAINTENANCE

### Polecenia SQL:

**Backup całej bazy:**
```sql
mysqldump -u root -p since > backup_$(date +%Y%m%d).sql
```

**Przywracanie:**
```sql
mysql -u root -p since < backup_20261111.sql
```

**Optymalizacja tabel:**
```sql
OPTIMIZE TABLE `since-users`;
OPTIMIZE TABLE `since-vehicles`;
-- ... dla każdej tabeli
```

**Sprawdzanie rozmiaru:**
```sql
SELECT 
    table_name AS 'Tabela',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Rozmiar MB'
FROM information_schema.TABLES
WHERE table_schema = 'since'
ORDER BY (data_length + index_length) DESC;
```

---

## BEZPIECZEŃSTWO

### SQL Injection Protection:

Wszystkie zapytania w zasobie `since-db` używają prepared statements:

```lua
exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', uid)
```

### Hasła:

Przechowywane jako MD5 hash (32 znaki):
```lua
password = md5(plainPassword)
```

**UWAGA:** MD5 jest przestarzały. Zalecane:
- bcrypt
- argon2
- SHA256+ salt

### Seriale:

Unikalny identyfikator klienta MTA.
Używany jako dodatkowa weryfikacja.

---

## KONIEC DOKUMENTACJI

**Wersja:** 1.0  
**Data:** 11.11.2026  
**Autor:** System naprawy SinceRPG  
**Status:** Kompletny ✅
