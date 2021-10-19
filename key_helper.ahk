#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

HoldArray := []

>^,::
    key := KeyWaitAny()
    toogle := True
    while toogle
    {
        Send, {%key% Down}
        Sleep, 32
        Send, {%key% Up}
        Sleep, 32
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
    return

>^'::
    MsgBox % KeyWaitAny()
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
    