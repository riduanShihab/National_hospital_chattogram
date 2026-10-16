# National Hospital Chattogram - Project Cleaner (PowerShell)
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "  National Hospital Chattogram - Project Cleaner" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/7] Running flutter clean on main project..." -ForegroundColor Yellow
flutter clean

if (Test-Path "admin_panel\pubspec.yaml") {
    Write-Host "`n[2/7] Running flutter clean on admin panel..." -ForegroundColor Yellow
    Push-Location admin_panel
    flutter clean
    Pop-Location
}

Write-Host "`n[3/7] Removing build and cache directories..." -ForegroundColor Yellow
$dirsToRemove = @(
    "build",
    ".dart_tool",
    "admin_panel\build",
    "admin_panel\.dart_tool",
    ".idea",
    "admin_panel\.idea",
    "windows\flutter\ephemeral",
    "linux\flutter\ephemeral",
    "macos\Flutter\ephemeral",
    "ios\Flutter\ephemeral",
    "admin_panel\windows\flutter\ephemeral",
    "admin_panel\linux\flutter\ephemeral",
    "admin_panel\macos\Flutter\ephemeral",
    "admin_panel\ios\Flutter\ephemeral"
)

foreach ($dir in $dirsToRemove) {
    if (Test-Path $dir) {
        Write-Host "  Removing: $dir" -ForegroundColor DarkGray
        Remove-Item -Recurse -Force $dir -ErrorAction SilentlyContinue
    }
}

Write-Host "`n[4/7] Removing IDE and dependency cache files..." -ForegroundColor Yellow
$patterns = @("*.iml", ".flutter-plugins", ".flutter-plugins-dependencies", "*.log")
foreach ($pat in $patterns) {
    Get-ChildItem -Path . -Filter $pat -File -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "  Removing: $($_.FullName)" -ForegroundColor DarkGray
        Remove-Item -Force $_.FullName -ErrorAction SilentlyContinue
    }
    if (Test-Path "admin_panel") {
        Get-ChildItem -Path "admin_panel" -Filter $pat -File -ErrorAction SilentlyContinue | ForEach-Object {
            Write-Host "  Removing: $($_.FullName)" -ForegroundColor DarkGray
            Remove-Item -Force $_.FullName -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "`n[5/7] Removing temporary OS files..." -ForegroundColor Yellow
Get-ChildItem -Path . -Include Thumbs.db, .DS_Store, desktop.ini -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

Write-Host "`n[6/7] Restoring dependencies (flutter pub get)..." -ForegroundColor Yellow
Write-Host "  Getting dependencies for main project..." -ForegroundColor DarkGray
flutter pub get
if (Test-Path "admin_panel\pubspec.yaml") {
    Write-Host "  Getting dependencies for admin panel..." -ForegroundColor DarkGray
    Push-Location admin_panel
    flutter pub get
    Pop-Location
}

Write-Host "`n[7/7] Project cleanup finished successfully!" -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
Write-Host "  All unwanted cache and temporary files removed." -ForegroundColor Green
Write-Host "  Dependencies restored - ready to code!" -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
