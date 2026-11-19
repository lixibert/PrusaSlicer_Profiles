@echo off
rem ------------------------------------------------------------------
rem  PrusaSlicer mit Profil-Sync starten
rem  1. Profile vom GitHub-Repo holen
rem  2. PrusaSlicer starten und warten, bis er geschlossen wird
rem  3. Geaenderte Profile committen und hochladen
rem ------------------------------------------------------------------
setlocal
set "REPO=%APPDATA%\PrusaSlicer"
set "SLICER=C:\Program Files\Prusa3D\PrusaSlicer\prusa-slicer.exe"

cd /d "%REPO%" || (echo Profilordner nicht gefunden & pause & exit /b 1)

echo [1/3] Hole aktuelle Profile ...
git pull --rebase --autostash
if errorlevel 1 (
  echo.
  echo  ACHTUNG: git pull fehlgeschlagen ^(offline oder Konflikt^).
  echo  PrusaSlicer startet trotzdem mit dem lokalen Stand.
  pause
)

echo [2/3] Starte PrusaSlicer ...
start "" /wait "%SLICER%"

echo [3/3] Speichere Aenderungen ...
git add -A print filament printer physical_printer
git diff --cached --quiet
if errorlevel 1 (
  git commit -m "Profile geaendert auf %COMPUTERNAME% (%DATE% %TIME:~0,5%)"
  git push
  if errorlevel 1 ( echo Push fehlgeschlagen - beim naechsten Start erneut. & pause )
) else (
  echo Keine Profilaenderungen.
)
endlocal
