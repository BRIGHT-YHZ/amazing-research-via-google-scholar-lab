@echo off
setlocal EnableExtensions
cd /d %~dp0

if not exist "%~dp0ScholarResearchAppSecure.exe" (
  echo [ERROR] EXE not found:
  echo         %~dp0ScholarResearchAppSecure.exe
  pause
  exit /b 1
)

for %%I in ("%~dp0ScholarResearchAppSecure.exe") do (
  echo [INFO] EXE path: %%~fI
  echo [INFO] EXE time: %%~tI
)

echo [INFO] Launching secure EXE...
"%~dp0ScholarResearchAppSecure.exe"
set "RC=%ERRORLEVEL%"

echo.
if "%RC%"=="0" (
  echo [OK] Secure EXE exited normally.
) else (
  echo [WARN] Secure EXE exited with code %RC%.
)

pause
exit /b %RC%
