Option Explicit

Dim objShell, channelName
Set objShell = CreateObject("WScript.Shell")

' Solicita ao usuário que insira o nome do canal
channelName = InputBox("Digite o nome do canal:", "Login Requerido")

' Verifica se o usuário inseriu um nome de canal
If Trim(channelName) = "" Then
    WScript.Echo "Nenhum canal fornecido. Encerrando script."
    WScript.Quit
End If

' Executa o aplicativo e preenche os campos automaticamente
Call PreencherCredenciais(channelName)

WScript.Echo "Preenchimento concluído."

Sub PreencherCredenciais(channel)
    ' Executa o aplicativo
    objShell.Run """%APPDATA%\spa\work.exe""", 1, False
    ' Aguarda 2 segundos para o aplicativo iniciar
    WScript.Sleep 2000
    ' Envia as teclas para preencher os campos
    objShell.SendKeys "tesste"
    objShell.SendKeys "{TAB}"
    objShell.SendKeys "teste_wk"
    objShell.SendKeys "{TAB}"
    objShell.SendKeys "rGtyg0dx0BSsLpsg"
    objShell.SendKeys "{TAB}"
    objShell.SendKeys channel
    objShell.SendKeys "{ENTER}"
    ' Aguarda 2 segundos após o preenchimento
    WScript.Sleep 2000
End Sub
