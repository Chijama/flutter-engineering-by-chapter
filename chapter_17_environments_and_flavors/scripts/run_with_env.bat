@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
echo Usage: scripts\run_with_env.bat path\to\envfile
exit /b 1
)

set ENV_FILE=%~1
for %%I in ("%ENV_FILE%") do set EXT=%%~xI

set DEFINES=

if /I "%EXT%"==".env" (
for /f "usebackq tokens=1,2 delims==" %%A in ("%ENV_FILE%") do (
if not "%%A"=="" if not "%%A"=="#" (
set DEFINES=!DEFINES! --dart-define=%%A=%%B
)
)
) else if /I "%EXT%"==".json" (
echo JSON expansion not supported in this .bat example. Use .env or WSL with the .sh script.
exit /b 2
) else (
echo Unsupported extension %EXT%
exit /b 3
)

flutter run -t lib/dart_define_version/main.dart %DEFINES% %*
