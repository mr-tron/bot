#Include <File.au3>
#Include <AutoFeed.au3>

Func GetItemPos($i)
	Local $pos[2]
	Local $p = _ArraySearch($base_xy, "Первый итем")
 	$col = Mod($i - 1, 5)
	$row = Floor(($i-1)/5)
	$pos[0] = $base_xy[$p][1] + $col*$isize[0]
	$pos[1] = $base_xy[$p][2] + $row*$isize[1] 
	Return $pos;
EndFunc

Func ClickB($bname, $allscr = false, $scroll = true)
	Local $p = FindBmp($bname, $allscr, $scroll)
	if $p = 0 then
;~ 		_FileWriteLog($logpath, "Не найдены координаты для = "&$bname)
		Return False
	Else
		MouseClick("left", $p[0], $p[1])
		Return True
	EndIf
EndFunc

Func ClickB0($bname, $cqty = 1); кликаем кнопку с указанным наименованием cqty раз
	Local $p = _ArraySearch($base_xy, $bname)
	if $p >= 0 Then 
		if $cqty > 0 then	MouseClick("left", $base_xy[$p][1], $base_xy[$p][2], $cqty)
	EndIf
EndFunc
	
Func ClickP($x, $y, $scroll = true)
	MoveMouse($x, $y, 0, 0, $scroll)
	MouseClick("left")
EndFunc

Func CreateProviant($resname = 'Уха', $qty = 10)
	Sleep(200)
	ClickB("Провиант3"); выбираем провиантлагерь
	ClickB0($resname)
	Sleep(200)
	ClickB0('Ресурс + 1', $qty)
	Sleep(200)
	ClickB0('ОкПровиант')
	Sleep(200)
	ClickB0('ЗакрытьПровиант')
	Sleep(200)
EndFunc

Func SelectBuild($bi)
	Local $ret = false
	if ClickB("Постройки"&($build_b[$bi][0]), true, false) Then
		Sleep(500)
		if ClickB("Строить"&$build_b[$bi][3], false, false) then
			Sleep(200)
			Return True;
		else
			ClickB("ЗакрытьПостройки", false, false)
		Endif
	else
	EndIf
	Return $ret
EndFunc

Func BuildOfType($buildtype)
	Local $buildid = _ArraySearch($build_b, $buildtype, 0, 0, 0, 3)
	Local $p = FindBmp($build_b[$buildid][1])
	if $p = 0 Then
		if $build_b[$buildid][2] <> '0' then $p = FindBmp($build_b[$buildid][2])
	EndIf
	if $p <> 0 Then
		if SelectBuild($buildid) then
			Sleep(200)
			ClickP($p[0], $p[1], false)            ; кликаем по координате и строим здание
			Sleep(200)
			Return True;
		Endif
	Endif
	Return False;
EndFunc

Func Build($buildtype, $times = 3)
	For $t = 1 to $times
		$builded = BuildOfType($buildtype)
		if not $builded then ExitLoop
	Next
	Return $builded
EndFunc

;~ Пробафать все здания указанного типа указанной бафалкой
Func BuffAll($buildtype, $bufftype = 12, $qty = 100)
	Local $p = FindBmp($buildtype)
	Local $cnt = 0
	while ($p <> 0) and ($cnt < $qty)
		ActivateStarTab(3)     ; активируем вкладку бафов
		If Not SelectSlot($bufftype) Then
			If $verbose Then Err('Не найден баф') 
			Return
		EndIf
		ClickP($p[0], $p[1], false)
		Sleep(1000)
		$p = FindBmp($buildtype)
		$cnt = $cnt + 1
	WEnd
EndFunc

Func ScrollNext()
	MouseMove($clientCenter[0] - 150, $clientCenter[1])
	MouseDown("left")
	MouseMove($clientCenter[0] - 150, $clientCenter[1]-200)
	MouseUP("left")
	$cur_scroll[0] = 0
	$cur_scroll[1] = $cur_scroll[1] + 200
EndFunc

