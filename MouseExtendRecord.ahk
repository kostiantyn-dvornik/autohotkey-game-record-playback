#include MouseDelta.ahk
#SingleInstance,Force

SetBatchLines -1
LogFile := A_WorkingDir "\TempRecord.txt"
Rec := "SetBatchLines -1`nSleep 100`nToolTip ""Playback recording Playback recording %A_ScriptName%"", 0, 0"

Keys := ["d", "a", "w", "s", "space", "RButton", "LButton", "LAlt", "e", "c", "f", "q", "Esc", "Enter"]

States := []
for i, element in Keys
{
    States.Push(0)
}

ToolTip "F5 to start record"

return

F5::
    LastState := 0
    LastTime := A_TickCount

    SetTimer WaitForKey, 1

    Md := new MouseDelta("MouseEvent")
    Md.SetState(1)

    ToolTip "Recording to a file Recording to a file. F12 to stop"
return

F12::
    ToolTip ""
    FileDelete %LogFile%

    Rec := Rec "`nFileAppend %A_ScriptName%, %A_WorkingDir%\neednewrun.txt"

    FileAppend %Rec%, %LogFile%
    Run %LogFile%

    Md.Delete()
    Md := ""
ExitApp
return

MouseEvent(MouseID, x := 0, y := 0)
{
    global Rec, LastTime

    t := A_TickCount
    Delay := t - LastTime
    LastTime := t

    if (Delay > 0)
        Rec := Rec "`nSleep " Delay

    Rec := Rec "`nDllCall(""mouse_event"",""UInt"", 0x01, ""UInt""," x ", ""UInt"","y ")"

}

WaitForKey()
{
    global LastState,LastTime,Rec,Keys,States

    wasStateChange := false

    for i, element in Keys
    {
        state := GetKeystate(element)
        if(States[i] != state)
        {
            wasStateChange := true
        }
    }

    if(wasStateChange)
    {
        t := A_TickCount
        Delay := t - LastTime
        LastTime := t
        Rec := Rec "`nSleep " Delay
    }

    for i, element in Keys
    {
        state := GetKeystate(element)
        if(States[i] != state)
        {
            if(state = 1)
            {
                Rec := Rec "`nSend {" element " down}"
            }
            else
            {
                Rec := Rec "`nSend {" element " up}"
            }
            States[i] := state
        }
    }
}
