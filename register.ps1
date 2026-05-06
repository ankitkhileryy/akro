# Akro Language - Windows File Association Setup
# Run as Administrator: Right-click -> Run with PowerShell

param(
    [string]$AkroExePath = "$PSScriptRoot\src\akro.exe",
    [string]$IconPath    = "$PSScriptRoot\akro.ico"
)

Write-Host "Setting up Akro (.ak) file association..." -ForegroundColor Cyan

# Check admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "ERROR: Please run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click the script -> 'Run with PowerShell' as Admin" -ForegroundColor Yellow
    pause
    exit 1
}

# Check akro.exe exists
if (-not (Test-Path $AkroExePath)) {
    Write-Host "ERROR: akro.exe not found at: $AkroExePath" -ForegroundColor Red
    pause
    exit 1
}

$akroExe = (Resolve-Path $AkroExePath).Path
$iconFile = if (Test-Path $IconPath) { (Resolve-Path $IconPath).Path } else { "$akroExe,0" }

Write-Host "akro.exe: $akroExe"
Write-Host "Icon:     $iconFile"

# 1. Register .ak extension
New-Item -Path "HKCR:\.ak" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\.ak" -Name "(Default)" -Value "AkroFile"
Set-ItemProperty -Path "HKCR:\.ak" -Name "Content Type" -Value "text/x-akro"

# 2. Register AkroFile type
New-Item -Path "HKCR:\AkroFile" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile" -Name "(Default)" -Value "Akro Source File"

# 3. Set icon
New-Item -Path "HKCR:\AkroFile\DefaultIcon" -Force | Out-Null
if (Test-Path $IconPath) {
    Set-ItemProperty -Path "HKCR:\AkroFile\DefaultIcon" -Name "(Default)" -Value "`"$iconFile`""
} else {
    # Use akro.exe itself as icon source (embed icon first)
    Set-ItemProperty -Path "HKCR:\AkroFile\DefaultIcon" -Name "(Default)" -Value "`"$akroExe`",0"
}

# 4. Set open command (akro run file.ak)
New-Item -Path "HKCR:\AkroFile\shell\open\command" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\open\command" -Name "(Default)" -Value "`"$akroExe`" run `"%1`""

# 5. Add "Run with Akro" context menu
New-Item -Path "HKCR:\AkroFile\shell\run" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\run" -Name "(Default)" -Value "Run with Akro"
New-Item -Path "HKCR:\AkroFile\shell\run\command" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\run\command" -Name "(Default)" -Value "`"$akroExe`" run `"%1`""

# 6. Add "Transpile to JS" context menu
New-Item -Path "HKCR:\AkroFile\shell\transpile" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\transpile" -Name "(Default)" -Value "Transpile to JavaScript"
New-Item -Path "HKCR:\AkroFile\shell\transpile\command" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\AkroFile\shell\transpile\command" -Name "(Default)" -Value "`"$akroExe`" transpile `"%1`""

# 7. Refresh Windows Explorer icons
$code = @"
[System.Runtime.InteropServices.DllImport("Shell32.dll")]
public static extern void SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
"@
Add-Type -MemberDefinition $code -Name WinAPI -Namespace Shell
[Shell.WinAPI]::SHChangeNotify(0x08000000, 0x0000, [IntPtr]::Zero, [IntPtr]::Zero)

Write-Host ""
Write-Host "Done! .ak files are now associated with Akro." -ForegroundColor Green
Write-Host "Right-click any .ak file to see Akro options." -ForegroundColor Green
pause
