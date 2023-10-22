;AC Valhala
#Requires AutoHotkey v1.1.33+
#include ScenarioRunner_Base_ACV.ahk
#include NNHelper.ahk

InitializeScripts()

ToolTip "Press F5 to start"

F5::
    LastTimeBlack := A_TickCount 
    NNInitialize()   
        
    if WinExist("Assassin's Creed Valhalla")
         WinActivate ; Use the window found by WinExist.
         WinMove, A,, 0, 0 , 1600, 900

    SetTimer Playback, 50 ;Periof of regular state check detection
    SetTimer NNDetectCameraPosition, 500 ;Period of NN execution 
    ToolTip "Playback random scripts F12 to stop"
return

F12::    
    StopCurrentPlayback()
    NNDestroy()    
ExitApp
return