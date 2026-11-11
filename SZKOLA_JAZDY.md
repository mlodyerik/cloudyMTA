# 🏫 Since RPG - Szkoła Jazdy (Driving School)

## 📍 Lokalizacja

### Główna lokalizacja (Los Santos):
- **Współrzędne:** `1482.95, -1785.45, 18.73`
- **Rotacja:** `-0.00, 0.00, 167.59`
- **Miasto:** Los Santos
- **Dzielnica:** El Corona (przy drodze głównej)
- **Marker:** Czerwony cylinder (interaktywny)

### Dodatkowa lokalizacja (Las Venturas):
- **Współrzędne:** `2463.85, 2375.37, 12.16`
- **Miasto:** Las Venturas
- **Marker:** Czerwony cylinder (interaktywny)

### Pozycja po zdaniu egzaminu:
- **Teleportacja:** `1489.15, -1722.96, 13.43`
- Gracz zostaje przeniesiony w pobliże szkoły jazdy po pomyślnym egzaminie

---

## 🚗 Dostępne Prawa Jazdy

### 1. Kategoria A - Motocykle 🏍️
- **Pojazd egzaminacyjny:** Wayfarer (ID: 586)
- **Koszt egzaminu:** 5,000 $
- **Spawn point:** `1402.76, -1773.98, 13.05` (rotacja: 359.9, 0.0, 89.8)
- **Wymagania:** Musisz przejechać **2.50 km**
- **Ograniczenie prędkości:** 59 km/h (maksymalna prędkość podczas egzaminu)

### 2. Kategoria B - Samochody Osobowe 🚙
- **Pojazd egzaminacyjny:** Club (ID: 589)
- **Koszt egzaminu:** **DARMOWY** (0 $) ✅
- **Spawn point:** `1402.76, -1773.45, 13.21` (rotacja: 0.3, 360.0, 89.8)
- **Wymagania:** Musisz przejechać **2.50 km**
- **Ograniczenie prędkości:** 59 km/h (maksymalna prędkość podczas egzaminu)
- **NAJWAŻNIEJSZE:** To jest podstawowe prawo jazdy, dostępne za darmo!

### 3. Kategoria C - Ciężarówki 🚛
- **Pojazd egzaminacyjny:** Mule (ID: 414)
- **Koszt egzaminu:** 10,000 $
- **Spawn point:** `1403.71, -1773.02, 13.64` (rotacja: 0.0, 0.0, 89.8)
- **Wymagania:** Musisz przejechać **2.50 km**
- **Ograniczenie prędkości:** 59 km/h (maksymalna prędkość podczas egzaminu)
- **Zastosowanie:** Wymagane do niektórych prac (np. kierowca, mechanik)

### 4. Licencja L - Samoloty i Helikoptery ✈️
- **Status:** Obecnie niedostępna w szkole jazdy
- **Prawdopodobnie:** Osobny system licencji lotniczych
- **W bazie danych:** Można dodać przez admina lub manual

---

## 📋 Jak Działa Egzamin?

### Krok 1: Podejście do markera
1. Znajdź czerwony marker w szkole jazdy
2. Wejdź w marker (pieszo)
3. Otworzy się panel z trzema opcjami

### Krok 2: Wybór kategorii
1. Panel pokazuje 3 kategorie:
   - **Kategoria C** (po lewej) - 10,000 $
   - **Kategoria B** (środek) - DARMOWY
   - **Kategoria A** (po prawej) - 5,000 $
2. Kliknij na wybraną kategorię

### Krok 3: Egzamin praktyczny
1. Zostaniesz automatycznie wsadzony do pojazdu
2. Na górze ekranu pojawi się licznik: **"Zostało ci do przejechania: 2.50 km"**
3. Pojazd jest:
   - **Zablokowany** (nie można wysiadać)
   - **Ghost mode** (nie możesz nikogo uderzyć)
   - **Ograniczony** do 59 km/h
   - **Frozen** na starcie (odblokuje się automatycznie)

