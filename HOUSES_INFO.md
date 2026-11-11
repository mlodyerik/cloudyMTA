# System Domów cloudyMTA - Informacje

## Jak działają domy na serwerze

### Lokalizacja Domów
Domy są **dynamiczne** - nie ma hardcoded lokalizacji w kodzie.
Każdy dom jest tworzony przez administratora i zapisywany w bazie danych MySQL.

### Tabela Bazy Danych: `since-houses`

Struktura:
```sql
CREATE TABLE `since-houses` (
  `id` int(11) NOT NULL,
  `position` text NOT NULL,        -- Współrzędne X,Y,Z
  `date` date NOT NULL,             -- Data wygaśnięcia
  `owner` int(11) DEFAULT NULL,     -- UID właściciela
  `type` int(11) NOT NULL,          -- Typ domu (1-4)
  `cost` int(11) NOT NULL,          -- Koszt wynajmu
  `value` int(11) NOT NULL,         -- Wartość domu
  `locators` text NOT NULL,         -- Lokatorzy
  `garage` text DEFAULT NULL        -- Garaż (opcja)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Typy Domów

Z pliku `config.lua`:

**Typ 1 - Mały dom:**
- Rozmiar: Mały
- Lokatorzy: 3
- Koszt/dzień: 500$
- Wartość: 51,000$
- Interior: ID 6

**Typ 2 - Średni dom:**
- Rozmiar: Średni
- Lokatorzy: 4
- Koszt/dzień: 800$
- Wartość: 51,000$
- Interior: ID 4

**Typ 3 - Duży dom:**
- Rozmiar: Duży
- Lokatorzy: 5
- Koszt/dzień: 1,000$
- Wartość: 51,000$
- Interior: ID 5

**Typ 4 - Ogromny dom:**
- Rozmiar: Ogromny
- Lokatorzy: 6
- Koszt/dzień: 1,500$
- Wartość: 51,000$
- Interior: ID 5

### Jak Znaleźć Domy w Grze

**W grze:**
1. Wolne domy mają **zielony marker** (korona)
2. Zajęte domy mają **czerwony marker** (korona)
3. Pickup przy domu:
   - 🏠 Zielony = wolny dom (model 1575)
   - 🏠 Czerwony = zajęty dom (model 1576)

**Na radarze:**
- Wolne domy: `radar_propertyG.png` (G = Green)
- Zajęte domy: `radar_propertyR.png` (R = Red)

### Sprawdzenie Lokalizacji z Bazy Danych

Aby zobaczyć gdzie dokładnie są domy w Los Santos:

1. **Zaloguj się do MySQL:**
```bash
mysql -u root -p
use nazwa_bazy;
```

2. **Sprawdź wszystkie domy:**
```sql
SELECT id, position, owner, type, cost, date 
FROM `since-houses` 
ORDER BY id;
```

3. **Tylko wolne domy w LS (pozycje X między 0-3000, Y między -3000-0):**
```sql
SELECT id, position, type, cost 
FROM `since-houses` 
WHERE owner IS NULL 
AND position LIKE '1%' OR position LIKE '2%';
```

Kolumna `position` zawiera współrzędne w formacie: `X,Y,Z`

### Komendy Administratora

**Tworzenie nowego domu:**
```
/create.house [typ]
```
Gdzie typ:
- 1 = mały
- 2 = średni
- 3 = duży
- 4 = ogromny

Dom zostanie utworzony na pozycji gdzie stoi admin.

### Mechanika Wynajmu

- Domy wynajmuje się na dni
- Maksymalny okres przedpłaty: **14 dni**
- Po wygaśnięciu daty dom wraca do puli wolnych
- Automatyczne zerowanie o 00:00 (północ)

### Lokatorzy

- Każdy typ domu ma limit lokatorów
- Właściciel dodaje/usuwa lokatorów przez UID
- Lokatorzy mają dostęp do wnętrza domu

### Gdzie Szukać Domów w Los Santos

**Popularne lokacje (przykładowe):**
- Ganton (dzielnica Grove Street)
- Vinewood (wzgórza)
- Santa Maria Beach (plaża)
- Downtown Los Santos (centrum)
- Richman (bogate dzielnice)

**Jak znaleźć w grze:**
1. Jeździj po mieście
2. Szukaj zielonych markerów (korona)
3. Sprawdź radar - ikony domów
4. Podjedź do markera żeby zobaczyć panel kupna

### Panel Kupna/Zarządzania

Gdy wejdziesz w marker domu, otwiera się panel z informacjami:
- Typ domu
- Koszt wynajmu
- Właściciel (jeśli zajęty)
- Opcje: Kup, Przedłuż, Dodaj lokatora, Zwolnij

---

## Jak Dodać Nowe Domy (dla adminów)

1. Znajdź ładną lokację w LS
2. Stań w miejscu gdzie ma być wejście
3. `/create.house [1-4]` (typ domu)
4. Dom zostanie dodany do bazy
5. Pojawi się marker i pickup

**Polecane lokacje:**
- Przy ulicach mieszkalnych
- Osiedla
- Obok plaży
- W dobrze oświetlonych miejscach
- Z dostępem do drogi

---

## Jeśli nie ma domów na serwerze

Jeżeli w bazie danych nie ma żadnych domów (`since-houses` jest pusta),
to oznacza że trzeba je stworzyć od zera używając komendy `/create.house`.

Alternatywnie, można zaimportować gotowe domy z innego serwera lub
stworzyć skrypt SQL do batch-insert wielu domów naraz.

