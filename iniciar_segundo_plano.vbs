Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
currentDir = fso.GetParentFolderName(WScript.ScriptFullName)
batchPath = currentDir & "\iniciar.bat"

' Ejecuta iniciar.bat de forma totalmente invisible (0 = ventana oculta, False = no esperar)
WshShell.Run """" & batchPath & """", 0, False
