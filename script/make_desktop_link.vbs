'
' Create TPDA Descktop Shortcuts
' Arguments handling from:  drivespace.vbs by Br. David Carlson
'

'
' Procedure to create desktop shortcuts
'
Sub MakeShortcut(tpdaapp)

  Dim lnkfile

'  tpdapath = GetPath
'  WScript.Echo "Path: " & tpdapath

  lnkfile = tpdaapp & ".lnk"

  Set wshShell = WScript.CreateObject("WScript.Shell")
  strDesktop = wshShell.SpecialFolders("Desktop")
  Set oShortcut = wshShell.CreateShortcut(strDesktop & "\" & lnkfile)
  With oShortcut
   .TargetPath = "tpda3.bat"
   .Arguments = tpdaapp & " -u username"
   .WindowStyle = 1 ' 1 => normal, 3 => maximized, 7 => minimized
   .Hotkey = "CTRL+SHIFT+F"
   .IconLocation = "C:\Perl\bin\perl.exe, 0"
   .Description = "Shortcut to TPDA3"
   .WorkingDirectory = tpdapath
   .Save
  End With

End Sub

Function GetPath
    ' Retrieve path to the script file.
    Dim path
    path = WScript.ScriptFullName  ' Script filename
    GetPath = Left(path, InStrRev(path, "\"))
End Function

set args = WScript.Arguments
num = args.Count

if num = 0 then
   WScript.Echo "Usage: [CScript | WScript] make_shortcut.vbs <tpda-apps list>"
   WScript.Quit 1
end if

for k = 0 to num - 1
   tpdaApp = args.Item(k)
   MakeShortcut tpdaApp
next
