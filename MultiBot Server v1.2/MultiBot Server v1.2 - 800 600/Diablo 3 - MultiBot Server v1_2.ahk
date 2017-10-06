#persistent
#singleinstance force
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

	#include Socket.ahk
	#include Time.ahk
	
	global riftopen := [287, 190, 457, 386, "\pngs\rift-open.png", 93, 118 , 65,2] 
	global cancelgrift := [1030, 340, 1130, 405, "\pngs\g2cancel.png", 78, 45, "*65 *TransBlack", 1] 
	global menu_start_disabled := [223, 471, 414, 560, "\pngs\menu_disabled_side2_small.png", 32, 59 , "*23 *TransWhite",2] 
	global leavegame := [1024, 955, 1092, 1000, "\pngs\esc_return.png", 45, 26, "*30 *TransBlack", 1] ; tbm funciona para logoutonmenu
	global logoutonmenu :=  [81, 454, 405, 514, "\pngs\newleavegame.png", 38, 42, 50,2] 
	global acceptgr := [780, 793, 1156, 864, "\pngs\newacceptgr.png", 70, 43 , "*35 *TransBlack",1]
	global leaveparty := [1618, 878, 1672, 925, "\pngs\newleaveparty.png", 16, 32 , 60,3]
	global leaveparty2 := [701, 567, 1216, 726, "\pngs\newleaveparty2.png", 410, 23 , 60,1] ; tbm funciona para inactivity
	global inactivity := [713, 388 1220, 700, "\pngs\newinactivity2.png", 424,79 , "*50 *TransBlack",1]
	global grcomplete := [722, 674, 872, 911, "\pngs\grcomplete.png" ,49 ,150,60,1]
	;global risenecro := [1422, 971, 1664, 1027, "\pngs\risenecro.png", 171,18 , "*30 *TransBlack",3]
	
	
	global teleport1 := [62 , 247,2]
	global teleport2 := [170, 390,2]
	global acceptclick := [961, 805,1]
	global cancelbutton := [1061, 375,1]
	global leavegamebutton := [291, 484,2]
	global leavepartybutton := [1690, 900,2]
	global leaveparty2button := [860, 660,2]
	global disconnectedbutton := [ 962 , 661,1 ]
	global cancelgriftbutton := [ 962 , 883, 1 ]
	;global risenecrobutton := [ 1540 , 990,3 ]
	
	ConvertClick(teleport1)
	ConvertClick(teleport2)
	ConvertClick(acceptclick)
	ConvertClick(cancelbutton)
	ConvertClick(leavegamebutton)
	ConvertClick(leavepartybutton)
	ConvertClick(leaveparty2button)
	ConvertClick(disconnectedbutton)
	ConvertClick(cancelgriftbutton)
	;ConvertClick(risenecrobutton)
	
	
	ConvertCoordinates(grcomplete)
	ConvertCoordinates(riftopen)
	ConvertCoordinates(menu_start_disabled)
	ConvertCoordinates(logoutonmenu)
	ConvertCoordinates(cancelgrift)
	ConvertCoordinates(inactivity)
	ConvertCoordinates(acceptgr)
	ConvertCoordinates(leavegame)
	ConvertCoordinates(leaveparty)
	ConvertCoordinates(leaveparty2)
	;ConvertCoordinates(risenecro)
	
	global paused := 0
	WriteLog("Start Script Executing")	
	
	Iniread, serverport, variables.ini, Settings, ServerPort
	Iniread, logpath, variables.ini, Settings, LogPath
	Iniread, InitialWin, variables.ini, Settings, RosWintitle
	
	global myServer := new SocketTCP()
	myServer.onAccept := Func("OnTCPAccept")
	myServer.bind("addr_any", serverport)
	myServer.listen()
	WriteLog("Server listening")
	
	
	Gui Add, Text, x45 y107 w49 h20 +Right, Log File
	Gui Add, GroupBox, x19 y38 w728 h276 , Settings
	Gui Add, Edit, vserverport x121 y67 w107 h18 , %serverport%
	Gui Add, Edit, vlogpath x120 y107 w305 h18 , %logpath%
	Gui Add, Button, gdoexit x520 y341 w110 h40, Hide
	Gui Add, Button, gdostart x186 y342 w110 h40, Update
	Gui Add, Text, x58 y148 w39 h17 +Center, Browse
	Gui Add, Text, x55 y68 w38 h20 +Right, Port
	Gui Add, Button, gdochoosefile x119 y144 w54 h19 , Choose
	Gui Add, ListView, gprocesslistview AltSubmit x551 y92 w120 h160, Name
	Gui Add, Button, grefreshprocess x551 y255 w54 h19, Refresh
	Gui Add, GroupBox, x45 y183 w424 h104
	Gui Add, Text, vguitext x53 y197 w407 h84 Left, %guitext%
	if (serverport >0){
		GuiControl, Text, guitext,Server Started on port %serverport%
	}
	if (StrLen(InitialWin) >0){
		GuiControlGet, guitextapp,, guitext
		GuiControl, Text, guitext,%guitextapp%`nProcess: %InitialWin%
	}
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
	{
		if (process.Name != "chrome.exe" and process.Name != "svchost.exe") {
			processname1 := process.Name
			WinGetTitle, ProcessTitle, ahk_exe %processname1%	
			StringLen, length, ProcessTitle
			if (length > 2){
				LV_Add("", ProcessTitle)
			}
		}
		
	}
	Gui Add, Text, vrosbproctext x552 y59 w190 h28, RosB Process: %InitialWin%
	Gui Show, w798 h402, Window
	Return


	refreshprocess:
	LV_Delete()
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
	{
		if (process.Name != "chrome.exe" and process.Name != "svchost.exe") {
			processname1 := process.Name
			WinGetTitle, ProcessTitle, ahk_exe %processname1%	
			StringLen, length, ProcessTitle
			if (length > 2){
				LV_Add("", ProcessTitle)
			}
		}
		
	}
	return

	dochoosefile:
		FileSelectFile, logfileselected
		GuiControl,Text, logpath, %logfileselected%
	return
    
	doexit:
		Gui, destroy
	return
    
	processlistview:
	if A_GuiEvent = Normal
	{
		LV_GetText(InitialWin, A_EventInfo)
		GuiControl, Text, rosbproctext,RosB Process: %InitialWin%
	}
	return
	
	dostart:
		Gui, submit, NoHide
		Iniread, oldserverport, variables.ini, Settings, ServerPort
		Iniread, oldinitialwin, variables.ini, Settings, RosWintitle
		Iniwrite, %serverport%, variables.ini, Settings, ServerPort
		Iniwrite, %logpath%, variables.ini, Settings, LogPath	
		Iniwrite, %InitialWin%, variables.ini, Settings, RosWintitle			
		if(oldserverport != serverport or oldinitialwin != InitialWin ){
			reload
		}
	return
    
	F1::
		WinActivate,
	return

	OnTCPAccept(this)
	{
		global myClient := this.accept()
		myClient.onRecv := func("OnTCPRecv")
		myClient.onDisconnect := func("OnTCPDisconnect")
		WriteLog("connection accepted")
		GuiControlGet, guitextapp,, guitext
		GuiControl, Text, guitext,%guitextapp%`nClient Connected
	}
	
	OnTCPDisconnect(this)
	{
		WriteLog("TCP Client Disconected")
	}
			
	F12::
		myClient.sendText("testmsg")
	return
	
	
	F11::
		myClient.sendText("start")
	return
	

	OnTCPRecv(this)
	{
		Thread, NoTimers, true
		global controlText := this.recvText()	
		IfNotInString, controlText, ping
		{
			WriteLog("message received: " controlText)
		}
		
		IfInString, controlText, testmsg
		{
			GuiControlGet, guitextapp,, guitext
			GuiControl, Text, guitext,%guitextapp%`nTest Msg Received: Successful Client Connection
		}
		
	   IfInString, controlText, go to menu
	   {
	    
		if (exited = 0 and receivedfailed = 0){
			gosub, DoBlockInput
			failed1 := 1
			receivedfailed := 1
			SendInput, {F4 down}
 			Sleep 100
			SendInput, {F4 up}
 			Sleep 1000
			WriteLog("go to menu received: pause and leave")
			exited := 1
			chatstep := "blank"
			Gosub, dopause
			WinActivate, Diablo III
			 WriteLog("logout attempt")
			 Gosub, LeaveGame
			 WriteLog("focus diablo")
			 Gosub, FocusDiablo
		 }
	   }

	   	IfInString, controlText, pause
		{		
			WriteLog("pause received")
			if (paused = 0){	
				paused := 1
				SendInput, {F6}	
				WriteLog("F6 pause received: pausing")
			}
		}
		IfInString, controlText, cancelgrift
		{		
			WriteLog("received message cancelgrift")			
			if (paused = 0){
				paused :=0
				SendInput, {F6}
				WriteLog("F6 cancelgrift:pausing")
			}			
			Gosub, CancelGRift
		}
		
		IfInString, controlText, beginsequence
		{	
			WriteLog("received beginsequence: starting")
			Gui, destroy			
			WriteLog("starting rosb")
			Gosub, StartRos
			WriteLog("gosub init")
			Gosub, initial
			
					
		}
		
		IfInString, controlText, riftacceptbutton ;; means gr entered (he accepted the gr) 
		{
			if(paused = 1){
				Sleep 100
				Gosub, FocusDiablo	
				WriteLog("riftacceptbutton received: gr entered")	
				entered := 0
				orek := 0
				wentback := 0
				uiclosed := 0
				uiopened := 0
				didurshi := 0
				bosskilled := 0
				talkingui := 0
				completed := 0	
				gotourshi := 1	
				otherurshi := 0	
				receivedfailed := 0	
				pausestart := 0
				idled := 0
				idledtries := 0
				exited := 0	
				didurshi := 0
				talkingui := 0
				completed := 0
				otherurshi := 0	
				gotourshi := 1
				failed1 := 0
				failed2 := 0
				idled := 0
				idledtries := 0
				exited := 0
				receivedfailed := 0	
				paused := 0				
				Gosub, FocusDiablo				
				WriteLog("riftacceptbutton received: send cancelgrift")				
				if (paused = 1){
					paused :=0
					SendInput, {F6}
					WriteLog("F6 riftacceptbutton received: unpausing")
				}
			}
			else{
				entered := 0
				uiclosed := 0
				uiopened := 0
				didurshi := 0
				bosskilled := 0
				talkingui := 0
				completed := 0	
				gotourshi := 1	
				otherurshi := 0	
				receivedfailed := 0	
				pausestart := 0
				idled := 0
				idledtries := 0
				exited := 0	
				WriteLog("riftacceptbutton received: but paused = 0")
			}
				
		}
		
		   
		IfInString, controlText, start
		{			
			WriteLog("start received")
			if (paused = 1){	
				paused := 0
				SendInput, {F6}	
				WriteLog("F6 start received:starting")
			}
		}
		
		
		IfInString, controlText, idlecounter
		{
			didurshi := 0
			talkingui := 0
			completed := 0
			otherurshi := 0	
			gotourshi := 1
			GR := 0
			failed1 := 0
			failed2 := 0
			idled := 0
			idledtries := 0
			exited := 0
			receivedfailed := 0	
			paused := 0
			WriteLog("received idle reset")
		}

		IfInString, controlText, startros
		{
			WriteLog("startros received routine")
			Gosub, initial
			Gosub, DoUnBlockInput
			Sleep 1000
			if (paused = 1){							
				paused := 0
				SendInput, {F6}	
				WriteLog("startros received F6 unpausing")
			}			
			;Gosub, StartRos	
			WriteLog("startros received routine finished")
		}
		
		IfInString, controlText, close ui
		{
			SendInput, l	
			WriteLog("close ui receivbed")
		}
		
		IfInString, controlText, force init 0
		{
			pausestart := 0		
			WriteLog("force init 0 received")
		}
		
		IfInString, controlText, stop
		{			
			if (paused = 0){
				paused := 1
				SendInput, {F6}	
				WriteLog("F6 stop received")
			}
		}
		
		IfInString, controlText, necro did urushi
		{
			WriteLog("necro did urushi received")
			otherurshi := 1		
		}
		
		
		if (gotourshi = 1 and didurshi = 0){
			IfInString, controlText, necro have urushi
				{	
					WriteLog("necro have urushi received")
					gotourshi := 0
					if (paused = 0){							
						paused := 1
						SendInput, {F6}	
						WriteLog("F6 pausing")
					}		
					WriteLog("clicking teleport")
					Sleep 500
					c1 := teleport1[1]
					c2 := teleport1[2]
					MouseMove, %c1% , %c2%
					Sleep 50
					SendInput, {Click right down}
					Sleep 50
					SendInput, {Click right up}
					Sleep 200
					c1 := teleport2[1]
					c2 := teleport2[2]
					MouseMove, %c1% , %c2%	
					Sleep 50
					SendInput, {Click down}
					Sleep 50
					SendInput, {Click up}
					Sleep 5000	
					if (paused = 1){	
						paused := 0
						SendInput, {F6}	
						WriteLog("F6 unpausing")
					}
					WriteLog("necro have urushi routine finished")
				
			}
		}	
		
		
		IfInString, controlText, acceptgr
		{
			WriteLog("acceptgr received: clicking cancel")
			Sleep 500
			c1 := cancelgriftbutton[1]
			c2 := cancelgriftbutton[2]
			Click %c1% , %c2%    
			WriteLog("accept found: clicked cancel")
			StringSend := "cancelgrift"
			Gosub, SenderText
			WriteLog("accept found: sent cancelgrift")
		}
		
		IfInString, controlText, foundpool
			{	
				WriteLog("going to pool")
				Gosub, dopause
				Sleep 500
				c1 := teleport1[1]
				c2 := teleport1[2]
				WriteLog("clicking teleport")
				Sleep 50					
				Send {Click right %c1%, %c2%}
				Sleep 100
				c1 := teleport2[1]
				c2 := teleport2[2]
				Sleep 50
				Send {click %c1% , %c2%}
		}
		
		
		Thread, NoTimers, false
	}
	
	pingchecker:
	;	if(newTcp.sendText("Ping") = 0 and idled = 0)
	;	{
	;		Sleep 200
	;		if(newTcp.sendText("Ping") = 0 and idled = 0)
	;		{
	;			Sleep 200
	;			if(newTcp.sendText("Ping") = 0 and idled = 0)
	;			{
	;		
	;			 failed2 :=1 ;nao procurar pelo menu enabled normal
	;			 failed1 := 1 ;nao procurar por disconnection
	;			 WriteLog("TCP Disconnect ping detected paused: " paused)
	;			 if (paused = 0){
	;				paused := 1
	;				SendInput, {F6}               
	;				WriteLog("pausing")
	;			 }
	;			 WriteLog("logout attempt")
	;			 Gosub, FocusDiablo
	;			 Gosub, LeaveGame
	;			 Gosub, GoAlone
	;			}
	;		}
	;	}
	return
	
	
	\::	
		
			SetTimer, imagereader, off
			SetTimer, logreader, off
			SetTimer, idlewatcher, off
			SetTimer, pingchecker, off
			WriteLog("timers off key pressed")
		
	return	
	
	
	initial:

		global doleave := 0
		global paused := 0
		global justentered:=0				
		global doonce := 1
		global doonce2 := 2
		global didurshi := 0
		global gotourshi := 1
		global talkenter :=1
		global bosskilled := 0
		global StringSend := ""
		global talkingui := 0
		global completed := 0
		global accept := 0
		global otherurshi := 0		
		global failed1 := 0
		global receivedfailed := 0
		global pausestart := 1
		global GR := 0
		global exited := 1	
		global idled := 0
		global idledtries := 0
		global interactUi := 0
		global blockedinput := 0
		global foundpool := 0
		WriteLog("running init: starting timers")
		
		SetTimer, imagereader, 40,1
		SetTimer, logreader, 40,2
		SetTimer, idlewatcher, 30000
		;SetTimer, pingchecker, 30000

	return


	Tail(k,file)   ; Return the last k lines of file
	{
	   Loop Read, %file%
	   {
		  _i_ := Mod(A_Index,k)
		  L%_i_% = %A_LoopReadLine%
	   }
	   L := L%_i_%
	   Loop % k-1
	   {
		  IfLess _i_,1, SetEnv _i_,%k%
		  _i_--      ; Mod does not work here
		  L := L%_i_% "`n" L
	   }
	   Return L
	}
	
	imagereader:
		Thread, Interrupt, 0
	
		;;rift complete
		if (didurshi =1){
			pathpng := A_ScriptDir . grcomplete[5]
		    scale :=  "*w" . grcomplete[6] . " *h" . grcomplete[7]
            ImageSearch , GRCompleteX, GRCompleteY, grcomplete[1], grcomplete[2], grcomplete[3], grcomplete[4], *50 %scale% %pathpng%
			
			if (GRCompleteX > 0) ;and GRCompleteY > 0 and completed = 0)
			{		
				WriteLog("gr complete detected")
				sleep 2000
				SendInput, l
				receivedfailed := 0
				GR := 0
				failed1 := 0
				failed2 := 0
			}
		}
		
   
	;disconnected or timedout - ok - 
	if (blockedinput = 1 and failed1 = 1){
		pathpng := A_ScriptDir . inactivity[5]
		scale :=  "*w" . inactivity[6] . " *h" . inactivity[7]
		options := inactivity[8]
		ImageSearch , DiscX, DiscY, inactivity[1], inactivity[2], inactivity[3], inactivity[4], %options% %scale% %pathpng%
		if(DiscX > 0){
			WriteLog("imagereader disconnected or timedout")
			Gosub, DoUnBlockInput
			Sleep 500
			c1 := disconnectedbutton[1]
			c2 := disconnectedbutton[2]
			Click %c1% , %c2%
			Gosub, DoBlockInput
		}
	}
	 
	return
	
	str_getTail(_Str, _LineNum = 1)
	{
		StringGetPos, Pos, _Str, `n, R%_LineNum%
		StringTrimLeft, _Str, _Str, % ++Pos
		Return _Str
	}
	
	
	logreader:	
		Thread, Interrupt, 0
		;;urshi UI detect
		;;urshi UI detect	
		;FileRead, file, C:\Users\slayn\Documents\RoS-BoT\Logs\logs.txt
		;global chatstep := str_getTail(file, 25)
		
		global chatstep := Tail(20,logpath)		
		
		
		IfInString, chatstep, InteractWithUiAndWaitFor 
		{	
			IfNotInString, chatstep, RiftAcceptButton
			{	
			LogLock := 1
			interactUi := 1
			}
		}
		
		
		IfInString, chatstep, Running urshi...
		{	
			if (didurshi = 0){
				LogLock := 1				
				Gosub, FocusDiablo
				didurshi := 1
				bosskilled := 1
				gotourshi := 0
				objlook := 1
				talkingui := 1
				failed2 := 0
				paused := 0
				receivedfailed := 0
				pausestart := 1
				GR := 0
				WriteLog("running urshi... detected: send dh have urushi")
				StringSend := "dh have urushi"
				Gosub, SenderText
			}	
		}
		
		IfInString, chatstep, Upgrade gem
		{	
			if (didurshi = 0){
				LogLock := 1			
				Gosub, FocusDiablo
				didurshi := 1
				bosskilled := 1
				gotourshi := 0
				objlook := 1
				talkingui := 1
				failed2 := 0
				receivedfailed := 0
				pausestart := 1
				GR := 0
				paused := 0
				WriteLog("upgrade gem detected: send dh have urushi")
				StringSend := "dh have urushi"
				Gosub, SenderText
			}	
		}


		if(talkingui = 1 and didurshi = 1){
			IfInString, chatstep, Urshi to disappear
					{
					LogLock := 1
					talkingui := 0	
					StringSend := "dh have urushi and dh did urshi"	
					Gosub, SenderText					
					paused := 0
					failed2 := 0	
					GR := 0
					receivedfailed := 0
					pausestart := 1
			}
		}
		
		
	;open rift pause
	;IfInString, chatstep, start a loop
	;{			
	;	receivedfailed := 0
	;	if (pausestart = 1 and paused = 0){
	;		LogLock := 1	
	;		pausestart := 0					
	;		if (paused = 0){			
	;			paused := 1
	;			SendInput, {F6}	
	;			WriteLog("F6 from start a loop")
	;		}	
	;		WriteLog("star a loop detected: send iamready")	
	;		Sleep 2000
	;		StringSend := "iamready"
	;		Gosub, SenderText
	;		
	;	}
	;}
	
	IfInString, chatstep, vendor loop done
	{			
		receivedfailed := 0
		if (pausestart = 1 and paused = 0 and GR = 0){
			LogLock := 1	
			pausestart := 0					
			if (paused = 0){			
				paused := 1
				SendInput, {F6}	
				WriteLog("F6 from vendorloop")
			}	
			Sleep 3000
			WriteLog("vendor loop done detected: send iamready")
			StringSend := "iamready"
			Gosub, SenderText
		}
	}
	
	IfInString, chatstep, PoolOfReflection
	{
		if (foundpool = 0){
			Gosub, DoBlockInput
			StringSend := "foundpool"
			Gosub, SenderText
			Sleep 10000			
			Gosub, DoUnBlockInput
			foundpool := 1
		}
	}

	IfInString, chatstep, Launching TP
	{	
		foundpool := 0
		Sleep 2000
	}
	
	
	IfInString, chatstep, Runstep ended: CemeteryOfTheForsaken_XpPools
	{
		chatstep := "next rift in different"
		failed1 := 0 
		receivedfailed := 0
		exited := 0
	}
	
	IfInString, chatstep, next rift in different
	{	   
	   if (failed1 = 0 and receivedfailed = 0 and exited = 0){
			gosub, DoBlockInput
			LogLock := 1
			SendInput, {F4 down}
			Sleep 100
			SendInput, {F4 up}
			Sleep 1000
			WriteLog("next rift in different: f6 logout")
			;BlockInput, on
			Gosub, dopause
			failed1 := 1
			failed2++
			chatstep := "blank"
			StringSend := "failure"	
			Gosub, SenderText
			WriteLog("logout attempt")
			Gosub, LeaveGame
	   }
	}

	;IfInString, chatstep, disconnection
	;{
	;   
	;   if (failed1 = 0 and receivedfailed = 0 and exited = 0){
	;   
	;	  failed1 := 1
	;	  failed2 := 1
	;	  WriteLog("disconnection detected: f7 and send failure")
	;	  chatstep := "blank"
	;	  SendInput, {F7}  
	;	  WinActivate, Diablo III
	;	  Gosub, FocusDiablo
	;didurshi := 1	
	;	  newTcp2.sendText("failure")	
	;	  Gosub, FocusDiablo
	;	  Gosub, LeaveGame
	;	  Gosub, FocusDiablo
	;   }
	;}
	
	
	IfInString, chatstep, RiftAcceptButton
	{	
		if (GR = 0){
			WriteLog("riftacceptbutton chatstep")
			GR := 1
			failed1 := 0
			exited := 0
			interactUi := 1
			WriteLog("sending acceptgr")
			StringSend := "acceptgr"
			Gosub, SenderText
		}
	}

	IfInString, chatstep, g_Portal_Rectangle_Orange
	{	
		GR := 0
	}
	
	LogLock := 0
	
	return
	
		
	
	StartRos:
		Iniread, RosWintitle, variables.ini, Settings, RosWintitle
		Loop, 50{
			WinActivate, %RosWintitle%
			Sleep 500
			WinGetTitle, ActiveWin, A
			if (ActiveWin = RosWintitle){
				Sleep 500
				WinGetPos,rosX, rosY, rosW, rosH, %RosWintitle%		
				rosX += (rosW) - Round(90*(A_ScreenWidth/1920), 0)
				rosY += (rosH) - Round(30*(A_ScreenHeight/1080), 0)
				Click %rosX% , %rosY%
				Break
			}
		}
	return
	
	FocusDiablo:
		Loop, 50{
			WinActivate, Diablo III			
			WinGetTitle, ActiveWindow, A
			if (ActiveWindow = "Diablo III"){	
				Break
			}
		}
	return
	
	WriteLog(Text){   
	   global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
	   FileAppend,
	   (
	   %A_YYYY%-%A_MM%-%A_DD%(%A_Hour%h%A_Min%m%A_Sec%sec) %Text% p: %paused%

	   ), Multilog.txt
	   return
	}
	
	idlewatcher:
	   CurrenTime := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
	   secondsElapsed := Time(CurrenTime,LastLogWrite,"s")
	   if (secondsElapsed > 800 and failed1 = 0){  
		failed1 := 1
		failed2++
		WriteLog("idlewatcher: f7 and send failure")
		chatstep := "blank"
		if(paused =0){
			paused := 1
			SendInput, {F6}
			WriteLog("next rift in different: f6 pausing")
		}  
		WinActivate, Diablo III		  
		Gosub, FocusDiablo
		StringSend := "failure by idlewatcher"
		Gosub, SenderText
		Gosub, LeaveGame
		Gosub, FocusDiablo
	   }	   
	   if (secondsElapsed > 800 and failed2 = 3 ){
			WriteLog("idlewatcher com failed1: goingalone")
			Gosub, LeaveGame
			Gosub, GoAlone
	   }
	return

		
	LeaveGame:
		doleave := 1
		MouseMove, 0, 0
		Loop, 30 {
		    WriteLog("LEave game found: clicking leave game try:" a_index)
			Gosub, FocusDiablo
			SendInput, {Esc}
			Sleep 1300
			pathpng := A_ScriptDir . leavegame[5]
			scale :=  "*w" . leavegame[6] . " *h" . leavegame[7]
			options := leavegame[8]
			ImageSearch , LeaveGameX, LeaveGameY, leavegame[1], leavegame[2], leavegame[3], leavegame[4],  %options% %scale% %pathpng%
			if(LeaveGameX > 0) {
				c1 := leavegamebutton[1]
				c2 := leavegamebutton[2]
				SendInput, {F4 down}
 				Sleep 150
 				SendInput, {F4 up}
				Sleep 120
				MouseMove %c1% , %c2%
				Sleep 200
				SendEvent, {Click down}
				Sleep 200
				SendEvent, {Click up}
				Sleep 10200
				exited := 1
				doleave := 0
				WriteLog("LEave game found: clicking leave game and blocking input for 15 seconds")
				if (paused = 1){			
					paused := 0
					SendInput, {F6}	
					WriteLog("F6 unpausing: leave game detect imagereader and waited")
				}					
				Sleep 4500
				Gosub, DoUnBlockInput
				WriteLog("imagereader leave game")
				StringSend := "imonmenu"
				Gosub, SenderText
				talkenter := 0
				Gosub, initial
				Break
			}
			Sleep 200
		}
		if (doleave = 1){ ;couldnt leave			
			Gosub, DoUnBlockInput
			Sleep 50				
 			SendInput, {F4 down}
 			Sleep 100
 			SendInput, {F4 up}
			Sleep 50
			Gosub, dounpause
		}
	return
		
	return

	CancelGRift:
		Sleep 100
		SendInput, l
		Sleep 100
		pathpng := A_ScriptDir . cancelgrift[5]
		scale :=  "*w" . cancelgrift[6] . " *h" . cancelgrift[7]
		ImageSearch , CancelGRiftX, CancelGRiftY, cancelgrift[1], cancelgrift[2], cancelgrift[3], cancelgrift[4], *25 %scale% %pathpng%
		if (CancelGRiftX > 0){
			Loop, 200 {	
				ImageSearch , CancelGRiftX, CancelGRiftY, cancelgrift[1], cancelgrift[2], cancelgrift[3], cancelgrift[4], *25 %scale% %pathpng%
					if (CancelGRiftX > 0){
						Gosub, FocusDiablo	
						WriteLog("Cancel Grift found: clicking it")
						c1 := cancelbutton[1]
						c2 := cancelbutton[2]
						Click %c1% , %c2%		
						if (paused = 0){
							paused := 1
							SendInput, {F6}
							WriteLog("F6 pausing cancelbutton")
						}
						Break
					}
			}
		}
	return


		GoAlone:
		 idled := 0
	   Sleep 3000
		Gosub, DoUnBlockInput
		Sleep 2000		
	   WriteLog("waiting for menu to pop")
		i := 0
	   Loop, 200 {
		Sleep 40
		pathpng := A_ScriptDir . menu_start_disabled[5]
		scale :=  "*w" . menu_start_disabled[6] . " *h" . menu_start_disabled[7]
		ImageSearch , MenuDisabledX, MenuDisabledY, menu_start_disabled[1], menu_start_disabled[2], menu_start_disabled[3], menu_start_disabled[4], *35 %scale% %pathpng%
		  if (MenuDisabledX > 0 or MenuEnabledX > 0){
				Sleep 3000
				Break                  
		  }
	   }
		pathpng := A_ScriptDir . leaveparty[5]
		scale :=  "*w" . leaveparty[6] . " *h" . leaveparty[7]
		ImageSearch , LeavePartyX, LeavePartyY, leaveparty[1], leaveparty[2], leaveparty[3], leaveparty[4], *50 %scale% %pathpng% 
		  if (LeavePartyX >0){
			i := 0
			 Loop, 150 {
				WriteLog("leaving party")
				c1 := leavepartybutton[1]
				c2 := leavepartybutton[2]
				Click %c1% , %c2%
				Sleep 200
				pathpng := A_ScriptDir . leaveparty2[5]
				scale :=  "*w" . leaveparty2[6] . " *h" . leaveparty2[7]
				ImageSearch , LeaveParty2X, LeaveParty2Y, leaveparty2[1], leaveparty2[2], leaveparty2[3], leaveparty2[4], *50 %scale% %pathpng%
				if(LeaveParty2X > 0)
				{
					c1 := leavepartybutton2[1]
					c2 := leavepartybutton2[2]
					Click %c1% , %c2%
				   Sleep 1000
				   Break
				}
				Sleep 200
			 }
		  }
	   if (paused = 1){
		  paused := 0
		  SendInput, {F6}
		  WriteLog("F6 Idled too many detected: unpausing alone")
	   }   
	   WriteLog("Exiting after resume alone")
	   Sleep 1000
	   idled := 0
	   ExitApp	
	return
	
	AcceptGr:
		WriteLog("going to AcceptGr")
		c1 := acceptclick[1]
		c2 := acceptclick[2]
		Click %c1% , %c2%
		Sleep 1000
		pathpng := A_ScriptDir . acceptgr[5]
		scale :=  "*w" . acceptgr[6] . " *h" . acceptgr[7]
		ImageSearch , AcceptRiftX, AcceptRiftY, acceptgr[1], acceptgr[2], acceptgr[3], acceptgr[4], *50 %scale% %pathpng%
		if(AcceptRiftX > 0){
		  Loop, 200{
		  ImageSearch , AcceptRiftX, AcceptRiftY, acceptgr[1], acceptgr[2], acceptgr[3], acceptgr[4], *50 %scale% %pathpng%
			  if (AcceptRiftX > 0){
				c1 := acceptclick[1]
				c2 := acceptclick[2]
				Click %c1% , %c2%
				Break
			  }
		  }
		}
	return

	SenderText:
	   WriteLog("SendText: " StringSend)
	   sent := myClient.sendText(StringSend)
	   if (sent > 0)
	   {
		   WriteLog("sent: " StringSend " status: " sent)
	   }
	   else
	   {
		 Loop, 35 {
		   Sleep 200
		   WriteLog("send retrying: " StringSend " retry attempt: " a_index "status: " sent)               
		   sent := myClient.sendText(StringSend)
		   if (sent > 0){
			 WriteLog("retry send successful: " StringSend " retry: " a_index "status: " sent)
			 Break
		   }
		 }
		 if(sent = 0){
		   WriteLog("retry send FAILED: " StringSend " retries: " a_index "status: " sent)
		 }
		}
   return
   
    DoBlockInput:
		if(blockedinput = 0){
		  blockedinput := 1		  
		  BlockInput, on
		}
	return

	DoUnBlockInput:
		if(blockedinput = 1){
		  blockedinput := 0
		  BlockInput, off
		}   
	return

	ConvertCoordinates(ByRef Array)
	{
		DiabloWidth := A_ScreenWidth		
		DiabloHeight := A_ScreenHeight
		D3ScreenResolution := DiabloWidth*DiabloHeight

		Position := Array[9]

	;Pixel is always relative to the middle of the Diablo III window
		If (Position == 1){
			Array[1] := Round(Array[1]*DiabloHeight/1080+(DiabloWidth-1920*DiabloHeight/1080)/2, 0)
			Array[3] := Round(Array[3]*DiabloHeight/1080+(DiabloWidth-1920*DiabloHeight/1080)/2, 0)
		}

	  ;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
		If Else (Position == 2 || Position == 4){
			Array[1] := Round(Array[1]*(DiabloHeight/1080), 0)
			Array[3] := Round(Array[3]*(DiabloHeight/1080), 0)
		}

		;Pixel is always relative to the right side of the Diablo III window
		If Else (Position == 3){
			Array[1] := Round(DiabloWidth-(1920-Array[1])*DiabloHeight/1080, 0)
			Array[3] := Round(DiabloWidth-(1920-Array[3])*DiabloHeight/1080, 0)
		}

		Array[2] := Round(Array[2]*(DiabloHeight/1080), 0)
		Array[4] := Round(Array[4]*(DiabloHeight/1080), 0)
		
		Array[6] :=  Round(Array[6]*(DiabloWidth/1920), 0)
		Array[7] :=  Round(Array[7]*(DiabloHeight/1080), 0)
	
	
	}
	
	ConvertClick(ByRef Array)
	{
		DiabloWidth := A_ScreenWidth
		DiabloHeight := A_ScreenHeight
		D3ScreenResolution := DiabloWidth*DiabloHeight

		Position := Array[3]

		;Pixel is always relative to the middle of the Diablo III window
	  If (Position == 1){
		Array[1] := Round(Array[1]*DiabloHeight/1080+(DiabloWidth-1920*DiabloHeight/1080)/2, 0)
		}

	  ;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
	  If Else (Position == 2 || Position == 4){
			Array[1] := Round(Array[1]*(DiabloHeight/1080), 0)
		}

		;Pixel is always relative to the right side of the Diablo III window
		If Else (Position == 3){
			Array[1] := Round(DiabloWidth-(1920-Array[1])*DiabloHeight/1080, 0)
		}

		Array[2] := Round(Array[2]*(DiabloHeight/1080), 0)
	}
	
	dopause:
		if (paused = 0){
			paused := 1
			SendInput, {F6 down}
			Sleep 50
			SendInput, {F6 up}
			WriteLog("F6 pausing gosub")
		}
	return
	
	dounpause:
		if (paused = 1){
			paused := 0
			SendInput, {F6 down}
			Sleep 50
			SendInput, {F6 up}
			WriteLog("F6 pausing gosub")
		}
	return