### Krok 4: Jazda
- Jedź normalnie po mieście
- Przejechaj **2.50 km**
- Licznik będzie się zmniejszał: 2.50 → 2.49 → ... → 0.00
- Nie musisz uważać na kolizje (ghost mode)
- Nie możesz jechać szybciej niż 59 km/h

### Krok 5: Zdanie egzaminu
- Gdy licznik osiągnie **0.00 km**:
  - Pojazd znika
  - Prawo jazdy zostaje automatycznie dodane do konta
  - Pojawia się notyfikacja: **"Pomyślnie zdano egzamin praktyczny"**
  - Zostaniesz przeniesiony na pozycję `1489.15, -1722.96, 13.43`

---

## ⚠️ Ważne Informacje

### Bezpieczeństwa:
- ✅ **Ghost mode aktywny** - nie możesz uderzyć innych pojazdów ani graczy
- ✅ **Nie można wysiadać** - zabezpieczenie przed cancelowaniem egzaminu
- ✅ **Nie można wejść/wyjść** - vehicle start enter/exit są blokowane
- ✅ **Auto-kasowanie** - jeśli disconnectujesz, pojazd zostanie usunięty

### Sprawdzenia przed egzaminem:
1. System sprawdza czy masz już to prawo jazdy
   - Jeśli TAK: "Posiadasz już prawo jazdy kat. X"
2. System sprawdza czy masz wystarczającą ilość pieniędzy
   - Jeśli NIE: "Nie posiadasz wystarczającej ilości pieniędzy"
3. Jeśli wszystko OK: Pieniądze są pobierane i egzamin się rozpoczyna

### Podczas egzaminu:
- **Nie można wysiadać** z pojazdu
- **Nie można wejść do innego pojazdu**
- **Odległość > 3m** od markera blokuje panel (jeśli jeszcze nie rozpocząłeś)
- **Disconnect** = Auto-usunięcie pojazdu egzaminacyjnego

---

## 🔧 Techniczne Szczegóły

### Zasób (Resource):
- **Nazwa:** `since-prawko`
- **Lokalizacja:** `/server/mods/deathmatch/resources/[SinceRPG]/since-prawko/`
- **Pliki:**
  - `client.lua` - Interfejs użytkownika, renderowanie
  - `server.lua` - Logika egzaminu, sprawdzanie warunków
  - `utils.lua` - Funkcje pomocnicze
  - `meta.xml` - Konfiguracja zasobu
  - `data/images/` - Grafiki (bg, a.png, b.png, c.png, itp.)

### Struktura plików:
```
since-prawko/
├── client.lua         # UI i rendering
├── server.lua         # Logika serwera
├── utils.lua          # Narzędzia
├── meta.xml           # Config
└── data/
    └── images/
        ├── bg.png           # Tło główne
        ├── bg2.png          # Tło kategorii
        ├── bg_mask.png      # Maska blur
        ├── a.png            # Ikona kat. A
        ├── b.png            # Ikona kat. B
        ├── c.png            # Ikona kat. C
        ├── close.png        # Przycisk zamknięcia
        └── bg_examin.png    # Tło licznika egzaminu
```

### Funkcje główne:

#### Server-side:
```lua
-- Rozpoczęcie egzaminu
addEvent('stryStartExam', true)
-- Parametry: cost (koszt), type (typ: a/b/c)
-- Sprawdza: pieniądze, posiadanie prawa jazdy
-- Tworzy: pojazd, ustawia dane, rozpoczyna egzamin

-- Zakończenie egzaminu
addEvent('sendLicense', true)
-- Niszczenie pojazdu, dodawanie licencji, teleportacja
```

#### Client-side:
```lua
-- Renderowanie górnego menu z licznikiem
function renderTopMenu()
-- Pokazuje: aktualny dystans do przejechania

-- Główny panel wyboru kategorii
function render()
-- Pokazuje: UI z trzema kategoriami (A, B, C)

-- Obsługa kliknięć
function click(btn, state)
-- Handleuje: kliknięcia w kategorie, zamknięcie panelu
```

