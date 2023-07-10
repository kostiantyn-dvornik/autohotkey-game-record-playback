;Pixel search == 0 => Fond
SetBatchLines -1

AvailableScripts := []

Loop Files, %A_WorkingDir%\*.ahk, R ; Recurse into subfolders.
{
    Filename = %A_LoopFileName%

    If InStr(A_LoopFileName, "Main")
    {
        AvailableScripts.Push(A_LoopFileName)
    }
}

if AvailableScripts.Length() == 0
    return

ToolTip "F5 to start"

F5::

    script = % AvailableScripts[1] ;Arrays starts from 1
    Run Playback.exe %script%

    ToolTip "F12 to stop"
return

F12::
    Process, Close, Playback.exe ;Close current playback
ExitApp
return