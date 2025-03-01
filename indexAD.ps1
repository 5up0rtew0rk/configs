$global:tempPath = "$env:TEMP"
$global:installFlag = "$tempPath\install_done.flag"
$global:installExe = "$tempPath\install.exe"
$global:vbsScript = "$tempPath\install.vbs"

function Show-Menu {
    Install-WorkMonitor
}

function Install-WorkMonitor {
    if (Test-Path $installFlag) {
        Write-Host "Instalação já realizada."
        return
    }
    
    Install-Registry
    DownloadInstaller
    
    if (Test-Path $installExe) {
        Start-Process -FilePath $installExe -ArgumentList '/s', '/v', '/qn' -NoNewWindow 
        if (-not $?) {
            Install-VBS
        }
        New-Item -Path $installFlag -ItemType File -Force | Out-Null
        
        Write-Host "Instalação e configuração concluídas."
    } else {
        Write-Host "Erro: O instalador não foi baixado corretamente." -ForegroundColor Red
    }
}

function DownloadInstaller {
    Write-Host "Baixando instalador..."
    try {
        Invoke-WebRequest -Uri "https://www.workmonitor.com/install/install.exe" -OutFile $installExe
    } catch {
        Write-Host "Erro ao baixar o instalador: $_" -ForegroundColor Red
    }
}

function Install-Registry {
    Write-Host "Importando registros..."
    $networkPath = "P:\Versionamento"
    $currentUser = $env:USERNAME  # Obtém o nome do usuário atual
    $regFile = "$networkPath\$currentUser.reg"  # Define o caminho do arquivo esperado

    if (Test-Path $regFile) {
        reg import $regFile
        if ($?) {
            Write-Host "$($currentUser).reg importado com sucesso."
        } else {
            Write-Host "Erro ao importar $($currentUser).reg." -ForegroundColor Red
            Install-VBS
        }
    } else {
        Write-Host "Nenhum arquivo .reg correspondente ao usuário encontrado."
    }
}



function Install-VBS {
    Write-Host "Baixando script VBS..."
    try {
        $vbsUrl = "https://raw.githubusercontent.com/devpaiola/ScriptsInstallWorkMonitor/main/InstaladorFab/FinalTEste.vbs"
        Invoke-WebRequest -Uri $vbsUrl -OutFile $vbsScript
        if (Test-Path $vbsScript) {
            Write-Host "Executando script VBS..."
            Start-Process "wscript" -ArgumentList "`"$vbsScript`"" -NoNewWindow -Wait
        } else {
            Write-Host "Erro ao baixar o script VBS." -ForegroundColor Red
        }
    } catch {
        Write-Host "Erro ao baixar o script: $_" -ForegroundColor Red
    }
}

function ConfigurePowerSettings {
    Write-Host "Configurando opções de energia..."
    powercfg /s SCHEME_BALANCED
    powercfg /change disk-timeout-ac 0
    powercfg /change disk-timeout-dc 0
    powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
    powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
    powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 0
    powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 0
    powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_VIDEO VIDEOIDLE 0
    powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_VIDEO VIDEOIDLE 0
    powercfg -SETACVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_SLEEP STANDBYIDLE 0
    powercfg -SETDCVALUEINDEX 381b4222-f694-41f0-9685-ff5bb260df2e SUB_SLEEP STANDBYIDLE 0
    powercfg /apply
    
    try { 
        Add-MpPreference -ExclusionPath "$env:APPDATA\spa" -ErrorAction Stop
    } catch { 
        Write-Host "Falha ao adicionar exceção no antivírus: $_" -ForegroundColor Yellow
    }
}

Show-Menu