# Akro Language Installer
# Run as Administrator

$ErrorActionPreference = "Stop"

$INSTALL_DIR = "C:\Program Files\Akro"
$EXE_SOURCE  = "$PSScriptRoot\src\akro.exe"
$ICON_SOURCE = "$PSScriptRoot\akro.ico"

Write-Host ""
Write-Host "  Installing Akro Programming Language..." -ForegroundColor Cyan
Write-Host ""

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click install.ps1 -> Run with PowerShell as Admin" -ForegroundColor Yellow
    pause; exit 1
}

# Check exe exists
if (-not (Test-Path $EXE_SOURCE)) {
    Write-Host "ERROR: akro.exe not found. Build first:" -ForegroundColor Red
    Write-Host "  cd akro\src" -ForegroundColor Yellow
    Write-Host "  go build -o akro.exe ." -ForegroundColor Yellow
    pause; exit 1
}

# 1. Create install directory
Write-Host "[1/5] Creating install directory..." -ForegroundColor White
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null

# 2. Copy files
Write-Host "[2/5] Copying files..." -ForegroundColor White
Copy-Item $EXE_SOURCE "$INSTALL_DIR\akro.exe" -Force
if (Test-Path $ICON_SOURCE) {
    Copy-Item $ICON_SOURCE "$INSTALL_DIR\akro.ico" -Force
}

# 3. Add to PATH
Write-Host "[3/5] Adding to PATH..." -ForegroundColor White
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($currentPath -notlike "*$INSTALL_DIR*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$INSTALL_DIR", "Machine")
    Write-Host "      Added to system PATH" -ForegroundColor Green
} else {
    Write-Host "      Already in PATH" -ForegroundColor Gray
}

# 4. Register .ak file association
Write-Host "[4/5] Registering .ak file type..." -ForegroundColor White
$akroExe  = "$INSTALL_DIR\akro.exe"
$iconPath = if (Test-Path "$INSTALL_DIR\akro.ico") { "$INSTALL_DIR\akro.ico" } else { "$akroExe,0" }

New-Item -Path "HKCR:\.ak"                              -Force | Out-Null
Set-ItemProperty -Path "HKCR:\.ak" -Name "(Default)"   -Value "AkroFile"

New-Item -Path "HKCR:\AkroFile"                         -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile" -Name "(Default)" -Value "Akro Source File"

New-Item -Path "HKCR:\AkroFile\DefaultIcon"             -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\DefaultIcon" -Name "(Default)" -Value "`"$iconPath`""

New-Item -Path "HKCR:\AkroFile\shell\open\command"      -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\open\command" -Name "(Default)" `
    -Value "`"$akroExe`" run `"%1`""

New-Item -Path "HKCR:\AkroFile\shell\run"               -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\run" -Name "(Default)" -Value "Run with Akro"
New-Item -Path "HKCR:\AkroFile\shell\run\command"       -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\run\command" -Name "(Default)" `
    -Value "`"$akroExe`" run `"%1`""

New-Item -Path "HKCR:\AkroFile\shell\transpile"         -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\transpile" -Name "(Default)" -Value "Transpile to JavaScript"
New-Item -Path "HKCR:\AkroFile\shell\transpile\command" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\transpile\command" -Name "(Default)" `
    -Value "`"$akroExe`" transpile `"%1`""

# 5. Refresh Explorer
Write-Host "[5/5] Refreshing Windows Explorer..." -ForegroundColor White
$code = @"
[System.Runtime.InteropServices.DllImport("Shell32.dll")]
public static extern void SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
"@
Add-Type -MemberDefinition $code -Name WinAPI -Namespace Shell -ErrorAction SilentlyContinue
[Shell.WinAPI]::SHChangeNotify(0x08000000, 0x0000, [IntPtr]::Zero, [IntPtr]::Zero)

Write-Host ""
Write-Host "  Akro installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "  Usage:" -ForegroundColor Cyan
Write-Host "    akro run main.ak       - Run a file" -ForegroundColor White
Write-Host "    akro repl              - Interactive mode" -ForegroundColor White
Write-Host "    akro transpile main.ak - Convert to JS" -ForegroundColor White
Write-Host "    akro version           - Show version" -ForegroundColor White
Write-Host ""
Write-Host "  Restart your terminal for PATH to take effect." -ForegroundColor Yellow
Write-Host ""
pause
