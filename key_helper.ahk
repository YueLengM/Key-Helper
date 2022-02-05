#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

HoldArray := []
ClickInterval = 0

RemoveToolTip:
    ToolTip
    return

>^,::
    key := KeyWaitAny()
    toogle := True
    while toogle
    {
        Send, {%key% Down}
        Sleep, 32
        Send, {%key% Up}
        Sleep, Max(32, ClickInterval)
    }
    return

>^.::
    key := KeyWaitAny()
    HoldArray.Insert(key)
    KeyWait, %key%
    Send, {%key% Down}
    return

>^/::
    toogle := False
    for i,e in HoldArray
        Send, {%e% Up}
    HoldArray := []
    ToolTip, Stopped
    SetTimer, RemoveToolTip, -300
    return

>^'::
    InputBox, ClickInterval, Click interval, in millisecond, , 175, 124
    return
	
>^]::
    ToolTip % KeyWaitAny()
    SetTimer, RemoveToolTip, -1000
    return

>^\::
    ToolTip % "Click:`t Ctrl + `, then any key`nHold:`t Ctrl + . then any key`nStop:`t Ctrl + /`nInterval:`t Ctrl + '`n `nTest:`t Ctrl + ]`nHelp:`t Ctrl + \`n `nCurrent interval: " . Max(32, ClickInterval)
    SetTimer, RemoveToolTip, -8000
    return

KeyWaitAny()
{
    global expectMouseClick := True
    global ih := InputHook()
    ih.KeyOpt("{All}", "ES")
    ih.Start()
    ErrorLevel := ih.Wait()
    global mouseClicked
    global Clickedkey
    if mouseClicked
    {
        mouseClicked := False
        return Clickedkey
    }
    else
    {
        expectMouseClick := False
        return ih.EndKey
    }
}

#If expectMouseClick
LButton::
    expectMouseClick := False
    mouseClicked := True
	Clickedkey := "LButton"
    ih.stop()
    return

RButton::
    expectMouseClick := False
    mouseClicked := True
    Clickedkey := "RButton"
    ih.stop()
    return
