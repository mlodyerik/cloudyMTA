# cloudyMTA - Instrukcje Przygotowania Logo

## Grafika Źródłowa
Otrzymana grafika cloudyMTA pokazuje:
- **Symbol chmurki** w kolorze turkusowym (#2E756F / RGB 46, 117, 111)
- **Napis "cloudy"** w kolorze białym
- **Napis "MTA"** w kolorze turkusowym (#438F87)
- **Ciemne tło** (#101719)
- **Podkreślenie** w kolorze turkusowym z małym kropką/akcentem

## Wymagane Warianty Logo

### 1. Logo Główne (logo.png)
- **Rozmiar**: 374x98 px (obecny rozmiar w since-auth)
- **Zawartość**: Pełne logo z chmurką, napisem "cloudyMTA" i podkreśleniem
- **Tło**: Przezroczyste (PNG)
- **Format**: PNG-24 z alpha channel
- **Lokalizacja**: 
  - `/server/mods/deathmatch/resources/[SinceRPG]/since-auth/data/logo.png`
  - `/server/mods/deathmatch/resources/[SinceRPG]/[dimsbln]/[main]/since-dashboard/data/logo.png`
  - `/server/mods/deathmatch/resources/[SinceRPG]/[dimsbln]/[main]/since-interiors/data/logo.png`

### 2. Symbol Chmurki (cloud_icon.png)
- **Rozmiar**: 64x64 px, 128x128 px, 256x256 px
- **Zawartość**: Tylko symbol chmurki
- **Kolory**: Turkusowy #2E756F i #438F87 (gradient/cienie)
- **Tło**: Przezroczyste
- **Format**: PNG-24
- **Zastosowanie**: Ikony systemowe, małe elementy UI

### 3. Logo na Ciemnym Tle (logo_dark.png)
- **Rozmiar**: 512x512 px, 1024x1024 px
- **Zawartość**: Pełne logo
- **Tło**: Ciemne #101719 lub przezroczyste
- **Format**: PNG-24
- **Zastosowanie**: Discord Rich Presence, zewnętrzne aplikacje

### 4. Logo Małe (logo_small.png)
- **Rozmiar**: 200x52 px
- **Zawartość**: Uproszczona wersja logo (może bez podkreślenia)
- **Tło**: Przezroczyste
- **Format**: PNG-24
- **Zastosowanie**: Małe interfejsy, powiadomienia

### 5. Logo Ekran Logowania (logo_login.png)
- **Rozmiar**: 600x157 px (1.6x większe od głównego)
- **Zawartość**: Pełne logo z efektem glow
- **Tło**: Przezroczyste
- **Format**: PNG-24
- **Lokalizacja**: `/server/mods/deathmatch/resources/[SinceRPG]/since-auth/data/logo.png`

### 6. Favicon (favicon.ico)
- **Rozmiar**: 16x16, 32x32, 48x48, 64x64 (multi-size ICO)
- **Zawartość**: Symbol chmurki
- **Format**: ICO
- **Zastosowanie**: Strona WWW, webadmin

## Specyfikacja Kolorystyczna

### Kolor Główny (Chmurka, akcenty)
- **HEX**: #2E756F
- **RGB**: 46, 117, 111
- **HSL**: 174°, 44%, 32%

### Kolor Akcentowy (Jasny turkus)
- **HEX**: #438F87
- **RGB**: 67, 143, 135
- **HSL**: 174°, 36%, 41%

### Kolor Tekstu
- **Biały**: #F1F5F4 (RGB 241, 245, 244)
- **Szary**: #91A3A0 (RGB 145, 163, 160)

### Tło
- **Ciemne**: #101719 (RGB 16, 23, 25)
- **Panele**: #192426 (RGB 25, 36, 38)

## Efekty Graficzne

### Glow (Poświata)
- **Kolor**: #2E756F z alpha 30-50%
- **Blur**: 20-40px
- **Zastosowanie**: Ekran logowania, ważne elementy

### Cienie
- **Kolor**: #000000 z alpha 15-30%
- **Offset**: 2-4px w dół
- **Blur**: 6-12px

### Gradienty
Dla efektów 3D/głębi:
```
Gradient 1 (Chmurka):
- Start: #438F87 (góra)
- End: #2E756F (dół)

Gradient 2 (Tło):
- Start: #192426 (góra)
- End: #101719 (dół)
```

## Lokalizacje Do Aktualizacji

### Priorytet 1 (Krytyczne)
1. `/server/mods/deathmatch/resources/[SinceRPG]/since-auth/data/logo.png` ⭐
2. `/server/mods/deathmatch/resources/[SinceRPG]/[dimsbln]/[main]/since-dashboard/data/` ⭐
3. `/server/mods/deathmatch/resources/[SinceRPG]/[dimsbln]/[main]/since-interiors/data/logo.png`

### Priorytet 2 (Ważne)
4. Discord Rich Presence assets
5. Ikony powiadomień
6. Favicon dla webadmin

### Priorytet 3 (Opcjonalne)
7. Loading screens
8. Splash screens
9. Social media graphics

## Format Plików

### PNG (Główne logo i ikony)
- **Kompresja**: PNG-24 z alpha channel
- **Optymalizacja**: Tak (bez straty jakości)
- **Profil kolorów**: sRGB
- **DPI**: 72 (web standard)

### ICO (Favicon)
- **Rozmiary**: 16x16, 32x32, 48x48, 64x64
- **Format**: ICO multi-size
- **Głębia kolorów**: 32-bit (z alpha)

### SVG (Opcjonalnie, dla skalowalności)
- **Format**: SVG 1.1
- **Optymalizacja**: Tak (usunięcie metadanych)
- **Zastosowanie**: Duże rozmiary, print

## Narzędzia Polecane

### Konwersja i Edycja
- **Inkscape** (darmowy, SVG)
- **GIMP** (darmowy, PNG)
- **ImageMagick** (CLI, batch processing)

### Optymalizacja
```bash
# PNG optimization
pngquant --quality=90-100 input.png -o output.png
optipng -o7 output.png

# ICO creation
convert cloud_16.png cloud_32.png cloud_48.png cloud_64.png favicon.ico

# Batch resize
mogrify -resize 64x64 -path output/ *.png
```

## Checklist Jakości

- [ ] Logo czytelne w rozdzielczości 374x98px
- [ ] Symbol chmurki rozpoznawalny w 32x32px
- [ ] Kolory zgodne z paletą cloudyMTA (#2E756F, #438F87)
- [ ] Tło przezroczyste (gdzie wymagane)
- [ ] Pliki zoptymalizowane (rozmiar <100KB dla głównego logo)
- [ ] Brak artefaktów kompresji
- [ ] Zachowane proporcje i czytelność
- [ ] Testowane na ciemnym i jasnym tle

## Uwagi Techniczne

1. **Nie nadpisuj** oryginalnych plików bez backupu
2. **Zachowaj** nazwy plików zgodne z meta.xml
3. **Testuj** logo na różnych rozdzielczościach ekranu
4. **Sprawdź** czytelność na urządzeniach mobilnych (jeśli dotyczy)
5. **Dokumentuj** wszelkie zmiany w nazwach plików

---

## Status Grafik

### ✅ Gotowe
- Specyfikacja kolorystyczna
- Instrukcje przygotowania

### 🔄 W przygotowaniu
- Logo główne (374x98px)
- Symbol chmurki (64x64px, 128x128px)
- Logo ciemne tło (512x512px)
- Logo małe (200x52px)

### ⏳ Do wykonania
- Logo ekran logowania (600x157px)
- Favicon (multi-size ICO)
- Discord Rich Presence assets

---

**Ostatnia aktualizacja**: 2026-11-11