Func FindBmp($name, $allscr = false, $scroll = true)
	Local $bid = _ArraySearch($bitmaps, $name, 0, 0, 0, 0)
	if $bid = -1 Then 
		if $verbose then Err("Не найден битмап с именем: "&$name)
		Return 0
	EndIF
	Local $p
	if $allscr then
		$p = BitmapSearch($bitmaps[$bid][1])
	else
		$p = BitmapSearch($bitmaps[$bid][1], $clientPos[0] + 20 , $clientPos[1] + 50, $clientPos[0] + $clientPos[2] - 150 , $clientPos[1] + $clientPos[3] - 50, 0, 1, $clientWindow)
	Endif
	if $p = 0 Then
		if $scroll then
			if $cur_scroll[0] <> 0 or $cur_scroll[1] <> 0 then 
				GoToZeroPt()
			Else
				ScrollNext()
			Endif
			if $allscr then
				$p = BitmapSearch($bitmaps[$bid][1])
			else
				$p = BitmapSearch($bitmaps[$bid][1], $clientPos[0] + 20 , $clientPos[1] + 50, $clientPos[0] + $clientPos[2] - 100 , $clientPos[1] + $clientPos[3] - 50, 0, 1, $clientWindow)
			Endif
		Endif
		if $p = 0 Then Return $p
	Endif
	$p[0] = $p[0] + 2 
	$p[1] = $p[1] + 2
	Return $p
EndFunc

Func StartGame()
	AutoItSetOption("WinTitleMatchMode", 2)
	$clWnd = WinGetHandle("Siedler", "")
	if $clWnd = 0 then
		Run($runpath) ; стартуем браузер
	Else
		ActivateClient()  ; Да. Такое тело...
		Return
	Endif
	;Ждем загрузки главной страницы
	Local $wcnt = 0
	while $clWnd = 0
		$clWnd = WinGetHandle("Siedler", "")
		Sleep(1000)
		$wcnt = $wcnt + 1
		if $wcnt > 60*5 then 
;~ 			Если не дождались загрузки, выходим
			Return
		EndIf
	WEnd
	Sleep(3000)
	$clientPos = WinGetPos($clWnd, "")
	$wcnt = 0
	Local $p = 0
	while $p = 0 
		Sleep(1000)
		MouseMove($clientPos[0] + 10 ,$clientPos[1] + 10)
		; если нашли кнопку авторизации жмем ее и авторизуемся
		if ClickB("Логин", true, false) then
			MouseMove($clientPos[0] + 10 ,$clientPos[1] + 10)
			Sleep(100)
			Local $pp = FindBmp('Ввод логина', true, false)			
			if $pp = 0 then return false
			ClickB('Ввод логина', true, false)
			Sleep(200)
			Send($login, 1)
			Sleep(200)
			MouseClick("left", $pp[0], $pp[1]+45);ClickB('Ввод пароля')
			Sleep(200)
			MouseClick("left", $pp[0], $pp[1]+45);ClickB('Ввод пароля')
			Sleep(200)
			Send($passwd, 1)
			Sleep(200)
			ClickB('Авторизация', true, false)
			Sleep(3000)
		EndIf
		ClickB('Вход в игру', true, false)
		$p = FindBmp("ОкСтарт", true, false)
		$wcnt = $wcnt + 1
		if $wcnt > 60*5 then 
;~ 			Если не дождались загрузки, выходим
			Return
		EndIf
	WEnd
	MouseMove($clientPos[0] + 30 ,$clientPos[1] + 30)
	while not ClickB('ОкСтарт', true, false) 
		Sleep(1000)
		; отводим мышку, чтобы гарантированно не загараживала битмапы
		MouseMove($clientPos[0] + 10 ,$clientPos[1] + 10)
	Wend
	Sleep(4000)
	Return True
EndFunc

Func Search($resname, $times)
	Local $count = 0
	Local $searcher = 17 ; геолог
	if $resname = "Сокровища" then $searcher = 16 ; разведчик
	While ($times == '*') Or ($count < $times )
		ActivateStarTab(2)     ; активируем вкладку специалистов
		If Not SelectSlot($searcher) Then
			If $verbose Then Err('Не найдено свободных искателей') 
			Return
		EndIf
		Sleep(400)
		ClickB('Искать'&$resname)
		Sleep(400)
		if $searcher = 17 then
			ClickB("РесурсОк")
		else
			ClickB("Искать сокровища Ок")
		endif
		Sleep(200)
		$count = $count + 1 
	WEnd
EndFunc

if $autologin Then
	if StartGame() then	ActivateClient()
ElseIf $autoactivate Then
	ActivateClient()
EndIf