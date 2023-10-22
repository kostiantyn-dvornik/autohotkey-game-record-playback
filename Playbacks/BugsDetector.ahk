;Pixel search == 0 => Found
SetBatchLines -1

BlackLastTime := A_TickCount
BlackWasDetected := 0
BlackImagePath = %A_WorkingDir%\black.bmp

PurpleLastTime := A_TickCount
PurpleWasDetected := 0
PurpleImagePath = %A_WorkingDir%\purple.bmp

DetectVisualBugs(leftX, leftY, rightX, rightY)
{
    global BlackLastTime, BlackWasDetected, BlackImagePath ;Dont forget to add globals
    global PurpleLastTime, PurpleWasDetected, PurpleImagePath

    ;TODO Check perfomance of max image scans available for game
    DetectImageStuck(BlackLastTime, BlackWasDetected, BlackImagePath, leftX, leftY, rightX, rightY, 20000 ) ;2sec blacks could be just transition
    DetectImageStuck(PurpleLastTime, PurpleWasDetected, PurpleImagePath, leftX, leftY, rightX, rightY, 10000 ) ;Purple not common
}

CheckImage(lefX, leftY, rightX, rightY, tolerance, path)
{
    ImageSearch, foundX, foundY, lefX, leftY, rightX, rightY, *%tolerance% %path%
    return ErrorLevel
}

DetectImageStuck(ByRef lastTime, ByRef wasDetected, imagePath, leftX, leftY, rightX, righY, stuckTime)
{
    if (CheckImage(leftX, leftY, rightX, righY, 5, imagePath)==0)
    {
        if (wasDetected == 0)
        {
            delay := A_TickCount - lastTime
            if (delay > stuckTime)
            {
                wasDetected := 1

                lastTime := A_TickCount
                Send LWin
                Send #{PrintScreen}
            }
        }
    }
    else
    {
        wasDetected := 0
        lastTime := A_TickCount
    }
}