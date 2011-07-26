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
;~ 		if $logpath <> '' then _FileWriteLog($logpath, "Не найдены координаты для = "&$bname)
		Return False
	Else
		MouseClick("left", $p[0], $p[1])
		Return True
	EndIf
EndFunc

Func ClickB0($bname, $cqty = 1, $dx = 0, $dy = 0); кликаем кнопку с указанным наименованием cqty раз
	Local $p = _ArraySearch($base_xy, $bname)
	if $p >= 0 Then 
;~ 	_FileWriteLog($logpath, "$base_xy[$p][1] + $dx = "&($base_xy[$p][1] + $dx))
;~ 	_FileWriteLog($logpath, "$base_xy[$p][2] + $dy = "&($base_xy[$p][2] + $dy))
		if $cqty > 0 then	MouseClick("left", $base_xy[$p][1] + $dx, $base_xy[$p][2] + $dy, $cqty)
		if $cqty > 1 then Sleep(100*$cqty)
	EndIf
EndFunc
	
Func ClickP($x, $y, $scroll = true)
	MoveMouse($x, $y, 0, 0, $scroll)
	MouseClick("left")
EndFunc

Func CreateProviant($resname = 'Уха', $qty = 10)
	Sleep(200)
	if ClickB("Провиант3") then; выбираем провиантлагерь
		$bookmark = 1;
		if ($resname = 'Корм для рыб') or ($resname = 'Корм для животных') Then
			$bookmark = 2
		elseif ($resname = 'Инструменты') or ($resname = 'Золото') or ($resname = 'Поселенцы') Then
			$bookmark = 3
		Endif
		ClickB0("ЗакладкаП"&$bookmark)
		Sleep(200)
		ClickB0($resname)
		Sleep(200)
		if $qty > 1 then ClickB0('Ресурс + 1', $qty-1)
		Sleep(200)
		ClickB0('ОкПровиант')
		Sleep(200)
		ClickB0('ЗакрытьПровиант')
		Sleep(200)
		MouseMove($clientPos[0] + Round($clientPos[2] / 2), $clientPos[1] + 100)
		Sleep(200)
		MouseClick('left')
		Sleep(200)
	Else
		AddLog('Не найден провиант 3-го уровня')
	Endif
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

Func BuildOnPoint($x, $y, $buildtype)
	Local $buildid = _ArraySearch($build_b, $buildtype, 0, 0, 0, 3)
	if SelectBuild($buildid) then
		Sleep(200)
		ClickP($x, $y, true)            ; кликаем по координате и строим здание
		Sleep(1000)
		Return True;
	Endif
	Return False;
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
			Sleep(1500)
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

Func ParseTime($value)
	$res = StringRegExp($value, '[0-9]{1,4}', 3)
	if not IsArray($res) Then
		if $verbose Then
			Err("Неверно задан формат времени: "&$value);
		EndIf
		Return 5*60*1000;
	EndIf
	if UBound($res) = 1 Then
		;Указаны только минуты
		Return 60*int($res[0])*1000
	elseif UBound($res) = 2 Then
		; указаны минуты и секунды
		Return int($res[0])*60*1000 + int($res[1])*1000
	elseif UBound($res) = 3 Then
		; указаны минуты, секунды и милисекунды (хз зачем)
		Return int($res[0])*60*1000 + int($res[1])*1000 + int($res[2])
	Else
		; указана неведомая хрень
		if $verbose Then
			Err("Неверно задан формат времени: "&$value);
		EndIf
		Return 5*60*1000;
	EndIf
EndFunc

Func BuildAll($buildtype, $timer = '')
	Local $waittime = 5*60*1000
	if $timer <> '' Then
		$waittime = ParseTime($timer)
	elseif $buildtype = "Поле" Then
		$waittime = ((1*60+10)*1000)
	elseif $buildtype = "Родник" Then
		$waittime = ((1*60+40)*1000)
	EndIf
;~ 	ConsoleWrite("$waittime = "&$waittime)
	while Build($buildtype, 1)
		Sleep(2000)
		Build($buildtype, 1)
		Sleep($waittime)
	wend
