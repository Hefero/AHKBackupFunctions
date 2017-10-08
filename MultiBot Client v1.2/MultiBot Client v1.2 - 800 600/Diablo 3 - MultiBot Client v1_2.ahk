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
	
	IniRead, serverip, variables.ini, Settings, ServerIP
	IniRead, serverport, variables.ini, Settings, ServerPort
	IniRead, logpath, variables.ini, Settings, LogPath
	
	#include Time.ahk
	#include Socket.ahk
	
	
	global myServer := new SocketTCP()
	myServer.bind("addr_any", 69670)
	myServer.listen()
	myServer.onAccept := Func("OnTCPAccept")
	
	OnTCPAccept(this)
	{
		myServer := this.accept()
		myServer.onRecv := func("OnTCPRecv")
		WriteLog("connection accepted")
	}
	
	global riftopen := [287, 190, 457, 386, "\pngs\rift-open.png", 93, 118 , 65,2] 
	global cancelgrift := [1030, 340, 1130, 405, "\pngs\g2cancel.png", 78, 45, "*65 *TransBlack", 1,"*50 *TransBlack"]
	global menu_start_disabled := [223, 471, 414, 560, "\pngs\newmenu_start_disabled.png", 56, 44 , 25,2] 
	global leavegame := [1024, 955, 1092, 1000, "\pngs\esc_return.png", 45, 26, "*30 *TransBlack", 1] ; tbm funciona para logoutonmenu
	global logoutonmenu :=  [81, 454, 405, 514, "\pngs\newleavegame.png", 38, 42, 50,2] 
	global acceptgr := [780, 793, 1156, 864, "\pngs\newacceptgr.png", 70, 43 , "*35 *TransBlack",1]
	global leaveparty := [1618, 878, 1672, 925, "\pngs\newleaveparty.png", 16, 32 , 60,3]
	global leaveparty2 := [701, 567, 1216, 726, "\pngs\newleaveparty2.png", 410, 23 , 60,1] ; tbm funciona para inactivity
	
	
	global inactivity := [713, 388 1220, 700, "\pngs\newinactivity2.png", 424,79 , "*50 *TransBlack",1]
	
	global grcomplete := [722, 674, 872, 911, "\pngs\grcomplete.png" ,49 ,150,60,1]
	
	
	global teleport1 := [62 , 247,2]
	global teleport2 := [170, 390,2]
	global acceptclick := [961, 810,1]
	global cancelbutton := [1061, 375,1]
	global leavegamebutton := [291, 484,2]
	global leavepartybutton := [1690, 900,2]
	global leaveparty2button := [860, 660,2]
	global disconnectedbutton := [ 962 , 661,1 ]
	
	global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
	
	ConvertClick(teleport1)
	ConvertClick(teleport2)
	ConvertClick(acceptclick)
	ConvertClick(cancelbutton)
	ConvertClick(leavegamebutton)
	ConvertClick(leavepartybutton)
	ConvertClick(leaveparty2button)
	ConvertClick(disconnectedbutton)
	
	
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
	
	
	WriteLog("Script Execution started")
	
	;Client

	WriteLog("Starting GUI")
	Gosub, #F1
	
	
	F11::		
		myClient := new SocketTCP()
		myClient.connect(serverip,serverport)	
		myClient.onRecv := func("OnTCPRecv")
	return
	
	F12::		
		StringSend := "testmsg"
		Gosub, SenderText	
	return
	
	
	
	OnTCPDisconnect(this)
	{
		WriteLog("TCP DIsconnected")
	}
	
	
	OnTCPRecv(this)
	{
		Thread, NoTimers, True
		Thread, Interrupt, -1
	
		controlText := this.recvText()
		
		IfNotInString, controlText, ping
		{
			WriteLog("message received: " controlText)
		}
		
		IfInString, controlText, testmsg
		{
			GuiControlGet, logtextapp,, logtext
			GuiControl, Text, logtext,%logtextapp%`nTest Msg Received: Successful Server Side Connection
		}
		
		
		if (gotourshi = 1 and didurshi = 0){
			IfInString, controlText, dh have urushi
				{	
					WriteLog("DH have urushi received")
					gotourshi := 0
					GR := 0
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
					Sleep 5000
					Gosub, dounpause
					WriteLog("DH have urushi routine finished")
					otherurshi := 1
					global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
			}
		}	
		IfInString, controlText, start
		{
			if (paused = 1){
				paused := 0
				SendInput, {F6}
				WriteLog("Start received")
			}
		}
		
		IfInString, controlText, iamready
		{
			otherurshi := 0
			if (paused = 1){
				paused := 0
				SendInput, {F6}
				WriteLog("F6 iamready: Starting")
			}
			WriteLog("iamready received")
			LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
		}
		
	
		IfInString, controlText, startros
		{
			WriteLog("Startros received")
			Gosub, dounpause
			Gosub, StartRos
			init()		
		}
		
		IfInString, controlText, pause
		{
			if (paused = 0){
				paused := 1
				SendInput, {F6}
				WriteLog("F6 pause received")
			}
		}
		
		IfInString, controlText, dh did urshi
		{
			WriteLog("dh did urshi received")
			otherurshi := 1
			GR := 0
		}
		
		IfInString, controlText, stop
		{		
			WriteLog("stop received")
			if (paused = 0){	
				paused := 1
				SendInput, {F6}
				WriteLog("F6 stop received: pausing")
			}
		}
		
		IfInString, controlText, failure
		{
			gosub, DoBlockInput
			receivedfailed := 1						
			chatstep := "blank"		
			SendInput, {F4 down}
			Sleep 100
			SendInput, {F4 up}
			Sleep 1000
			Gosub, dopause			
			WinActivate, Diablo III
			failed1 := 1				
			WriteLog("logout attempt")		
			Gosub, LeaveGame
			Gosub, FocusDiablo
			WriteLog("focus diablo")
			Gosub, FocusDiablo
		}
		
		IfInString, controlText, imonmenu
		{		
			Sleep 9500
			otheronmenu := 1
			WriteLog("imonmenu received")
			if (imonmenu = 1){						
				WriteLog("imonmenu received menu start enabled: block off")			
				Gosub, DoUnBlockInput	
				;StringSend := "startros"
				;Gosub, SenderText
				Sleep 1000									
				WriteLog("menu start enabled: unpausing F6")
				Gosub, dounpause
				WriteLog("menu start enabled: go init variables")					
				init()
			}
			
		}
		
		IfInString, controlText, cancelgrift
		{
			Gosub, FocusDiablo	
			WriteLog("Cancel Grift received: clicking it")
			Sleep 500
			c1 := cancelbutton[1]
			c2 := cancelbutton[2]
			Click %c1% , %c2%	
			failed1 := 0
			receivedfailed := 0		
			Gosub, dopause
			WriteLog("F6 pausing cancelbutton")
			Sleep 1500
			StringSend := "start"
			Gosub, SenderText
		}
		
		
		IfInString, controlText, acceptgr
		{
					Sleep 500
					c1 := acceptclick[1]
					c2 := acceptclick[2]
					Click %c1% , %c2%
					WriteLog("acceptgr received")
					entered := 1
					exited := 0
					wentback := 0
					uiclosed := 0
					uiopened := 0
					didurshi := 0
					bosskilled := 0
					talkingui := 0
					completed := 0	
					gotourshi := 1
					otherurshi := 0
					failed1 := 0
					failed2 := 0
					accept := 0
					receivedfailed := 0
					idled := 0
					idledtries := 0		
					Sleep 6000
					StringSend := "riftacceptbutton"
					Gosub, SenderText					
					paused := 0		
					SendInput, {F6}
					WriteLog("F6 start just sent, now unpausing")
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
		Sleep 8500
		SendInput, {t}
	}
	
	
	IfInString, controltext, g_portal
	{
		global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
		WriteLog("g_portal received")
	}
	
	
		Thread, NoTimers, False
	}
	
	pingconnection:
	;	if (myTcp.sendText("Ping") = 0 and idled = 0)
	;	{
	;		Sleep 200
	;		if (myTcp.sendText("Ping") = 0 and idled = 0)
	;		{
	;			Sleep 200
	;			if (myTcp.sendText("Ping") = 0 and idled = 0)
	;			{
	;				idled := 1
	;				failed2 :=1 ;nao procurar pelo menu enabled normal
	;				failed1 :=1 ;nao procurar por disconnected
	;				WriteLog("PING returned 0 (disconnection), paused: " paused)
	;				if (paused = 0){
	;					paused := 1
	;					SendInput, {F6}					
	;					WriteLog("pausing")
	;				}
	;				WriteLog("logout attempt")
	;				Gosub, LeaveGame
	;				Gosub, GoAlone
	;			}
	;		}
	;	}
	return
	
	sendstart:
		WriteLog("gosub send start passed: send start acc3pt")
		StringSend := "start idlecounter"
		Gosub, SenderText
		WriteLog("accept detected: send idlecounter")
	return

	
	#F9::	
			isOn := 1
			global imonmenu := 0
			global otheronmenu := 0
			global beginsequence := 1
			global paused := 0
			global exited := 0
			global justentered:=0		
			global doonce := 1
			global doonce2 := 2
			global didurshi := 0
			global gotourshi := 1
			global talkenter :=1
			global bosskilled := 0
			global talkingui := 0
			global loading := 0
			global objkill := 0
			global uiopened := 0
			global uiclosed := 0
			global StringSend := ""
			global entered := 0
			global wentback := 0
			global completed := 0
			global stopopen := 1
			global accept := 1
			global otherurshi := 1
			global failed1 := 0
			global failed2 := 0
			global receivedfailed := 0	
			global GR := 0	
			global idled := 0	
			global idledtries := 0
			global blockedinput := 0
			global foundpool := 0
			global endedpool := 0
			
			global StringSend := "StringSend Initialized"
			WriteLog("start button pressed")
			
			WinGetTitle, InitialWin, A
			global RosWinTitle := InitialWin			
			
			
			WriteLog("Connecting")		
			
			global myClient := new SocketTCP()
			myClient.connect(serverip,serverport)	
			myClient.onRecv := func("OnTCPRecv")
			Sleep 100
			testconn := myClient.sendText("testconnection")
			GuiControlGet, logtextapp,, logtext
			GuiControl, Text, logtext, %logtextapp%`nConnecting
			if (testconn > 5){
				WriteLog("starting timers")
				SetTimer, imagereader, 40 ,1
				SetTimer, logreader, 1,2	
				;SetTimer, pingconnection, 30000			
				SetTimer, idlewatcher, 30000, 3
				
				GuiControl, Text, logtext,%logtextapp%`nSucessfully Connected,`nGoing into background...
				Sleep 4000
				Gui, destroy
			}
			else {
				GuiControl, Text, logtext,%logtextapp%`nCouldnt connect. Try again.
			}
	return	
	
	F10::

	return
	
	Tail(k,file)   ; Return the last k lines of file
	{	   
	   Loop Read, %file%
	   {
		  Thread, interrupt, 0
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
	Thread, interrupt, 0
	
	;;rift complete	
		if (didurshi=1){
			pathpng := A_ScriptDir . grcomplete[5]
		    scale :=  "*w" . grcomplete[6] . " *h" . grcomplete[7]
            ImageSearch , GRCompleteX, GRCompleteY, grcomplete[1], grcomplete[2], grcomplete[3], grcomplete[4], *50 %scale% %pathpng%
			if (GRCompleteX > 0 ) {		
				Sleep 3000
				SendInput, l
				failed1 := 0
				failed2 := 0
				receivedfailed := 0
				GR := 0
				WriteLog("gr completed detected")
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
	
	init(){	
		WriteLog("Initializing Variables init function")
		global imonmenu := 0
		global otheronmenu := 0
		global doleave := 0
		global paused := 0
		global exited := 1
		global justentered:=0		
		global doonce := 1
		global doonce2 := 2
		global didurshi := 0
		global gotourshi := 1
		global talkenter :=1
		global bosskilled := 0
		global talkingui := 0
		global loading := 0
		global objkill := 0
		global uiopened := 0
		global uiclosed := 0
		global entered := 0
		global wentback := 0
		global completed := 0
		global stopopen := 1
		global accept := 1		
		global otherurshi := 1
		global failed1 := 0
		global receivedfailed := 0	
		global GR := 0	
		global idled := 0
		global idledtries := 0
		global blockedinput := 0
		global foundpool := 0
		global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
	}
	
	str_getTail(_Str , _LineNum = 1)
	{
		StringGetPos, Pos, _Str, `n, R%_LineNum%
		StringTrimLeft, _Str, _Str, % ++Pos
		Return _Str
	}
	
	
	logreader:	
		Thread, interrupt, 0		
		global chatstep := Tail(20,logpath)		
		
		IfInString, chatstep, Running urshi...
		{	
			if (didurshi = 0){
				LogLock := 1
				didurshi := 1
				talkingui := 1
				bosskilled := 1
				gotourshi := 0
				otherurshi := 1
				StringSend := "necro have urushi"
				Gosub, SenderText
				WriteLog("running urshi... detected: send necro have urushi")
				GR := 0
			}
		}
		IfInString, chatstep, Upgrade gem
		{	
			failed := 0
			if (didurshi = 0){
				LogLock := 1
				;;;ToolTip, Ui Urshi detected , 250 , 350, 3
				GR := 0
				didurshi := 1
				talkingui := 1
				bosskilled := 1
				otherurshi := 1
				gotourshi := 0
				WriteLog("upgrade gem detected: send necro have urushi")
				StringSend := "necro have urushi"
				Gosub, SenderText
			}
			
		}
		
		if(talkingui = 1 and paused = 0 and didurshi = 1){
			IfInString, chatstep, Urshi to disappear
					{
					GR := 0
					LogLock := 1
					otherurshi := 1
					;;;ToolTip, Ui closed chatstep detected , 250 , 350, 3	
					talkingui := 0				
					WriteLog("urshi to dissa detected: send necro have and did urushi")
					StringSend := "necro have urushi and necro did urushi"
					Gosub, SenderText
					global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
			}
		}

	IfInString, chatstep, PoolOfReflection
	{
		if (foundpool = 0){
			Gosub, DoBlockInput
			StringSend := "foundpool"
			Gosub, SenderText
			Sleep 7000			
			Gosub, DoUnBlockInput
			foundpool := 1
		}
	}
	
	IfInString, chatstep, g_portal
	{
		global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
		StringSend := "g_portal"
		Gosub, SenderText
		Sleep 5000
	}

	IfInString, chatstep, Launching TP
	{
		foundpool := 0
		Sleep 2000
	}

	IfInString, chatstep, Runstep ended: CemeteryOfTheForsaken_XpPools
	{
		if (endedpool != 1){
			    endedpool := 1
				StringSend := "go to menu"
				Gosub, SenderText
				Sleep 5000
				Gosub, dounpause
				init()
				Sleep 5000
				Gosub, DoUnBlockInput
			}
	}

	;;menu detector (failed)
	
	IfInString, chatstep, next rift in different
	{
		
		if (failed1 = 0 and receivedfailed = 0 and exited = 0){
			gosub, DoBlockInput
			LogLock := 1
			chatstep := "blank"				
			SendInput, {F4 down}
 			Sleep 100
 			SendInput, {F4 up}
 			Sleep 1000
			;BlockInput, on	
			Gosub, dopause
			WriteLog("next rift in different: f6 logout")			
			failed1 := 1
			failed2++
			WriteLog("send go to menu")
			StringSend := "go to menu"
			Gosub, SenderText
			WriteLog("logout attempt")
			Gosub, LeaveGame
			Gosub, FocusDiablo
		}
	}
	
	;IfInString, chatstep, disconnection
	;{
	;	
	;	if (failed1 = 0 and receivedfailed = 0 and exited = 0){
	;		exited := 1
	;		chatstep := "blank"					
	;		SendInput, {F7}
	;		WinActivate, Diablo III
	;		Gosub, FocusDiablo
	;		WriteLog("disc: f7")
	;		chatstep := "blank"
	;		failed1 := 1
	;		StringSend := "go to menu"
	;		Gosub, SenderText
	;		Gosub, FocusDiablo
	;		WriteLog("logout attempt")
	;		Gosub, LeaveGame
	;		Gosub, FocusDiablo
	;	}
	;}
	
	IfInString, chatstep, RiftAcceptButton
	{
		if (GR = 0) {
			LogLock := 1
			WriteLog("riftacceptbutton chatstep")
			GR := 1
			idled := 0
			accept := 1
			if (paused = 0){
				paused := 1
				SendInput, {F6}
				WriteLog("F6 pausing riftacceptbutton")
			}
			Sleep 1500
			WriteLog("send acceptgr (do cancel)")
			StringSend := "acceptgr"
			Gosub, SenderText			
		}
	}
	
	IfInString, chatstep, g_Portal_Rectangle_Orange
	{
		GR := 0
	}

	IfInString, chatstep, vendor loop done	
	{
		accept := 1
		endedpool := 0
		if (otherurshi = 1){		
			LogLock := 1
			WriteLog("Vendor loop done and otherurshi =1")
			Gosub, dopause
			WriteLog("F6 pausing vendor loop done")
			
			otherurshi := 0
			if(beginsequence = 0){
				Sleep 1500
				StringSend :=  "start"
				Gosub, SenderText			
				WriteLog("sent start from vendorloop done")
			}
		}	
		if(beginsequence = 1){
			Sleep 1500
			beginsequence := 0
			WriteLog("send beginsequence")
			StringSend := "beginsequence"			
			Gosub, SenderText		
		}
	}
	
	
	LogLock := 0
		
	return
	

	StartRos:		
		Loop, 50 {
			WinActivate, %RosWinTitle%
			Sleep 200
			WinGetTitle, ActiveWin, A
			if (ActiveWin = RosWinTitle){
				Sleep 200
				SendInput, {Space}
				Break
			}
		}
	return
	
	FocusDiablo:			
		Loop, 50 {
			WinActivate, Diablo III
			WinGetTitle, ActiveWindow, A
			if (ActiveWindow = "Diablo III"){
				Break
			}
		}
	return
	
	
	
	
	
	WriteLog(Text){  
	
	   
	   FileAppend,
	   (
	   %A_YYYY%-%A_MM%-%A_DD%(%A_Hour%h%A_Min%m%A_Sec%sec) %Text% p: %paused%

	   ), Multilog.txt
	   return
	}
	
	idlewatcher:
		Thread, interrupt, -1
		CurrenTime := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
		secondsElapsed := Time(CurrenTime,LastLogWrite,"s")
		if (secondsElapsed > 200 and failed1 = 0){		
			chatstep := "blank"					
			if(paused = 0){
				paused := 1
				SendInput, {F6}
				WriteLog("pause f6 idlewatcher")
			}
			WinActivate, Diablo III
			Gosub, FocusDiablo
			WriteLog("idle watcher detected disc: f6")
			chatstep := "blank"
			failed1 := 1
			failed2++
			StringSend := "go to menu"
			Gosub, SenderText
			WriteLog("send go to menu")
			Gosub, FocusDiablo
			WriteLog("logout attempt")
			Gosub, LeaveGame
			WinActivate, Diablo III
		}
		if (secondsElapsed > 200 and failed2 = 3){
			WriteLog("idlewatcher: com failed1 =1, goingalone")
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
				Sleep 9200
				exited := 1
				doleave := 0
				imonmenu := 1
				WriteLog("LEave game found: clicking leave game and blocking input")
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
	
	CancelGRift:
		WriteLog("Cancel Grift Sub Requested")
		Sleep 100
		pathpng := A_ScriptDir . cancelgrift[5]
		scale :=  "*w" . cancelgrift[6] . " *h" . cancelgrift[7]
		ImageSearch , CancelGRiftX, CancelGRiftY, cancelgrift[1], cancelgrift[2], cancelgrift[3], cancelgrift[4], *25 *TransFF4500 %scale% %pathpng%
		if (CancelGRiftX > 0){
			Loop, 200 {	
				ImageSearch , CancelGRiftX, CancelGRiftY, cancelgrift[1], cancelgrift[2], cancelgrift[3], cancelgrift[4], *25 *TransFF4500 %scale% %pathpng%
					if (CancelGRiftX > 0){
						Gosub, FocusDiablo	
						WriteLog("Cancel Grift found: clicking it")
						c1 := cancelbutton[1]
						c2 := cancelbutton[2]
						Click %c1% , %c2%		
						Gosub, dopause
						Break
					}
			}
		}
		accept := 1	
		failed1 := 0
		receivedfailed := 0		
		StringSend := "start"
		Gosub, SenderText
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
		ImageSearch , MenuDisabledX, MenuDisabledY, menu_start_disabled[1], menu_start_disabled[2], menu_start_disabled[3], menu_start_disabled[4], *25 %scale% %pathpng%
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
		Thread, NoTimers, True
		Thread, Interrupt, -1
	   WriteLog("SendText: " StringSend)
		sent := myClient.sendText(StringSend)
	   if (sent > 0)
	   {
			 WriteLog("sent: " StringSend " status: " sent)
	   }
	   else
	   {
		  Loop, 35 {
				myClient.connect(serverip,serverport)
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
		global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
		Thread, NoTimers, False
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
		BlockInput,off
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
			Thread, NoTimers, True
			if (paused = 0){
				paused := 1
				SendInput, {F6 down}
				Sleep 100
				SendInput, {F6 up}
				WriteLog("F6 dopause gosub")
			}
			Thread, NoTimers, False
	return
	
	dounpause:
			Thread, NoTimers, True
			if (paused = 1){
				paused := 0
				SendInput, {F6 down}
				Sleep 100
				SendInput, {F6 up}
				WriteLog("F6 doUnpause gosub")
				global LastLogWrite := A_YYYY A_MM A_DD A_Hour A_Min A_Sec
			}
			Thread, NoTimers, False
	return	
	
	#F1::
		Gui, Add, Text, x27 y24 w60 h20 , Server IP
		Gui, Add, Text, x27 y64 w60 h20 , Server Port
		Gui, Add, Text, x27 y104 w60 h20 , Path to Log		
		Gui, Add, Edit, x117 y24 w140 h20 vserverip , %serverip%
		Gui, Add, Edit, x117 y64 w100 h20 vserverport , %serverport%
		Gui, Add, Edit, x117 y104 w250 h20 vlogpath , %logpath%
		Gui, Add, GroupBox, x17 y4 w420 h140 ,
		Gui, Add, GroupBox, x17 y154 w420 h170 , Log
		Gui, Add, Text, x27 y174 w400 h140 vlogtext , Multibot Client Started
		Gui, Add, Button, x57 y334 w100 h30 gdoconnect , Connect
		Gui, Add, Button, x277 y334 w100 h30 , Exit
		Gui, Add, Button, x382 y99 w45 h30 gdochoose , Choose
		Gui, Show, w462 h383, MultiBot Client
	return
	
	    
	dochoose:
		FileSelectFile, fileselected
		GuiControl, Text, logpath, %fileselected%
	return
	
	doconnect:
		Gui, submit, NoHide
		IniWrite, %serverip%, variables.ini, Settings, ServerIP
		IniWrite, %serverport%, variables.ini, Settings, ServerPort
		IniWrite, %logpath%, variables.ini, Settings, LogPath
		gosub, #F9
	return

	~F6::
		paused := !paused
	return
