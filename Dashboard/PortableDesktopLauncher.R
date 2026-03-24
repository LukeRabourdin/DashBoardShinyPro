# Génère un lanceur desktop « pro » pour un bundle Shiny portable.
# Version compatible avec environnements d'entreprise limitant PowerShell.
# - Splash screen HTA (logo + animation 3 points)
# - Lancement R via VBS (console cachée)
# - Fermeture du splash après délai configurable

create_portable_desktop_launcher <- function(
    project_dir,
    r_exe_rel_win = "R-mini\\R\\bin\\R.exe",
    splash_logo = "app/Emojis/loupe.png",
    splash_title = "Dashboard",
    splash_message = "Ouverture des packages et chargement des données",
    splash_timeout_sec = 25
) {
  project_dir <- normalizePath(project_dir, mustWork = TRUE)

  splash_path <- file.path(project_dir, "splash.hta")
  vbs_path <- file.path(project_dir, "run_app.vbs")
  bat_path <- file.path(project_dir, "run_app_debug.bat")

  splash_html <- sprintf(
'<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>%s</title>
<HTA:APPLICATION
  ID="SplashDashboard"
  APPLICATIONNAME="%s"
  BORDER="none"
  BORDERSTYLE="normal"
  CAPTION="no"
  SHOWINTASKBAR="no"
  SINGLEINSTANCE="yes"
  WINDOWSTATE="normal"
  SCROLL="no"
/>
<style>
  html, body {
    margin: 0;
    width: 100%%;
    height: 100%%;
    background: rgba(11, 28, 48, 0.92);
    color: #F4F8FF;
    font-family: Segoe UI, Roboto, Arial, sans-serif;
    overflow: hidden;
  }
  .wrap {
    position: relative;
    width: 100%%;
    height: 100%%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: 18px;
  }
  .logo {
    width: 72px;
    height: 72px;
    border-radius: 16px;
    object-fit: contain;
    background: rgba(255,255,255,0.08);
    box-shadow: 0 10px 32px rgba(0,0,0,0.28);
    padding: 10px;
  }
  .title {
    font-weight: 700;
    font-size: 20px;
    letter-spacing: .02em;
  }
  .msg {
    font-size: 14px;
    opacity: 0.92;
  }
  .track {
    position: absolute;
    left: 6%%;
    right: 6%%;
    bottom: 14%%;
    height: 10px;
  }
  .dot {
    position: absolute;
    width: 10px;
    height: 10px;
    border-radius: 50%%;
    background: #57A7FF;
    box-shadow: 0 0 12px rgba(87,167,255,.9);
    animation: lr 2.2s linear infinite;
  }
  .dot.d2 { animation-delay: .25s; opacity:.8; }
  .dot.d3 { animation-delay: .5s; opacity:.6; }
  @keyframes lr {
    0%%   { left: 0%%; transform: translateX(0); }
    50%%  { left: 100%%; transform: translateX(-100%%); }
    100%% { left: 0%%; transform: translateX(0); }
  }
</style>
<script>
  function centerWindow(){
    try {
      var w = 680, h = 320;
      window.resizeTo(w, h);
      var x = Math.max(0, (screen.availWidth - w) / 2);
      var y = Math.max(0, (screen.availHeight - h) / 2);
      window.moveTo(x, y);
    } catch(e) {}
  }
  window.onload = centerWindow;
</script>
</head>
<body>
  <div class="wrap">
    <img class="logo" src="%s" alt="logo" />
    <div class="title">%s</div>
    <div class="msg">%s</div>
    <div class="track">
      <span class="dot d1"></span>
      <span class="dot d2"></span>
      <span class="dot d3"></span>
    </div>
  </div>
</body>
</html>',
    splash_title,
    splash_title,
    gsub('\\\\', '/', splash_logo),
    splash_title,
    splash_message
  )
  writeLines(splash_html, splash_path, useBytes = TRUE)

  vbs_script <- sprintf(
'Option Explicit
Dim shell, fso, appDir, cmd, splashPath, i, svc, procs, p
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
appDir = fso.GetParentFolderName(WScript.ScriptFullName)
shell.CurrentDirectory = appDir

'' Splash screen
splashPath = appDir & "\\splash.hta"
shell.Run "mshta.exe """ & splashPath & """", 0, False

'' Lancement R (logique historique conservée)
cmd = "cmd /c set ""R_PROFILE_USER="" && set ""R_ENVIRON_USER="" && set ""R_LIBS_USER="" && set ""R_LIBS_SITE="" && """ & appDir & "\\%s"" --vanilla -f launch.R"
shell.Run cmd, 0, False

'' Délai d''affichage du splash pendant le chargement
For i = 1 To %d
  WScript.Sleep 1000
Next

'' Fermeture du splash (mshta ciblé sur splash.hta)
On Error Resume Next
Set svc = GetObject("winmgmts:\\\\.\\root\\cimv2")
Set procs = svc.ExecQuery("SELECT * FROM Win32_Process WHERE Name = ''''mshta.exe''''")
For Each p In procs
  If InStr(1, p.CommandLine, "splash.hta", 1) > 0 Then
    p.Terminate
  End If
Next
On Error GoTo 0
',
    r_exe_rel_win,
    as.integer(splash_timeout_sec)
  )
  writeLines(vbs_script, vbs_path, useBytes = TRUE)

  bat_script <- sprintf(
'@echo off
cd /d "%%~dp0"
set "R_PROFILE_USER="
set "R_ENVIRON_USER="
set "R_LIBS_USER="
set "R_LIBS_SITE="
"%%~dp0%s" --vanilla -f launch.R
pause
',
    r_exe_rel_win
  )
  writeLines(bat_script, bat_path, useBytes = TRUE)

  message('✔ Lanceur desktop créé :')
  message('  - ', splash_path)
  message('  - ', vbs_path)
  message('  - ', bat_path)

  invisible(list(
    splash = splash_path,
    vbs = vbs_path,
    bat = bat_path
  ))
}
