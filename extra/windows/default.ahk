#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Remappings
Capslock::Esc
!PgUp::Volume_Up
!PgDn::Volume_Down
!Home::Media_Play_Pause
!End::Media_Next

XButton1::Send ^#{Left}
XButton2::Send ^#{Right}

![::Send ^{PgUp}
!]::Send ^{PgDn}

!=::
	WinGet MX, MinMax, A
	If MX
		WinRestore A
	Else
		WinMaximize A
	return

PrintScreen::Run C:\WINDOWS\system32\SnippingTool.exe

; Launchers
!l::DllCall("LockWorkStation")
!t::Run C:\Users\jglenden\AppData\Local\wsltty\bin\mintty.exe -o Locale=C -o Charset=UTF-8 /bin/wslbridge -t /bin/bash -l
!w::Run C:\Program Files (x86)\Google\Chrome\Application\chrome.exe

; Virtual Desktop Switching
!1::Run, VirtualDesktopCtrl.exe 0, , hide
!2::Run, VirtualDesktopCtrl.exe 1, , hide
!3::Run, VirtualDesktopCtrl.exe 2, , hide
!4::Run, VirtualDesktopCtrl.exe 3, , hide
!5::Run, VirtualDesktopCtrl.exe 4, , hide
!6::Run, VirtualDesktopCtrl.exe 5, , hide
!7::Run, VirtualDesktopCtrl.exe 6, , hide
!8::Run, VirtualDesktopCtrl.exe 7, , hide
!9::Run, VirtualDesktopCtrl.exe 8, , hide
