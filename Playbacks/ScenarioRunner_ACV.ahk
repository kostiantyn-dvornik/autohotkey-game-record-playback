;AC Valhala
#Requires AutoHotkey v1.1.33+
#include ScenarioRunner_Base_ACV.ahk

InitializeScripts()

ToolTip "Press F5 to start"

F5::
    if WinExist("Assassin's Creed Valhalla")
        WinActivate ; Use the window found by WinExist.
        WinMove, A,, 0, 0 , 1600, 900
        
    LastTimeBlack := A_TickCount    
    SetTimer Playback, 50
    ToolTip "Playback random scripts F12 to stop"
return

F12::    
    StopCurrentPlayback()    
ExitApp
return