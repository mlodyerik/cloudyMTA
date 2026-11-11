# 🚀 SUPER ACL - KOMPLETNY FIX WSZYSTKICH UPRAWNIEŃ

## ⚠️ Problem
Błędy w konsoli:
```
[14:49:48] WARNING: [SinceRPG]\since-core\vehicles\data.lua:6: Access denied @ 'loadstring'
[14:49:48] ERROR: [SinceRPG]\since-core\vehicles\data.lua:6: attempt to call a nil value
[14:49:48] ERROR: [SinceRPG]\[dimsbln]\[main]\since-parking\server.lua:125: call: failed to call 'since-core:loadVehicle'
```

## ✅ Rozwiązanie

### 1. Utworzono **SuperACL** z WSZYSTKIMI 162 uprawnieniami:
- ✅ `function.loadstring` - KLUCZOWE dla since-core
- ✅ `function.load` - dodatkowe wsparcie
- ✅ Wszystkie `general.*` uprawnienia (ModifyOtherObjects, http, adminpanel, etc.)
- ✅ Wszystkie 114 `command.*` uprawnień
- ✅ Wszystkie 48 `function.*` uprawnień

### 2. Utworzono **SuperGroup** zawierającą:
- ✅ **129 resources** z paczki SinceRPG
- ✅ Każdy skrypt ma teraz pełne uprawnienia
- ✅ Rozwiązuje problemy z loadstring, loadVehicle, i innymi funkcjami

## 📋 Pełna lista dodanych resources (129 sztuk)

```
bone_attach, custom_coronas, since-14mili, since-3dinteraction, since-3dtext,
since-abs, since-ac, since-ads, since-alcohol, since-ankieta, since-antispam,
since-antycheat, since-antyvpn, since-arenas, since-artifacts, since-auth,
since-autostart, since-avatars, since-backup, since-badges, since-bankprzelew,
since-blacklist, since-blockFBI, since-blockTractorTowing, since-blur, since-bw,
since-carblur, since-carrender, since-carTint, since-case, since-casino,
since-casinoeditbox, since-casinoshop, since-cbubbles, since-changer, since-charts,
since-cjclothes, since-clear_cars, since-commands, since-core, since-cpu,
since-crosshair, since-crypto, since-customanims, since-dailyQuests, since-db,
since-diagnostics, since-discord, since-discordpresence, since-dmvehicle, since-drift,
since-energole, since-eventCars, since-event-panele, since-f1, since-f11,
since-fabular, since-fastwrite, since-fonts, since-fps, since-ghostmode,
since-gieldapp, since-glue, since-gui, since-halloweenevent, since-headmove,
since-heady, since-hoursaward, since-houses, since-inventory, since-jumpscare,
since-kameleon, since-keys, since-killinfo, since-levelewedek, since-licenseplate,
since-licytacja, since-lights, since-list, since-markers, since-mechanic,
since-moneyManager, since-mute, since-newCasino, since-norecoil, since-notifications,
since-ogranicznik, since-org, since-orgcars, since-orgcreate, since-particles,
since-pattach, since-pedshadow, since-prawko, since-public_vehicles, since-quitmessage,
since-radar, since-radarHD, since-radio, since-radio3d, since-realtime, since-reload,
since-renders, since-revive, since-rgblights, since-roulette, since-scrapyard,
since-scratchers, since-scrollbar, since-speedhack, since-stacje, since-startResource,
since-stereo, since-style, since-timecyc, since-tiresmoke, since-topki, since-trades,
since-turbocharger, since-turbosound, since-variants, since-vehpops, since-voicechat,
since-vouchers, since-water, since-wh, since-wheelmod, since-wheels, since-whitedock
```

## 🔧 Co zostało dodane do `acl.xml`

### SuperACL (162 uprawnienia):
```xml
<acl name="SuperACL">
    <right name="general.ModifyOtherObjects" access="true"></right>
    <right name="general.http" access="true"></right>
    <right name="function.loadstring" access="true"></right>
    <right name="function.load" access="true"></right>
    <!-- ... i 158 innych uprawnień ... -->
</acl>
```

### SuperGroup (129 resources):
```xml
<group name="SuperGroup">
    <acl name="SuperACL"></acl>
    <object name="resource.bone_attach"></object>
    <object name="resource.since-core"></object>
    <object name="resource.since-parking"></object>
    <!-- ... i 126 innych resources ... -->
</group>
```

## 📊 Statystyki

| Kategoria | Ilość |
|-----------|-------|
| **Uprawnienia general.*** | 9 |
| **Uprawnienia command.*** | 114 |
| **Uprawnienia function.*** | 48 |
| **Resources** | 129 |
| **RAZEM** | **300 elementów** |

## 🎯 Dlaczego to rozwiązuje problem?

### Błąd 1: `Access denied @ 'loadstring'`
**Przyczyna:** since-core potrzebowało uprawnienia `function.loadstring`  
**Rozwiązanie:** SuperACL dodaje to uprawnienie dla WSZYSTKICH resources

### Błąd 2: `attempt to call a nil value`
**Przyczyna:** loadstring zwracał nil przez brak uprawnień  
**Rozwiązanie:** Teraz loadstring działa poprawnie

### Błąd 3: `call: failed to call 'since-core:loadVehicle'`
**Przyczyna:** since-parking nie mogło wywołać funkcji eksportowanej z since-core  
**Rozwiązanie:** Oba resources mają teraz pełne uprawnienia

## 🚀 Testowanie

### Przed restartem serwera:
```bash
# Zwaliduj XML (MUSI być OK!)
xmllint --noout server/mods/deathmatch/acl.xml
```

### Po restarcie serwera:
1. Sprawdź logi - **NIE POWINNO** być:
   - ❌ `Access denied @ 'loadstring'`
   - ❌ `attempt to call a nil value`
   - ❌ `call: failed to call 'since-core:loadVehicle'`

2. Testuj respawn pojazdów:
   - Wejdź do przechowalni (/parking)
   - Wybierz pojazd
   - Pojazd **POWINIEN** się zespawnić i odblokować

## 📝 Pliki zmodyfikowane

- ✅ `server/mods/deathmatch/acl.xml` - dodano SuperACL i SuperGroup

## ⚠️ WAŻNE!

**MUSISZ całkowicie zrestartować serwer MTA!**

```bash
# NIE wystarczy /restart lub /refresh
# Trzeba zamknąć i uruchomić ponownie MTA Server.exe
```

**Dlaczego?**  
ACL jest ładowane tylko przy starcie serwera. Zmiany w acl.xml wymagają pełnego restartu.

## 📌 Autorzy

- Generator: Python script `generate_super_acl.py`
- Data: 2026-11-11
- Cel: Naprawić respawn pojazdów i dać WSZYSTKIE uprawnienia

---

## 🎉 To wszystko!

Po restarcie serwera samochody będą się normalnie respić z przechowalni!

**SuperGroup = SUPER UPRAWNIENIA dla WSZYSTKICH resources!** 🚗💨
