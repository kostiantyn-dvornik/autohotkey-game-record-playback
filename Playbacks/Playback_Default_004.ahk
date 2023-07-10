SetBatchLines -1
Sleep 100
ToolTip "Playback recording Playback recording %A_ScriptName%", 0, 0
Sleep 469
Send {s down}
Sleep 47
DllCall("mouse_event","UInt", 0x01, "UInt",1, "UInt",0)
DllCall("mouse_event","UInt", 0x01, "UInt",1, "UInt",0)
DllCall("mouse_event","UInt", 0x01, "UInt",1, "UInt",0)
Sleep 31
DllCall("mouse_event","UInt", 0x01, "UInt",0, "UInt",-1)
Sleep 78
DllCall("mouse_event","UInt", 0x01, "UInt",1, "UInt",-2)
Sleep 406
Send {d down}
Sleep 610
Send {d up}
Send {a down}
Sleep 594
Send {a up}
Sleep 78
Send {d down}
Sleep 140
Send {d up}
Sleep 422
Send {space down}
Sleep 141
Send {space up}
Sleep 172
Send {space down}
Sleep 109
Send {space up}
Sleep 125
Send {d down}
Sleep 234
Send {d up}
Sleep 344
Send {a down}
Sleep 141
Send {a up}
Sleep 203
Send {c down}
Sleep 125
Send {c up}
Sleep 219
Send {c down}
Sleep 125
Send {c up}
Sleep 812
Send {space down}
Sleep 94
Send {space up}
Sleep 1250
Send {d down}
Sleep 516
Send {a down}
Sleep 15
Send {d up}
Sleep 172
Send {a up}
Send {s up}
FileAppend %A_ScriptName%, %A_WorkingDir%\neednewrun.txt