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
