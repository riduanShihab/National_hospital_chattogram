@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   National Hospital Chattogram - Project Cleaner
echo ===================================================
echo.

echo [1/7] Running flutter clean on main project...
call flutter clean
echo.

if exist "admin_panel\pubspec.yaml" (
    echo [2/7] Running flutter clean on admin panel...
    pushd admin_panel
    call flutter clean
    popd
    echo.
) else (
    echo [2/7] Admin panel not found, skipping...
)

echo [3/7] Removing build and cache directories...
for %%d in (
    "build"
    ".dart_tool"
    "admin_panel\build"
    "admin_panel\.dart_tool"
    ".idea"
    "admin_panel\.idea"
    "windows\flutter\ephemeral"
    "linux\flutter\ephemeral"
    "macos\Flutter\ephemeral"
    "ios\Flutter\ephemeral"
    "admin_panel\windows\flutter\ephemeral"
    "admin_panel\linux\flutter\ephemeral"
    "admin_panel\macos\Flutter\ephemeral"
    "admin_panel\ios\Flutter\ephemeral"
) do (
    if exist "%%~d" (
        echo   Removing directory: %%~d ...
        rd /s /q "%%~d" 2>nul
    )
)

echo.
echo [4/7] Removing IDE, cache, and lock files...
for %%f in (
    "*.iml"
    "admin_panel\*.iml"
    ".flutter-plugins"
    ".flutter-plugins-dependencies"
    "admin_panel\.flutter-plugins"
    "admin_panel\.flutter-plugins-dependencies"
    "*.log"
    "admin_panel\*.log"
) do (
    if exist "%%~f" (
        echo   Removing file: %%~f ...
        del /f /q "%%~f" 2>nul
    )
)

echo.
echo [5/7] Removing temporary OS files...
del /s /f /q /a:h Thumbs.db 2>nul
del /s /f /q .DS_Store 2>nul
del /s /f /q desktop.ini 2>nul

echo.
echo [6/7] Restoring dependencies (flutter pub get)...
echo   Getting dependencies for main project...
call flutter pub get
if exist "admin_panel\pubspec.yaml" (
    echo   Getting dependencies for admin panel...
    pushd admin_panel
    call flutter pub get
    popd
)

echo.
echo [7/7] Project cleanup finished successfully!
echo ===================================================
echo   All unwanted cache and temporary files removed.
echo   Dependencies restored - ready to code!
echo ===================================================
echo.
pause
