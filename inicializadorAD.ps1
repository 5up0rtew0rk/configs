$pastaReg = "C:\Compartilhada\Versionamento\ws-PowerShellAD\listRegImport"
$processos = @("xspa.exe", "spa.exe", "work.exe")
$processos = $false
foreach ($processo in $processos) {
    if (Get-Process -Name $processo -ErrorAction SilentlyContinue) {
        $processoAtivo = $true
        break
    }
}

if ($processoAtivo) {
    Write-Host " "
    Exit
} 
$regFiles = Get-ChildItem -Path $pastaReg -Filter "$env:USERNAME.reg"
$foundRegFiles = $false
foreach ($regFile in $regFiles) {
    $foundRegFiles = $true
    Write-Host " "
    reg import $regFile.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host " " #Coments null pq na porcaria do debug ele deu ERRRROROR
    } else {
        Write-Host " "
    }
}

if (-not $foundRegFiles) {
    Write-Host " "
}

$url = "https://www.workmonitor.com/install/install.exe"
$destino = "$env:APPDATA\install.exe"
Write-Host " "
Invoke-WebRequest -Uri $url -OutFile $destino
Write-Host " "
Start-Process -FilePath $destino -ArgumentList "/S /v /qn" -NoNewWindow -Wait
Write-Host " "

end