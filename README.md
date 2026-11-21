# PrusaSlicer-Profile (Voron 2.4 350)

Eigene PrusaSlicer-Profile (Druck, Filament, Drucker) für den Voron 2.4 350 mit Klipper.
Das Repo liegt auf jedem Rechner **direkt in `%APPDATA%\PrusaSlicer`**. Die `.gitignore`
lässt nur `print/`, `filament/`, `printer/`, `physical_printer/` und `tools/` zu, alles
andere (Cache, Vendor-Profile, Snapshots, `PrusaSlicer.ini` mit Fensterstatus) bleibt lokal.

## Nutzung

- PrusaSlicer über **`tools\PrusaSlicer-Sync.bat`** starten (Verknüpfung auf den Desktop legen):
  holt vorher die Profile, startet den Slicer und lädt nach dem Schließen Änderungen hoch.
- Profile nur bearbeiten, wenn PrusaSlicer **geschlossen** ist (sonst überschreibt er die Datei).
- Nicht auf zwei Rechnern gleichzeitig dasselbe Profil ändern.

## Profilstruktur (seit 19.11.2026)

Namensschema (kein `|` möglich, Windows erlaubt das Zeichen nicht in Dateinamen):

- **Drucker:** `V24 350 Revo 0.4`, `V24 350 Revo 0.6`, `MK2.5S (Reserve)`
- **Druck:** `V24 <Düse> - <Schichthöhe> <Zweck>`
  - 0.4: `0.10 Extrafein`, `0.12 Optik`, `0.16 Fein`, `0.20 Standard`, `0.20 Stabil`, `0.20 Voron-Teile`, `0.28 Schnell`
  - 0.6: `0.30 Standard`, `0.25 TPU`
  - Kalibrierung: `V24 0.4 - PA-Test` (siehe unten)
- **Filament:** `<Material> - <Hersteller/Produkt>`, z. B. `PLA - Sunlu PLA+ 2.0`
- MK2.5S-Profile beginnen mit `MK2.5S - ` und erscheinen nur beim MK2.5S.

Regeln:

- **Druckprofile sind materialneutral.** Temperatur, Lüfter, Rückzug, Pressure Advance und die
  maximale Volumengeschwindigkeit (MVS) stehen im **Filamentprofil**. `max_volumetric_speed`
  im Druckprofil ist 0, die Grenze kommt vom Filament (Revo bei 220 °C: max. ca. 16 mm³/s, Profile ≤ 13).
- Jedes Filament braucht ein MVS > 0.
- Sichtbarkeit über `printer_notes`: Die Voron-Druckerprofile enthalten `VORON24`, Druck- und
  Filamentprofile filtern darauf (Druck zusätzlich auf den Düsendurchmesser).
- Alle Druck-Varianten sind von `V24 0.4 - 0.20 Standard` abgeleitet. PrusaSlicer kann eigene
  Profile nicht voneinander erben lassen. Eine Änderung an der Basis muss deshalb in die Varianten
  übernommen werden (macht Claude per Skript).
- Beschleunigungen ≤ 4800 (Klipper `max_accel`).

## Neuen Rechner einrichten

Voraussetzung: [Git for Windows](https://git-scm.com/download/win), PrusaSlicer einmal gestartet.

```bat
cd /d %APPDATA%\PrusaSlicer
git init -b main
git remote add origin https://github.com/lixibert/PrusaSlicer_Profiles.git
git fetch origin
git checkout -f -B main --track origin/main
```

`checkout -f` überschreibt gleichnamige lokale Profile mit dem Stand aus dem Repo.
Vorher ggf. eine Sicherung des Ordners anlegen.

## Hinweise

- Zeilenenden bleiben CRLF (`.gitattributes`), so wie PrusaSlicer sie schreibt.
- `print_host` / `printhost_apikey` sind leer. **Keine API-Keys in die Profile eintragen**
  (Upload-Ziele gehören in `physical_printer/` – vor dem Commit prüfen).

## Pressure Advance kalibrieren

**Bevorzugt: Ellis-Muster** (https://ellis3dp.com/Pressure_Linear_Advance_Tool/) – schneller, Werte aufgedruckt, misst bei echter Beschleunigung.
Einstellungen: Firmware Klipper, Bett 350 x 350, Start-G-Code `PRINT_START EXTRUDER=[HOTEND_TEMP] BED=[BED_TEMP]`,
Haken bei "Don't Add G28" und "Don't Add Heating G-Codes", End-G-Code `PRINT_END`, Hotend-Temp = Drucktemperatur des Filaments,
Beschleunigung 1000 (Aussenwand), Rueckzug 0,75 mm / 35 mm/s (PETG 1 mm), PA 0,02-0,10 Schritt 0,005.
Dateiname nicht "PA-Test..." nennen (sonst startet zusaetzlich der Turm-Modus).

**Alternativ: Klipper-Turm**

1. Modell `tools/kalibrierung/PA-Turm_square_tower.stl` laden, Druckprofil **`V24 0.4 - PA-Test`**, gewünschtes Filament wählen.
2. Slicen und drucken. Der Dateiname beginnt mit `PA-Test_` – daran erkennt `PRINT_START` den Test und startet
   `TUNING_TOWER`: ADVANCE = 0 + Höhe (mm) × 0,002, Beschleunigung 500, Eckgeschwindigkeit 1.
   (Andere Spanne: vorher in Mainsail `PA_TEST START=0 FACTOR=0.002` mit eigenen Werten.)
3. Auswerten: Höhe (mm) messen, bei der die Ecken am saubersten sind (keine Wülste, keine Lücken) → PA = Höhe × 0,002.
4. Wert ins Filamentprofil, Filament-Start-G-Code: `SET_PRESSURE_ADVANCE ADVANCE=<Wert>`.

Der nächste normale Druck setzt Beschleunigung und Pressure Advance in `PRINT_START` automatisch zurück.
