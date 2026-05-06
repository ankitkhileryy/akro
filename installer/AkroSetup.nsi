; ============================================================
; Akro Programming Language - Professional Installer
; Created by ST
; ============================================================

Unicode True

!define APP_NAME        "Akro"
!define APP_VERSION     "0.1.0"
!define APP_PUBLISHER   "ankitkhileryy"
!define APP_URL         "https://github.com/ankitkhileryy/akro"
!define APP_EXE         "akro.exe"
!define INSTALL_DIR     "$PROGRAMFILES64\Akro"
!define REG_UNINST      "Software\Microsoft\Windows\CurrentVersion\Uninstall\Akro"
!define REG_APP         "Software\Akro"

; ── Installer output ────────────────────────────────────────
Name "${APP_NAME} ${APP_VERSION}"
OutFile "AkroSetup-${APP_VERSION}.exe"
InstallDir "${INSTALL_DIR}"
InstallDirRegKey HKLM "${REG_APP}" "InstallDir"
RequestExecutionLevel admin
SetCompressor /SOLID lzma
BrandingText "Akro Programming Language v${APP_VERSION} by ST"

; ── Modern UI ───────────────────────────────────────────────
!include "MUI2.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON          "..\akro.ico"
!define MUI_UNICON        "..\akro.ico"

; Welcome page text
!define MUI_WELCOMEPAGE_TITLE "Welcome to Akro ${APP_VERSION} Setup"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of Akro Programming Language v${APP_VERSION}.$\r$\n$\r$\nAkro is a fast, simple, and web-ready programming language created by ankitkhileryy.$\r$\n$\r$\nClick Next to continue."

; Finish page
!define MUI_FINISHPAGE_TITLE "Akro Installation Complete!"
!define MUI_FINISHPAGE_TEXT "Akro ${APP_VERSION} has been installed successfully.$\r$\n$\r$\nOpen a new terminal and type:$\r$\n  akro version$\r$\n$\r$\nVisit akro-lang.dev to get started."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Open Akro REPL"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchREPL"
!define MUI_FINISHPAGE_LINK "Visit akro-lang.dev"
!define MUI_FINISHPAGE_LINK_LOCATION "https://akro-lang.dev"

; ── Pages ───────────────────────────────────────────────────
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

; ── Components ──────────────────────────────────────────────
InstType "Full (Recommended)"
InstType "Minimal"

; ── Main Section ────────────────────────────────────────────
Section "Akro Core (required)" SecCore
    SectionIn RO  ; Cannot be deselected
    SectionIn 1 2

    SetOutPath "$INSTDIR"

    ; Copy main executable
    File "..\src\akro.exe"

    ; Copy icon
    File /nonfatal "..\akro.ico"

    ; Copy license
    File "..\LICENSE"
    File "..\NOTICE"

    ; Write registry
    WriteRegStr HKLM "${REG_APP}" "InstallDir" "$INSTDIR"
    WriteRegStr HKLM "${REG_APP}" "Version"    "${APP_VERSION}"
    WriteRegStr HKLM "${REG_APP}" "Publisher"  "ankitkhileryy"

    ; Uninstaller info (shows in Add/Remove Programs)
    WriteRegStr   HKLM "${REG_UNINST}" "DisplayName"          "${APP_NAME} Programming Language"
    WriteRegStr   HKLM "${REG_UNINST}" "DisplayVersion"       "${APP_VERSION}"
    WriteRegStr   HKLM "${REG_UNINST}" "Publisher"            "ankitkhileryy"
    WriteRegStr   HKLM "${REG_UNINST}" "URLInfoAbout"         "https://github.com/ankitkhileryy/akro"
    WriteRegStr   HKLM "${REG_UNINST}" "InstallLocation"      "$INSTDIR"
    WriteRegStr   HKLM "${REG_UNINST}" "DisplayIcon"          "$INSTDIR\akro.ico"
    WriteRegStr   HKLM "${REG_UNINST}" "UninstallString"      "$INSTDIR\uninstall.exe"
    WriteRegStr   HKLM "${REG_UNINST}" "QuietUninstallString" "$INSTDIR\uninstall.exe /S"
    WriteRegDWORD HKLM "${REG_UNINST}" "NoModify"             1
    WriteRegDWORD HKLM "${REG_UNINST}" "NoRepair"             1
    WriteRegStr   HKLM "${REG_UNINST}" "HelpLink"             "https://github.com/ankitkhileryy/akro"

    ; Write uninstaller
    WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

; ── PATH Section ────────────────────────────────────────────
Section "Add to PATH (recommended)" SecPath
    SectionIn 1 2

    ; Read current PATH
    ReadRegStr $0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
    
    ; Check if already in PATH
    StrLen $1 "$INSTDIR"
    Push "$0"
    Push "$INSTDIR"
    Call StrContains
    Pop $2
    StrCmp $2 "" 0 AlreadyInPath
    
    ; Add to PATH
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$0;$INSTDIR"
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
    AlreadyInPath:

SectionEnd