EndFunc

Func CloseStar()
	if IsStarOpened() Then
		MouseMoveToStar()
		MouseClick("left")
	EndIf
EndFunc

;~ Пробафать все здания указанного типа указанной бафалкой
Func BuffAll($buildtype, $bufftype = 12, $qty = 100)
	Local $p = FindBmp($buildtype)
	Local $cnt = 0
	while ($p <> 0) and ($cnt < $qty)
		Sleep(200)
		BuffPoint($p[0], $p[1], $bufftype, false)
		ClickB("Отменить", true, false)
		Sleep(300)
		MouseMove($clientPos[0] + Round($clientPos[2] / 2), $clientPos[1] + 100)
		Sleep(1000)
		$p = FindBmp($buildtype)
		$cnt = $cnt + 1
	WEnd
	CloseStar()	
EndFunc

Func BuffPoint($x, $y, $bufftype = 12, $scroll = true)
	ActivateStarTab(3)     ; активируем вкладку бафов
	If Not SelectSlot($bufftype) Then
		If $verbose Then Err('Не найден баф') 
		CloseStar()
		Return
	EndIf
	ClickP($x, $y, $scroll)
	Sleep(500)
EndFunc

Func ScrollNext()
	MouseMove($clientCenter[0] - 150, $clientCenter[1])
	MouseDown("left")
	MouseMove($clientCenter[0] - 150, $clientCenter[1]-200)
	MouseUP("left")
	$cur_scroll[0] = 0
	$cur_scroll[1] = $cur_scroll[1] + 200
EndFunc

Func FindBmp($name, $allscr = false, $scroll = true, $range = 0)
	Local $bid = _ArraySearch($bitmaps, $name, 0, 0, 0, 0)
	if $bid = -1 Then 
		if $verbose then Err("Не найден битмап с именем: "&$name)
		Return 0
	EndIF
	Local $p
	if $allscr then
		if IsArray($range) then
			$p = BitmapSearch($bitmaps[$bid][1], $range[0], $range[1], $range[2], $range[3])
		else
			$p = BitmapSearch($bitmaps[$bid][1])
		Endif
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
				if IsArray($range) then
					$p = BitmapSearch($bitmaps[$bid][1], $range[0], $range[1], $range[2], $range[3])
				else
					$p = BitmapSearch($bitmaps[$bid][1])
				Endif
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

;Поиск закончившихся месторождений
Func FindEndMines($name)
	Local $bid = -1
	if $name = 'Железная руда' or $name = 'Медная руда' Then
		$bid = _ArraySearch($bitmaps, 'Шахта', 0, 0, 0, 0)
	ElseIf $name = 'Камень' or $name = 'Мрамор' Then
		$bid = _ArraySearch($bitmaps, 'Камень', 0, 0, 0, 0)
	Endif
	if $bid = -1 Then 
		if $verbose then Err("Не найден битмап с именем: "&$name)
		Return 0
	EndIF
	Local $found = 0
	; left top right bottom
	Local $rect[4] = [$clientCenter[0],0,$clientPos[0] + $clientPos[2],0]
	Local $p = _ArraySearch($base_xy, "ЗакрытьШахту")
	$rect[1] = $base_xy[$p][2] - 50
	$p = _ArraySearch($base_xy, "ЗакрытьРазрушеннуюШахту")
	$rect[3] = $base_xy[$p][2] + 50 
	For $i = 0 to UBound($deposits, 1) - 1
		if $deposits[$i][4] = $name then
			ClickP($deposits[$i][1], $deposits[$i][2])
			Sleep(300)
			Local $p = FindBmp("ЗакрытьПостройки", true, false, $rect)
			if $p <> 0 then
				MouseClick("left", $p[0], $p[1])
				if $p[1] > $rect[3] - 60 then
					if Search($name, 1) = 0 then return -1;
					AddLog("Поиск ресурсов "&$name)
					$found += 1;
				Endif
			EndIf
		Endif
	Next
	Return $found;
