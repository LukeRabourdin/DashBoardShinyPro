# Génère un lanceur desktop « pro » pour un bundle Shiny portable.
# - Splash screen (logo + animation 3 points)
# - Lancement R sans console visible
# - Attente active du serveur puis ouverture du navigateur
# - Logs stdout/stderr

create_portable_desktop_launcher <- function(
    project_dir,
    shiny_url = NULL,
    splash_logo = "app/Emojis/loupe.png",
    splash_title = "Dashboard",
    splash_message = "Ouverture des packages et chargement des données"
) {
  project_dir <- normalizePath(project_dir, mustWork = TRUE)
  if (is.null(shiny_url) || !nzchar(shiny_url)) shiny_url <- "__AUTO__"

  logs_dir <- file.path(project_dir, "logs")
  dir.create(logs_dir, recursive = TRUE, showWarnings = FALSE)

  splash_path <- file.path(project_dir, "splash.hta")
  ps1_path <- file.path(project_dir, "wait_and_open.ps1")
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

  ps1_script <- sprintf(
    paste(
      "$ErrorActionPreference = 'Stop'",
      "",
      "try {",
      "  $BaseDir   = Split-Path -Parent $MyInvocation.MyCommand.Path",
      "  $LogsDir   = Join-Path $BaseDir 'logs'",
      "  $SplashHta = Join-Path $BaseDir 'splash.hta'",
      "  $LaunchR   = Join-Path $BaseDir 'launch.R'",
      "  $RequestedUrl = '%s'",
      "",
      "  function Get-FreePort {",
      "    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 0)",
      "    $listener.Start()",
      "    $port = $listener.LocalEndpoint.Port",
      "    $listener.Stop()",
      "    return $port",
      "  }",
      "",
      "  $Port = $null",
      "  if ($RequestedUrl -eq '__AUTO__') {",
      "    $Port = Get-FreePort",
      "    $ShinyUrl = 'http://127.0.0.1:' + $Port",
      "  } else {",
      "    $ShinyUrl = $RequestedUrl",
      "    try {",
      "      $uri = [System.Uri]$ShinyUrl",
      "      if ($uri.Port -gt 0) { $Port = $uri.Port }",
      "    } catch {}",
      "  }",
      "  if ($Port) { $env:SHINY_PORT = [string]$Port }",
      "",
      "  if (!(Test-Path $LogsDir)) {",
      "    New-Item -ItemType Directory -Path $LogsDir | Out-Null",
      "  }",
      "",
      "  $TimeTag = Get-Date -Format 'yyyyMMdd_HHmmss'",
      "  $StdOut  = Join-Path $LogsDir ('startup_' + $TimeTag + '.log')",
      "  $StdErr  = Join-Path $LogsDir ('startup_' + $TimeTag + '_error.log')",
      "",
      "  $RExe = Join-Path $BaseDir 'R-mini\\\\R\\\\bin\\\\R.exe'",
      "  if (!(Test-Path $RExe)) {",
      "    $RExe = Join-Path $BaseDir 'R-mini\\\\R\\\\bin\\\\x64\\\\R.exe'",
      "  }",
      "  if (!(Test-Path $RExe)) {",
      "    throw 'R.exe introuvable dans R-mini.'",
      "  }",
      "  if (!(Test-Path $LaunchR)) {",
      "    throw 'launch.R introuvable.'",
      "  }",
      "",
      "  $SplashProc = Start-Process -FilePath 'mshta.exe' -ArgumentList ('\"' + $SplashHta + '\"') -PassThru",
      "",
      "  $RProc = Start-Process `",
      "    -FilePath $RExe `",
      "    -ArgumentList ('--vanilla -f \"' + $LaunchR + '\"') `",
      "    -WorkingDirectory $BaseDir `",
      "    -WindowStyle Hidden `",
      "    -RedirectStandardOutput $StdOut `",
      "    -RedirectStandardError $StdErr `",
      "    -PassThru",
      "",
      "  $Ready = $false",
      "  $Deadline = (Get-Date).AddSeconds(120)",
      "  while ((Get-Date) -lt $Deadline -and -not $Ready) {",
      "    Start-Sleep -Milliseconds 500",
      "",
      "    if ($RProc.HasExited) {",
      "      throw 'Le process R s''est arrêté pendant le démarrage.'",
      "    }",
      "",
      "    try {",
      "      $resp = Invoke-WebRequest -Uri $ShinyUrl -UseBasicParsing -TimeoutSec 2",
      "      if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 500) {",
      "        $Ready = $true",
      "      }",
      "    } catch {",
      "      # continue polling",
      "    }",
      "  }",
      "",
      "  if (-not $Ready) {",
      "    throw ('Timeout: l''application ne répond pas sur ' + $ShinyUrl)",
      "  }",
      "",
      "  Start-Process $ShinyUrl",
      "",
      "  if ($SplashProc -and -not $SplashProc.HasExited) {",
      "    Stop-Process -Id $SplashProc.Id -Force",
      "  }",
      "",
      "  exit 0",
      "}",
      "catch {",
      "  try {",
      "    if ($SplashProc -and -not $SplashProc.HasExited) {",
      "      Stop-Process -Id $SplashProc.Id -Force",
      "    }",
      "  } catch {}",
      "",
      "  Add-Type -AssemblyName System.Windows.Forms",
      "  [System.Windows.Forms.MessageBox]::Show(",
      "    'Le lancement de l''application a échoué.' + \"`n`n\" + $_.Exception.Message + \"`n`nConsultez le dossier logs.\",",
      "    'Erreur de lancement',",
      "    [System.Windows.Forms.MessageBoxButtons]::OK,",
      "    [System.Windows.Forms.MessageBoxIcon]::Error",
      "  ) | Out-Null",
      "  exit 1",
      "}",
      sep = "\n"
    ),
    shiny_url,
    shiny_url
  )

  writeLines(ps1_script, ps1_path, useBytes = TRUE)

  vbs_script <-
'Option Explicit
Dim shell, fso, appDir, ps1Path, cmd
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
appDir = fso.GetParentFolderName(WScript.ScriptFullName)
ps1Path = appDir & "\\wait_and_open.ps1"
cmd = "powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & ps1Path & """"
shell.CurrentDirectory = appDir
shell.Run cmd, 0, False
'
  writeLines(vbs_script, vbs_path, useBytes = TRUE)

  bat_script <-
'@echo off
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0wait_and_open.ps1"
pause
'
  writeLines(bat_script, bat_path, useBytes = TRUE)

  message('✔ Lanceur desktop créé :')
  message('  - ', splash_path)
  message('  - ', ps1_path)
  message('  - ', vbs_path)
  message('  - ', bat_path)

  invisible(list(
    splash = splash_path,
    powershell = ps1_path,
    vbs = vbs_path,
    bat = bat_path
  ))
}
