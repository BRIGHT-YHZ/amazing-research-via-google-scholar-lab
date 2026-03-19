@echo off
setlocal EnableExtensions
cd /d %~dp0

REM Usage:
REM   start_chrome_cdp.bat [port] [profile_dir] [url] [browser_exe]
REM Example:
REM   start_chrome_cdp.bat 9222 "%~dp0chrome_cdp_profile" "https://scholar.google.com/scholar_labs/search" "C:\Program Files\Google\Chrome\Application\chrome.exe"

set "PORT=%~1"
if "%PORT%"=="" set "PORT=9222"

set "PROFILE_DIR=%~2"
if "%PROFILE_DIR%"=="" set "PROFILE_DIR=%~dp0chrome_cdp_profile"

set "TARGET_URL=%~3"
if "%TARGET_URL%"=="" set "TARGET_URL=https://scholar.google.com/scholar_labs/search"

set "BROWSER_EXE=%~4"

if not "%BROWSER_EXE%"=="" (
  if not exist "%BROWSER_EXE%" (
    echo [ERROR] Custom browser executable not found:
    echo         %BROWSER_EXE%
    exit /b 1
  )
)

REM Prefer Chrome by default; fallback to Edge only when Chrome is unavailable.
if "%BROWSER_EXE%"=="" if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "BROWSER_EXE=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if "%BROWSER_EXE%"=="" if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "BROWSER_EXE=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if "%BROWSER_EXE%"=="" if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "BROWSER_EXE=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if "%BROWSER_EXE%"=="" if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "BROWSER_EXE=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if "%BROWSER_EXE%"=="" if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "BROWSER_EXE=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"

if "%BROWSER_EXE%"=="" (
  echo [ERROR] Browser executable not found.
  echo Please install Chrome/Edge, or pass browser_exe manually as the 4th argument.
  exit /b 1
)

if not exist "%PROFILE_DIR%" mkdir "%PROFILE_DIR%"

echo [INFO] Browser:     %BROWSER_EXE%
echo [INFO] Port:        %PORT%
echo [INFO] Profile dir: %PROFILE_DIR%
echo [INFO] Open URL:    %TARGET_URL%
echo.
echo [INFO] Launching browser with CDP...

start "" "%BROWSER_EXE%" --remote-debugging-port=%PORT% --user-data-dir="%PROFILE_DIR%" "%TARGET_URL%"

echo [OK] Browser started.
echo CDP endpoint: http://127.0.0.1:%PORT%

endlocal

