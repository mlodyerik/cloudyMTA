# 🎮 Since RPG - Konto VIP OWNER dla mlodyerik

## 📋 Podsumowanie zmian

### 👤 Użytkownik: **mlodyerik** (UID: 8)

#### 💰 Finanse
- **Gotówka:** 999,999,999 $
- **Bank:** 999,999,999 $
- **wPLN:** 999,999
- **Punkty Premium:** 999,999

#### 🏆 Statystyki
- **SRP:** 99,999 punktów
- **Czas gry:** 99,999 godzin
- **Premium:** Aktywne do **31 grudnia 2099** 🎉
- **Status:** **VIP OWNER** 👑

#### 🚗 Prawa Jazdy (WSZYSTKIE)
- ✅ **Kategoria A** - Motocykle
- ✅ **Kategoria B** - Samochody osobowe
- ✅ **Kategoria C** - Ciężarówki
- ✅ **Licencja L** - Licencja lotnicza (samoloty i helikoptery)

---

## 🏎️ Garaż - 10 Premium Pojazdów

Wszystkie pojazdy należą do mlodyerik (owner ID: 8), pełny bak, maksymalny silnik.

| ID | Model | Nazwa | Tablice | Cena |
|----|-------|-------|---------|------|
| 17 | 411 | **Infernus** | MLY-001 | 2,500,000 $ |
| 18 | 415 | **Cheetah** | MLY-002 | 2,200,000 $ |
| 19 | 429 | **Banshee** | MLY-003 | 1,800,000 $ |
| 20 | 451 | **Turismo** | MLY-004 | 3,000,000 $ |
| 21 | 477 | **ZR-350** | MLY-005 | 1,400,000 $ |
| 22 | 560 | **Sultan** | MLY-006 | 1,200,000 $ |
| 23 | 562 | **⭐ Elegy (FULL TUNED)** | ELEGY-1 | 1,100,000 $ |
| 24 | 541 | **Bullet** | MLY-008 | 2,800,000 $ |
| 25 | 506 | **Super GT** | MLY-009 | 1,600,000 $ |
| 26 | 480 | **Comet** | MLY-010 | 900,000 $ |

**Łączna wartość garażu:** ~18,500,000 $ 💎

---

## ⭐ Elegy - FULL TUNING (ID: 23)

Twój Elegy (model 562) został w pełni zmodyfikowany:

### 🔧 Mechanika
- **Silnik:** 3.0L (maksymalny upgrade)
- **Nitro:** 3x boost
- **Hydraulika:** Pełna instalacja
- **Bak:** 100/100 (pełny)

### 🎨 Wygląd
- **Paintjob:** #3 (stylowy design)
- **Kolory:** Custom różowo-zielony (RGB: 0,0,0 / 255,0,255 / 255,0,255)
- **Światła:** Zielone (RGB: 0,255,0)
- **Szyby:** Przyciemnione (level 5)

### 🏁 Body Kit (Full)
- ✅ Wydech (exhaust: 1037)
- ✅ Spoiler (spoiler: 1147)
- ✅ Dach (roof: 1038)
- ✅ Progi boczne (side_skirts: 1036)
- ✅ Zderzak przedni (front_bumper: 1171)
- ✅ Zderzak tylny (rear_bumper: 1149)
- ✅ Felgi (wheels: 1025)

### 🛞 Custom Koła
- **vinylRim:** 10
- **wheelTilt:** 15°
- **wheelResize:** 1.2x (powiększone)
- **innerSize:** 1.0 (max)

### 📋 Tablice Rejestracyjne
**ELEGY-1** 🏁

---

## 📥 Jak zaimportować bazę danych?

### Metoda 1: phpMyAdmin (Zalecana)
1. Otwórz **phpMyAdmin** w przeglądarce
2. Wybierz bazę danych `since` (lub jak masz nazwana)
3. Kliknij zakładkę **Import**
4. Wybierz plik: `sincemoj_updated.sql`
5. Kliknij **Wykonaj** (Go)
6. ✅ Gotowe!

### Metoda 2: Wiersz poleceń MySQL
```bash
# Najpierw usuń starą bazę (UWAGA: backup!)
mysql -u root -p -e "DROP DATABASE IF EXISTS since; CREATE DATABASE since;"

# Zaimportuj nową bazę
mysql -u root -p since < sincemoj_updated.sql
```

### Metoda 3: Przez terminal MTA
```bash
# Z katalogu gdzie masz plik:
mysql -u twoj_user -p twoja_baza < sincemoj_updated.sql
```