EndFunc

Func StartNewServer()
	Sleep(200)
	MouseMove($clientPos[0] + 360 ,$clientPos[1] - 10)
	MouseClick("left")
	Sleep(100)
	Send("www.diesiedleronline.de/game/testing.php", 1)
	Send("{ENTER}")
	while not ClickB('ОкСтартБета', true, false) 
		Sleep(10000)
		; отводим мышку, чтобы гарантированно не загараживала битмапы
		MouseMove($clientPos[0] + 10 , $clientPos[1] + 10)
		if FindBMP('Вход в игру', true, false) <> 0 Then
			MouseMove($clientPos[0] + 360 ,$clientPos[1] - 10)
			MouseClick("left")
			Sleep(100)
			Send("www.diesiedleronline.de/de/spielen", 1)
			Send("{ENTER}")
			Sleep(1000)
			Return False
		Endif
	Wend
	Sleep(4000)
	Return true;
EndFunc

Func StartGame()
	AutoItSetOption("WinTitleMatchMode", 2)
	$clWnd = WinGetHandle("Online", "")
	if $clWnd = 0 then
		Run($runpath) ; стартуем браузер
	Else
		ActivateClient()  ; Да. Такое тело...
		Return True
	Endif
	;Ждем загрузки главной страницы
	Local $wcnt = 0
	while $clWnd = 0
		$clWnd = WinGetHandle("Online", "")
		Sleep(1000)
		$wcnt = $wcnt + 1
		if $wcnt > 60*5 then 
;~ 			Если не дождались загрузки, выходим
			Return False
		EndIf
	WEnd
	Sleep(3000)
	$clientPos = WinGetPos($clWnd, "")
	$wcnt = 0
	Local $p = 0
	while $p = 0 
		Sleep(2000)
		MouseMove($clientPos[0] + 10 ,$clientPos[1] + 10)
		; если нашли кнопку авторизации жмем ее и авторизуемся
		if ClickB("Логин", true, false) then
			MouseMove($clientPos[0] + 10 ,$clientPos[1] + 10)
			Sleep(100)
			Local $pp = FindBmp('Ввод логина', true, false)			
			if $pp = 0 then AddLog("Не найден элемент Ввод логина")
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
			Return False
		EndIf
	WEnd
	MouseMove($clientPos[0] + 30 ,$clientPos[1] + 30)
	while not ClickB('ОкСтарт', true, false) 
		Sleep(2000)
		; отводим мышку, чтобы гарантированно не загараживала битмапы
		MouseMove($clientPos[0] + 10, $clientPos[1] + 10)
	Wend
	Sleep(4000)
	Return True
EndFunc

Func Search($resname, $times = '*')
	Local $count = 0
	Local $searcher = GetSlotTypeForTaskTarget($resname, "");
	Local $stype = "Геолог"
	Local $rtype = "Карта"
	if $resname = "Сокровища" then $resname = $resname&"1"
	if not IsArray($searcher) then $stype = "Разведчик"
	if StringInStr($resname, "Сокровища") > 0 Then $rtype = "Сокровища"
	While ($times == '*') Or ($count < $times )
		ActivateStarTab(2)     ; активируем вкладку специалистов
		Sleep(1000)
		If Not SelectSlot($searcher, false) Then
			If $verbose Then Err('Не найдено свободных искателей') 
			CloseStar()	
			Return $count
		EndIf
		Sleep(400)
		if $stype = "Разведчик" then
			ClickB0($rtype)
			Sleep(400)
			ClickB0($resname)
		else
			ClickB('Искать'&$resname)
		endif
		Sleep(400)
		if $stype = "Геолог" then
			ClickB("РесурсОк")
		else
			ClickB("Искать сокровища Ок")
		endif
		Sleep(200)
		$count = $count + 1 
	WEnd
	CloseStar()	
	Return $count
EndFunc

if $autologin Then
	if StartGame() then	ActivateClient()
ElseIf $autoactivate Then
	ActivateClient()
EndIf

#Include <trade.au3>
#Include <messages.au3>
