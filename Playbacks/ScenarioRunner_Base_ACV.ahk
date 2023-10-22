;AC Valhala
;Target resolution of win mode of ini file is 1600x900 (Note that actual windows is 1586x893)
;Pixel search == 0 => Found
#Requires AutoHotkey v1.1.33+
#include BugsDetector.ahk
SetBatchLines -1

AvailableScripts := []
AvailableScriptsFight := []
AvailableScriptsEscape := []

State := 0 ; 0 - default, 1 - fight, 2 - escape

LastTimeDamaged := A_TickCount

Keys := ["d", "a", "w", "s", "space", "RButton", "LButton", "LAlt", "e"] ; Keys that need to force up to prevent stucking

; End of globals
;

InitializeScripts()
{
    global AvailableScripts,AvailableScriptsFight, AvailableScriptsEscape

    Loop Files, %A_WorkingDir%\*.ahk, R ; Recurse into subfolders.
    {
        Filename = %A_LoopFileName%
    
        If InStr(A_LoopFileName, "Default")
        {
            AvailableScripts.Push(A_LoopFileName)
        }
        else If InStr(A_LoopFileName, "Fight")
        {
            AvailableScriptsFight.Push(A_LoopFileName)
        }
        else If InStr(A_LoopFileName, "Escape")
        {
            AvailableScriptsEscape.Push(A_LoopFileName)
        }
    }

    if AvailableScripts.Length() == 0
        ExitApp
    
    if !FileExist("neednewrun.txt")
        FileAppend A_ScriptName, %A_WorkingDir%\neednewrun.txt
}

Playback()
{
    ;Use return to test separate logic
    ;return 

    global AvailableScripts,AvailableScriptsFight, AvailableScriptsEscape, State, LastTimeDamaged

    ProcessCommonActions()

    DetectVisualBugs(0,500,1600,900)

    if(State == 0) ;Default
    {
        if FileExist("neednewrun.txt")
        {
            MakeKeyUp()
            Random, rand, 1, AvailableScripts.MaxIndex()
            script = % AvailableScripts[rand]
            Run Playback.exe %script%
            FileDelete %A_WorkingDir%\neednewrun.txt
        }

        PixelSearch, Px, Py, 119, 822, 380, 830, 0x3244fb, 20, Fast ;Have damaged
        if (ErrorLevel == 0)
        {
            State := 1
            LastTimeDamaged = A_TickCount
            StopCurrentPlayback()
        }
    }
    else if(State == 1) ;Fight
    {
        ;ToolTip "Enter fight mode"

        if FileExist("neednewrun.txt")
        {
            MakeKeyUp()
            ;ToolTip "Play fight scenario"
            Random, rand, 1, AvailableScriptsFight.MaxIndex()
            script = % AvailableScriptsFight[rand]
            Run Playback.exe %script%
            FileDelete %A_WorkingDir%\neednewrun.txt
        }

        ;Check low hp
        PixelSearch, Px, Py, 179, 822, 380, 830, 0xc8c8c8, 10, Fast
        er0 := ErrorLevel

        if (er0 == 1)
        {
            ;ToolTip "Escape mode"
            StopCurrentPlayback()
            State := 2
            return
        }

        PixelSearch, Px, Py, 119, 822, 380, 830, 0x3244fb, 20, Fast ;Have damaged
        er1 := ErrorLevel
        if (er1 == 1)
        {
            t:=A_TickCount
            delay:=t-LastTimeDamaged

            if ( delay > 10000)
            {
                ;ToolTip "Battle finished"
                StopCurrentPlayback()
                State := 0
                return
            }
        }
        else
        {
            LastTimeDamaged := A_TickCount
        }
    }
    else if(State == 2) ;Escape
    {
        if FileExist("neednewrun.txt")
        {
            MakeKeyUp()
            ;ToolTip "Play escape scenario"
            Random, rand, 1, AvailableScriptsEscape.MaxIndex()
            script = % AvailableScriptsEscape[rand]
            Run Playback.exe %script%
            FileDelete %A_WorkingDir%\neednewrun.txt
        }

        ;Check exit
        PixelSearch, Px, Py, 670, 118, 803, 121, 0x095bb5, 15, Fast ;Yellow
        er1 := ErrorLevel

        PixelSearch, Px, Py, 670, 118, 803, 121, 0x0506e9, 15, Fast ;Red
        er2 := ErrorLevel

        if (er1 == 1 and er2 == 1)
        {
            ;ToolTip "Enter default mode"
            StopCurrentPlayback()
            State := 0
            return
        }
    }
}

ProcessCommonActions()
{
    ImageSearch, foundX, foundY, 0, 0, 1600, 900, *100 *Trans0xFF0000 %A_WorkingDir%\interact_E.bmp
    er1 := ErrorLevel

    if (er1 == 0)
    {
        ;ToolTip "Found interact feedback"
        Send { e down}
        Sleep 100
        Send { e up}
        Sleep 100
    }
    else
    {
        ;ToolTip "Not found feedback"
    }

    ImageSearch, foundX, foundY, 0, 0, 1600, 900, *100 *Trans0xFF0000 %A_WorkingDir%\interact_F.bmp
    er2 := ErrorLevel

    if (er2 == 0)
    {
        ;ToolTip "Found interact feedback"
        Send { f down}
        Sleep 200
        Send { f up}
        Sleep 200
    }
    else
    {
        ;ToolTip "Not found feedback"
    }
}

MakeKeyUp()
{
    global Keys

    ;Make Keys up to prevent state stick
    for i, element in Keys
    {
        k = % Keys[i]
        Send { %k% up}
    }
}

StopCurrentPlayback()
{
    State := -1
    Process, Close, Playback.exe ;Close current playback
    FileAppend A_ScriptName, %A_WorkingDir%\neednewrun.txt
    MakeKeyUp()
}