---

## ⚠️ WAŻNE UWAGI

### Przed importem:
1. **ZRÓB BACKUP** aktualnej bazy danych!
   ```bash
   mysqldump -u root -p since > backup_$(date +%Y%m%d_%H%M%S).sql
   ```

2. **Sprawdź nazwę bazy** - skrypt zakłada bazę `since`
   - Jeśli masz inną nazwę, zmień pierwszą linię w pliku SQL

3. **Upewnij się**, że serwer MTA jest **WYŁĄCZONY** podczas importu

### Po imporcie:
1. Uruchom serwer MTA
2. Zaloguj się na konto **mlodyerik**
3. Sprawdź:
   - Pieniądze (gotówka i bank)
   - Prawa jazdy (F1 → Informacje lub komenda)
   - Pojazdy w garażu
   - Elegy z full tuningiem

---

## 🐛 Rozwiązywanie problemów

### Problem: "Access denied" przy imporcie
**Rozwiązanie:** Sprawdź hasło i uprawnienia użytkownika MySQL
```bash
mysql -u root -p
GRANT ALL PRIVILEGES ON since.* TO 'twoj_user'@'localhost';
FLUSH PRIVILEGES;
```

### Problem: Prawa jazdy się nie pokazują
**Rozwiązanie:** 
- Wyloguj się i zaloguj ponownie na konto
- Sprawdź czy w bazie jest poprawny JSON: `[ { "A": 1, "B": 1, "C": 1, "L": 1 } ]`

### Problem: Elegy nie ma tuningu
**Rozwiązanie:**
- Usuń pojazd z gry i respawnuj go (admin command)
- Lub zrestartuj zasób `since-vehicles` jeśli taki masz

### Problem: "Table already exists"
**Rozwiązanie:**
```sql
-- Usuń wszystkie tabele i zaimportuj od nowa
DROP DATABASE since;
CREATE DATABASE since;
USE since;
SOURCE sincemoj_updated.sql;
```

---

## 📊 Sprawdzanie w bazie danych

Możesz sprawdzić zmiany bezpośrednio w MySQL:

```sql
-- Sprawdź dane użytkownika
SELECT uid, nick, money, bankMoney, srp, premium, licenses 
FROM `since-users` 
WHERE nick = 'mlodyerik';

-- Sprawdź pojazdy
SELECT id, model, owner, tuning, licenseplate 
FROM `since-vehicles` 
WHERE owner = 8;

-- Sprawdź prawa admina
SELECT nick, level, actived 
FROM `since-admins` 
WHERE nick = 'mlodyerik';
```

---

## 🎯 Administracja

Konto **mlodyerik** ma również uprawnienia administratora:
- **Level:** 4 (najwyższy)
- **UID:** 8
- **Serial:** FD5E8BEDF6B5326A31C5880D403154A1

---

## 📝 Lista plików w repozytorium

- `sincemoj.sql` - Oryginalna baza danych (backup)
- `sincemoj_updated.sql` - ✅ **ZMODYFIKOWANA BAZA** (użyj tego!)
- `update_mlodyerik.py` - Skrypt Python użyty do modyfikacji
- `README_MLODYERIK.md` - Ten plik (instrukcje)

---

## 🚀 Szybki start

```bash
# 1. Sklonuj repozytorium (jeśli jeszcze nie masz)
git clone https://github.com/mlodyerik/since.git
cd since

# 2. Backup aktualnej bazy
mysqldump -u root -p since > backup_before_update.sql

# 3. Importuj nową bazę
mysql -u root -p since < sincemoj_updated.sql

# 4. Uruchom serwer MTA i graj! 🎮
```

---

## 📞 Kontakt

Jeśli masz jakieś problemy z importem lub konfiguracją, daj znać!

---

**Wygenerowano:** 11 listopada 2026  
**Wersja:** 1.0  
**Autor modyfikacji:** Kiro AI  

---

## 🎉 MIŁEJ GRY!

Twoje konto jest teraz **w pełni wymaksowane**:
- ✅ Nieograniczone środki finansowe
- ✅ Wszystkie prawa jazdy
- ✅ Premium do końca życia (2099)
- ✅ 10 najlepszych pojazdów
- ✅ Elegy z full tuningiem
- ✅ Status VIP OWNER
- ✅ Poziom admin 4

**Jesteś teraz właścicielem serwera! 👑**