; ── File Association Section ─────────────────────────────────
Section "Register .ak files" SecFileAssoc
    SectionIn 1

    ; Register .ak extension
    WriteRegStr HKCR ".ak"                                  "" "AkroFile"
    WriteRegStr HKCR ".ak"                                  "Content Type" "text/x-akro"
    WriteRegStr HKCR ".ak"                                  "PerceivedType" "text"

    ; Register AkroFile type
    WriteRegStr HKCR "AkroFile"                             "" "Akro Source File"
    WriteRegStr HKCR "AkroFile\DefaultIcon"                 "" "$INSTDIR\akro.ico"

    ; Open command
    WriteRegStr HKCR "AkroFile\shell"                       "" "open"
    WriteRegStr HKCR "AkroFile\shell\open"                  "" "Run with Akro"
    WriteRegStr HKCR "AkroFile\shell\open\command"          "" '"$INSTDIR\akro.exe" run "%1"'

    ; Context menu - Run
    WriteRegStr HKCR "AkroFile\shell\run"                   "" "Run with Akro"
    WriteRegStr HKCR "AkroFile\shell\run"                   "Icon" "$INSTDIR\akro.ico"
    WriteRegStr HKCR "AkroFile\shell\run\command"           "" '"$INSTDIR\akro.exe" run "%1"'

    ; Context menu - Transpile to JS
    WriteRegStr HKCR "AkroFile\shell\transpile"             "" "Transpile to JavaScript"
    WriteRegStr HKCR "AkroFile\shell\transpile\command"     "" '"$INSTDIR\akro.exe" transpile "%1"'

    ; Context menu - Check
    WriteRegStr HKCR "AkroFile\shell\check"                 "" "Check for Errors"
    WriteRegStr HKCR "AkroFile\shell\check\command"         "" '"$INSTDIR\akro.exe" check "%1"'

    ; Refresh shell icons
    System::Call 'Shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'

SectionEnd

; ── Examples Section ─────────────────────────────────────────
Section "Install Examples" SecExamples
    SectionIn 1

    SetOutPath "$INSTDIR\examples"
    File /nonfatal "..\examples\*.ak"

    ; Create shortcut to examples folder
    CreateShortcut "$INSTDIR\Examples.lnk" "$INSTDIR\examples"

SectionEnd

; ── Start Menu Section ───────────────────────────────────────
Section "Start Menu Shortcuts" SecStartMenu
    SectionIn 1

    CreateDirectory "$SMPROGRAMS\Akro"

    ; REPL shortcut
    CreateShortcut "$SMPROGRAMS\Akro\Akro REPL.lnk" \
        "$INSTDIR\akro.exe" "repl" \
        "$INSTDIR\akro.ico" 0 \
        SW_SHOWNORMAL "" "Akro Interactive Shell"

    ; Uninstall shortcut
    CreateShortcut "$SMPROGRAMS\Akro\Uninstall Akro.lnk" \
        "$INSTDIR\uninstall.exe" "" \
        "$INSTDIR\akro.ico" 0

    ; Website shortcut
    WriteINIStr "$SMPROGRAMS\Akro\Akro Website.url" "InternetShortcut" "URL" "${APP_URL}"

SectionEnd

; ── Section Descriptions ─────────────────────────────────────
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCore}      "Akro interpreter and core tools. Required."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPath}      "Add Akro to system PATH so you can run 'akro' from any terminal."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecFileAssoc} "Associate .ak files with Akro. Adds right-click menu options."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecExamples}  "Install example .ak programs to get started quickly."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} "Create Start Menu shortcuts for Akro REPL and website."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; ── Finish page - Launch REPL ────────────────────────────────
Function LaunchREPL
    Exec '"$WINDIR\system32\cmd.exe" /K "$INSTDIR\akro.exe" repl'
FunctionEnd

; ── Uninstaller ──────────────────────────────────────────────
Section "Uninstall"

    ; Remove from PATH
    ReadRegStr $0 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
    ; Simple removal - user may need to manually clean PATH
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

    ; Remove files
    Delete "$INSTDIR\akro.exe"
    Delete "$INSTDIR\akro.ico"
    Delete "$INSTDIR\LICENSE"
    Delete "$INSTDIR\NOTICE"
    Delete "$INSTDIR\uninstall.exe"
    Delete "$INSTDIR\Examples.lnk"

    ; Remove examples
    Delete "$INSTDIR\examples\*.ak"
    RMDir  "$INSTDIR\examples"
    RMDir  "$INSTDIR"

    ; Remove Start Menu
    Delete "$SMPROGRAMS\Akro\Akro REPL.lnk"
    Delete "$SMPROGRAMS\Akro\Uninstall Akro.lnk"
    Delete "$SMPROGRAMS\Akro\Akro Website.url"
    RMDir  "$SMPROGRAMS\Akro"

    ; Remove file associations
    DeleteRegKey HKCR ".ak"
    DeleteRegKey HKCR "AkroFile"

    ; Remove registry
    DeleteRegKey HKLM "${REG_APP}"
    DeleteRegKey HKLM "${REG_UNINST}"

    ; Refresh shell
    System::Call 'Shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'

    MessageBox MB_OK "Akro has been uninstalled.$\r$\nThank you for using Akro!"

SectionEnd

; ── Helper: StrContains ──────────────────────────────────────
Function StrContains
  Exch $R0 ; string to find
  Exch
  Exch $R1 ; string to search in
  Push $R2
  Push $R3
  Push $R4
  StrLen $R2 $R0
  StrLen $R3 $R1
  IntOp $R3 $R3 - $R2
  StrCpy $R4 ""
  loop:
    IntCmp $R3 0 done done
    StrCpy $R4 $R1 $R2
    StrCmp $R4 $R0 found
    StrCpy $R1 $R1 "" 1
    IntOp $R3 $R3 - 1
    Goto loop
  found:
    StrCpy $R4 $R0
    Goto end
  done:
    StrCpy $R4 ""
  end:
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R4
  Exch
  Pop $R0
FunctionEnd