### Element Data:
```lua
-- Na pojeździe egzaminacyjnym:
'vehicle:prawko' = sid gracza
'vehicle:prawkoKM' = 2.5 (km do przejechania)
'element:ghost' = true (ghost mode)

-- Na graczu:
'player:prawko' = 'a'/'b'/'c' (typ egzaminu)
```

---

## 🎮 Komendy i Eksporty

### Eksporty dostępne:

#### Z `since-core`:
```lua
-- Sprawdzenie czy gracz ma prawo jazdy
exports['since-core']:isPlayerHaveLicense(player, type)
-- type: 'a', 'b', 'c', 'l' (lowercase!)
-- Zwraca: true/false

-- Dodanie prawa jazdy
exports['since-core']:addPlayerLicense(player, type)
-- type: 'a', 'b', 'c', 'l'
-- Dodaje prawo jazdy do elementData i do bazy
```

### Plik: `since-core/players/licenses.lua`
```lua
function addPlayerLicense(player, license)
    local licenses = getElementData(player, 'player:licenses') or {}
    licenses[license] = true
    setElementData(player, 'player:licenses', licenses)
end

function isPlayerHaveLicense(player, license)
    local licenses = getElementData(player, 'player:licenses') or {}
    return licenses[license]
end
```

---

## 📊 Baza Danych

### Tabela: `since-users`
Pole: `licenses` (TEXT)

### Format JSON:
```json
[ { "A": 1, "B": 1, "C": 1, "L": 1 } ]
```

### Sprawdzenie w MySQL:
```sql
-- Sprawdź prawa jazdy gracza
SELECT nick, licenses 
FROM `since-users` 
WHERE nick = 'mlodyerik';

-- Dodaj prawo jazdy ręcznie (przykład):
UPDATE `since-users` 
SET licenses = '[ { "A": 1, "B": 1, "C": 1, "L": 1 } ]'
WHERE nick = 'mlodyerik';
```

---

## 🛠️ Dodawanie Prawa Jazdy Ręcznie (Admin)

### Metoda 1: Przez bazę danych
```sql
-- Dodaj wszystkie prawa jazdy
UPDATE `since-users` 
SET licenses = '[ { "A": 1, "B": 1, "C": 1, "L": 1 } ]'
WHERE uid = 8;
```

### Metoda 2: Przez kod Lua (w grze)
```lua
-- Jako admin, wykonaj w konsoli (F8):
local player = getPlayerFromName("mlodyerik")
exports['since-core']:addPlayerLicense(player, 'a')
exports['since-core']:addPlayerLicense(player, 'b')
exports['since-core']:addPlayerLicense(player, 'c')
exports['since-core']:addPlayerLicense(player, 'l')
```

### Metoda 3: Przez admin panel
W admin panelu może być opcja "Zarządzaj licencjami" - trzeba sprawdzić w `since-adminpanel`

---

## 🗺️ Jak Znaleźć Szkołę Jazdy w Grze?

### Na mapie (F11 lub radar):
- Szkoła jazdy jest oznaczona jako:
  - **Ikona:** `radar_school.png`
  - **Blip:** Czerwony marker szkoły
  - **Nazwa:** "Szkoła Jazdy" lub "Driving School"

### Ścieżki do ikon:
```
since-f11/images/radar/blips/radar_school.png
since-radarHD/client/img/radar/blips/radar_school.png
```

### GPS/Mapa:
1. Otwórz mapę (F11)
2. Znajdź czerwony marker szkoły w **El Corona, Los Santos**
3. Ustaw GPS (jeśli dostępne)
4. Jedź na miejsce

### Manualnie:
1. **Los Santos:** Jedź do El Corona (południowa część LS)
   - Koordynaty: `1482.95, -1785.45, 18.73`
   - W pobliżu Unity Station i przystanku kolejowego
2. **Las Venturas:** Jedź na północny wschód miasta
   - Koordynaty: `2463.85, 2375.37, 12.16`

---

## 💡 Porady i Wskazówki

