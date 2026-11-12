@echo off
setlocal
title AR Wisuda - HTTPS lokal

set "PROJECT_DIR=%~dp0"
set "CERT_DIR=%LOCALAPPDATA%\ar-filter-wisuda"
set "PFX_FILE=%CERT_DIR%\server.pfx"
set "PORT=8443"
set "CERT_PASSWORD=ar-wisuda-local-only"

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js belum terpasang. Instal Node.js LTS, lalu jalankan file ini lagi.
  pause
  exit /b 1
)

for /f "delims=" %%I in ('powershell -NoProfile -Command "(Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -and $_.NetAdapter.Status -eq 'Up' } | Select-Object -First 1 -ExpandProperty IPv4Address).IPAddress"') do set "LAN_IP=%%I"
if not defined LAN_IP (
  echo Tidak bisa menemukan IP Wi-Fi/LAN.
  echo Sambungkan laptop ke Wi-Fi, lalu jalankan file ini lagi.
  pause
  exit /b 1
)

if not exist "%CERT_DIR%" mkdir "%CERT_DIR%"
powershell -NoProfile -Command "$ip='%LAN_IP%'; $cert=New-SelfSignedCertificate -Subject ('CN='+$ip) -TextExtension @('2.5.29.17={text}IPAddress='+$ip+'&DNS=localhost') -CertStoreLocation 'Cert:\CurrentUser\My' -KeyAlgorithm RSA -KeyLength 2048 -NotAfter (Get-Date).AddDays(30); if (-not $cert) { exit 1 }; $pwd=ConvertTo-SecureString '%CERT_PASSWORD%' -AsPlainText -Force; Export-PfxCertificate -Cert $cert -FilePath '%PFX_FILE%' -Password $pwd | Out-Null; if (-not $?) { exit 1 }"
if errorlevel 1 (
  echo Gagal membuat sertifikat HTTPS.
  pause
  exit /b 1
)

netsh advfirewall firewall show rule name="AR Wisuda HTTPS 8443" >nul 2>nul
if errorlevel 1 (
  powershell -NoProfile -Command "$p=Start-Process -FilePath ($env:SystemRoot+'\System32\netsh.exe') -ArgumentList 'advfirewall firewall add rule name=\"AR Wisuda HTTPS 8443\" dir=in action=allow protocol=TCP localport=8443 profile=any remoteip=localsubnet' -Verb RunAs -Wait -PassThru; exit $p.ExitCode"
) else (
  powershell -NoProfile -Command "$p=Start-Process -FilePath ($env:SystemRoot+'\System32\netsh.exe') -ArgumentList 'advfirewall firewall set rule name=\"AR Wisuda HTTPS 8443\" new profile=any remoteip=localsubnet' -Verb RunAs -Wait -PassThru; exit $p.ExitCode"
)
if errorlevel 1 (
  echo Gagal mengatur firewall. Izinkan permintaan Administrator jika muncul.
  pause
  exit /b 1
)

echo.
echo Buka alamat ini di HP yang terhubung ke Wi-Fi yang sama:
echo https://%LAN_IP%:%PORT%/
echo Browser HP mungkin menampilkan peringatan sertifikat lokal.
echo Tekan Ctrl+C untuk menghentikan server.
echo.
set "AR_HTTPS_PFX=%PFX_FILE%"
set "AR_HTTPS_PASSWORD=%CERT_PASSWORD%"
set "AR_HTTPS_ROOT=%PROJECT_DIR%"
node "%PROJECT_DIR%serve-https.js"
pause
