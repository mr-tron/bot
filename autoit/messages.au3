
#Include <File.au3>

func AutoAccept($autoablehen = true)
	ClickB("Сообщения", true, false)
	Sleep(500)
	Local $mi = 0; - номер рассматриваемого сообщения
	Local $p = _ArraySearch($base_xy, 'Сообщение 1')
	$cnt = 0
	while ($mi < 6) and ($cnt < 100)
		$cnt = $cnt + 1
		Sleep(300)
		$MHash = GetHashAtPoint($base_xy[$p][1], $base_xy[$p][2]+25*$mi)
;~ 		_FileWriteLog($logpath, "$MHash = "&$MHash)
		Local $mId = _ArraySearch($AllHashes, $MHash)
		if $mId >= 0 then
			$mType = $AllHashes[$mId][1]
		Else
			$mType = 'Undefined'
		Endif
		if $mType = 'Найдены сокровища' Then
			Sleep(200)
			ClickB0("Сообщение 1", 1, 0, $mi*25)
			Sleep(500)
			ClickB0("На склад")
		elseif $mType = 'Сражение' Then
			Sleep(200)
			ClickB0("Удалить сообщение 1", 1, 0, $mi*25)
		elseif $mType = 'Предложение торговли' Then
			Sleep(200)
			ClickB0("Сообщение 1", 1, 0, $mi*25)
			Sleep(500)
			ClickB0("Принять предложение")
;~ 			Если у нас нет нужного количества ресурсов, то отклоняем предложение
			if $autoablehen then
				Sleep(200)
				ClickB0("Отклонить предложение")
			EndIf
		elseif $mType = 'Подарок' Then
			Sleep(200)
			ClickB0("Сообщение 1", 1, 0, $mi*25)
			Sleep(500)
			ClickB0("Принять подарок")
		elseif $mType = 'Undefined' Then
			$mi = $mi + 1
		EndIf
	WEnd
	ClickB("ЗакрытьПостройки", false, false)	
EndFunc
