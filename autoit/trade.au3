
; -------------------------------------------------------------------------------------------
; Торговля
; -------------------------------------------------------------------------------------------

;~ #Include <Array.au3>
;~ #Include <vars.au3>
;~ Торговать на рынке
Func TradeHandle($myitem, $hisitem, $myqty, $hisqty)
	Sleep(200)
	ClickB0('Чат', false, false)
	if $myitem = "" then return
	Sleep(200)
	ClickB("Рынок", false, false)
	Sleep(200)
	if ClickB("Предложение на рынок", false, false) then
		TradeStart($myitem, $hisitem, $myqty, $hisqty)
	Endif
EndFunc

;~ Торговать с другом номер $friendi
Func TradeFriend($friendi, $myitem, $hisitem, $myqty, $hisqty, $qty = 1)
	if $myitem = "" then return
	Sleep(200)
	ClickB0('Друзья')
	$cnt = 0
	while $cnt < $qty
		Sleep(200)
		ClickB0('Первый друг', 1, ($friendi - 1)*71)
		Sleep(200)
		ClickB0('Торовать с другом', 1, ($friendi - 1)*71)
		Sleep(200)
		TradeStart($myitem, $hisitem, $myqty, $hisqty)
		$cnt = $cnt + 1
	WEnd
EndFunc

;~ Торговать с участником гильдии номер $gildi
Func TradeGilde($gildi, $myitem, $hisitem, $myqty, $hisqty, $qty = 1)
	if $myitem = "" then return
	Sleep(200)
	ClickB0('Гильдия')
	$cnt = 0
	while $cnt < $qty
		Sleep(200)
		ClickB0('Первый друг', 1, ($gildi - 1)*71)
		Sleep(200)
		ClickB0('Торовать с другом', 1, ($gildi - 1)*71)
		Sleep(200)
		TradeStart($myitem, $hisitem, $myqty, $hisqty)
		$cnt = $cnt + 1
	WEnd
EndFunc

Func TradeStart($myitem, $hisitem, $myqty, $hisqty) 
	Local $myi = _ArraySearch($items, $myitem)
	Local $hisi = _ArraySearch($items, $hisitem)
	Local $myp = GetItemPos($items[$myi][2])
	Local $hisp = GetItemPos($items[$hisi][2])
	ClickB0("Мой товар")
	Sleep(200)
	ClickB0("Закладка" & $items[$myi][1])
	Sleep(200)
	MouseClick("left", $myp[0], $myp[1]) ; кликаем товар
	Sleep(200)
	Local $cur_qty = $myqty
	if $cur_qty <> 400 then
		Local $p = _ArraySearch($base_xy, "Товар=1")
		Local $p0[2] = [$base_xy[$p][1],$base_xy[$p][2]]
		$p = _ArraySearch($base_xy, "Товар=400")
		Local $p2[2] = [$base_xy[$p][1],$base_xy[$p][2]]
		MouseMove($p2[0], $p2[1])
		MouseDown("left")
		$p0[0] = $p0[0] + Round(($p2[0] - $p0[0])/400*($cur_qty))
		MouseMove($p0[0], $p0[1])
		MouseUP("left")
	Endif
	Sleep(200)
	ClickB0("Ок")
	Sleep(200)
	ClickB0("Его товар")
	Sleep(200)
	ClickB0("Закладка" & $items[$hisi][1])
	Sleep(200)
	MouseClick("left", $hisp[0], $hisp[1]) ; кликаем товар
	Sleep(200)
	Local $cur_qty = $hisqty
	if $cur_qty <> 400 then
		Local $p = _ArraySearch($base_xy, "Товар=1")
		Local $p0[2] = [$base_xy[$p][1],$base_xy[$p][2]]
		$p = _ArraySearch($base_xy, "Товар=400")
		Local $p2[2] = [$base_xy[$p][1],$base_xy[$p][2]]
		MouseMove($p2[0], $p2[1])
		MouseDown("left")
		$p0[0] = $p0[0] + Round(($p2[0] - $p0[0])/400*($cur_qty))
		MouseMove($p0[0], $p0[1])
		MouseUP("left")
	Endif
	Sleep(200)
	ClickB0("Ок")
	ClickB0("Торговать")
EndFunc