### Dla początkujących:
1. **Zacznij od kategorii B** - jest darmowa!
2. **Jedź ostrożnie** - masz limit 59 km/h
3. **Nie musisz się martwić kolizjami** - ghost mode jest aktywny
4. **2.50 km to około 2-3 minuty jazdy** w normalnym tempie

### Optymalna trasa:
- Jedź główną drogą w Los Santos
- Unikaj wąskich uliczek (trudniej skręcać)
- Trzymaj się asfaltu (łatwiejsza nawigacja)
- Nie musisz wracać do szkoły - możesz jechać gdziekolwiek

### Co robić gdy:
- **"Posiadasz już prawo jazdy"** - Masz już tę kategorię, sprawdź w F11
- **"Nie posiadasz wystarczającej ilości pieniędzy"** - Zdobądź więcej $ (praca, bank)
- **Egzamin się przerwał** - Reconnect lub zgłoś adminowi
- **Pojazd zniknął** - Prawdopodobnie disconnect, spróbuj ponownie

---

## 🎯 Zastosowanie Praw Jazdy

### Kategoria A (Motocykle):
- Możliwość prowadzenia motocykli w grze
- Wymagane do niektórych zadań/misji
- Potrzebne do wynajmu/zakupu niektórych motorów

### Kategoria B (Samochody):
- **PODSTAWOWE** prawo jazdy
- Wymagane do większości prac: kierowca, mechanik, dostawca
- Niezbędne do wynajmu/zakupu samochodów
- **Zrób to jako pierwsze!**

### Kategoria C (Ciężarówki):
- Wymagane do pracy: kierowca ciężarówki, logistyk
- Potrzebne do misji transportowych
- Niektóre serwery wymagają do DHL/kuriera
- Koszt: 10,000 $ (tylko dla zaawansowanych graczy)

### Licencja L (Samoloty):
- Prowadzenie samolotów i helikopterów
- Praca: pilot, air taxi
- Wysoki poziom trudności
- Prawdopodobnie osobny system egzaminów

---

## 📝 Podsumowanie

### ✅ Szkoła Jazdy to:
- **2 lokalizacje:** Los Santos (główna) + Las Venturas
- **3 dostępne kategorie:** A, B, C
- **Prosty egzamin:** Przejechaj 2.50 km
- **Bezpieczny:** Ghost mode, limit prędkości
- **Szybki:** 2-3 minuty na egzamin

### 💰 Koszty:
- **Kategoria A:** 5,000 $
- **Kategoria B:** **DARMOWY** ✅
- **Kategoria C:** 10,000 $

### 🎮 Dla mlodyerik:
**Już masz wszystkie prawa jazdy!** 🎉
- ✅ Kategoria A
- ✅ Kategoria B
- ✅ Kategoria C
- ✅ Licencja L

Nie musisz robić egzaminów - wszystko jest już w bazie danych!

---

## 🔍 Debugging

### Sprawdzenie czy masz prawo jazdy:
```lua
-- W konsoli F8:
local licenses = getElementData(localPlayer, 'player:licenses')
outputChatBox(toJSON(licenses))
```

### Output powinien wyglądać:
```json
{"a":true,"b":true,"c":true,"l":true}
```

lub w bazie:
```json
[ { "A": 1, "B": 1, "C": 1, "L": 1 } ]
```

### Sprawdzenie czy resource działa:
```
/debugscript 3
```
Następnie wejdź w marker szkoły i sprawdź czy są errory

---

**Dokumentacja stworzona:** 11 listopada 2026  
**Wersja:** 1.0  
**Zasób:** since-prawko  
**Autor:** Kiro AI  

---

## 📌 Szybkie Linki

- **Główna lokalizacja:** Los Santos, El Corona: `1482.95, -1785.45, 18.73`
- **Pojazdy egzaminacyjne:** Wayfarer (586), Club (589), Mule (414)
- **Dystans egzaminu:** 2.50 km (dla wszystkich kategorii)
- **Najważniejsze:** Kategoria B jest **DARMOWA** - zrób ją jako pierwszą!

---

**Powodzenia na egzaminach! 🚗💨**
