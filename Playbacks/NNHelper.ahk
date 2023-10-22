#Requires AutoHotkey v1.1.33+
SetBatchLines -1

NNLogFile := A_WorkingDir "\NNLog.txt"
NNRec := "Start"
OutputVarPID = 0

NNState := 0 

nnPythonFilePath := A_WorkingDir "\NNFromPython.txt"
NNFromPythonFile := FileOpen(nnPythonFilePath, "r") 

NNInitialize()
{
    global OutputVarPID

    nnFilePath := A_WorkingDir "\NNFromAHK.txt"
    nnFromAHKFile := FileOpen(nnFilePath, "w") 
    nnFromAHKFile.Write("")
    nnFromAHKFile.Close()

    nnPythonFilePath := A_WorkingDir "\NNFromPython.txt"
    nnFromPythonFile := FileOpen(nnPythonFilePath, "w") 
    nnFromPythonFile.Write("")
    nnFromPythonFile.Close()
    
    Run, python %A_WorkingDir%\RunNN.py, , , OutputVarPID
    WinWait, ahk_exe WindowsTerminal.exe
    WinMove, 1586, 0
    
}

NNDestroy()
{
    global NNFromAHKFile, NNFromAHKFile
    Process, Close, python.exe
    NNWriteLog() 

    nnFilePath := A_WorkingDir "\NNFromAHK.txt"
    nnFromAHKFile := FileOpen(nnFilePath, "w") 
    nnFromAHKFile.Write("")
    nnFromAHKFile.Close()

    nnPythonFilePath := A_WorkingDir "\NNFromPython.txt"
    nnFromPythonFile := FileOpen(nnPythonFilePath, "w") 
    nnFromPythonFile.Write("")
    nnFromPythonFile.Close()    
    
}

NNDetectCameraPosition()
{        
    global NNRec, NNState, NNFromPythonFile

    if (NNState==0)
    {
        WinGetPos, X, Y, W, H, A
        R := X + W
        B := Y + H
        NNRec := NNRec "`nStart " A_TickCount

        srect = %X% %Y% %R% %B%
        
        nnFromAHKFilePath := A_WorkingDir "\NNFromAHK.txt"
        nnFromAHKFile := FileOpen(NNFromAHKFilePath, "a")
        nnFromAHKFile.WriteLine(srect)  
        nnFromAHKFile.Close()

        NNState = 1
    }
    Else if (NNState==1)
    {
        ; ToolTip, Waitn NN to respond

        readString := ""
        While readString == ""
        {                   
            readString := NNFromPythonFile.ReadLine()                       
        }
        
        NNRec := NNRec "`nFinis " A_TickCount

        ; ToolTip, %A_TickCount% %readString%
        
        if (SubStr(readString, 1 , 1) == "1")
        {   
            Loop, 25
            {     
                DllCall("mouse_event","UInt", 0x01, "UInt",0, "UInt",20)
                Sleep, 1
            }
        }
        Else if(SubStr(readString, 1 , 1) == "2")
        {
            Loop, 25
            {     
                DllCall("mouse_event","UInt", 0x01, "UInt",0, "UInt",-30)
                Sleep, 1
            }
        }

        NNState = 0

    }            
    
}

NNWriteLog()
{
    global NNLogFile, NNRec
    FileAppend %NNRec%, %NNLogFile%
}