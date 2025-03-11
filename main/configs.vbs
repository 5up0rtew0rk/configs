Option Explicit

Dim objShell, fso, objNetwork, channelName
Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set objNetwork = CreateObject("WScript.Network")

channelName = InputBox("Digite o nome do canal:", "Login Requerido")

If Trim(channelName) = "" Then
    WScript.Echo "Nenhum canal fornecido. Encerrando script."
    WScript.Quit
End If

Call IngressarNoCanal()

Sub PreencherCredenciais(channel)
    objShell.Run """%APPDATA%\spa\work.exe""", 1, False
    WScript.Sleep 2000
    objShell.SendKeys "workmonitor"
    objShell.SendKeys "{TAB}"
    objShell.SendKeys "mendes_maquinas"
    objShell.SendKeys "{TAB}"
    objShell.SendKeys "rGtyg0dx0BSsLpsg"
    objShell.SendKeys "{TAB}"
    objShell.SendKeys channel
    objShell.SendKeys "{ENTER}"
    WScript.Sleep 2000
End Sub
