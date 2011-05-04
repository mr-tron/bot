
; -------------------------------------------------------------------------------------------
; Переменные
; -------------------------------------------------------------------------------------------

; Текущее положение экрана относительно центра клиента
Global $cur_scroll[2] = [0,0]

; Хэш опорной звёздочки над меню звезды. Вычисляется по ходу
Global $menuHash, $menuHashPos

; переменные для автологина
If Not IsDeclared("runpath") Then Global Const $runpath = ''
If Not IsDeclared("login") Then Global Const $login = ''
If Not IsDeclared("passwd") Then Global Const $passwd = ''
If Not IsDeclared("autologin") Then Global Const $autologin = False
If Not IsDeclared("autoactivate") Then Global Const $autoactivate = True

; --- Deposites -----------------------------------------------------------------------------
; Массив описаний месторождений в следующем формате:
;   [0] вид месторождения, тут пока хранится то чего данная лунка может в себя принимать - индекс из $slotHashes
;   [1] x-координата*
;   [2] y-координата*
;   [3] сектор, в котором расположено месторождение
;   [4] условное наименование, можно использовать для поиска в массиве
; *Координаты задаются относитьльно карты, спозиционированной в центре сектора месторождения (по нажатию соответствующей клавиши) и с минимальным масштабом.
; Предполагается, что таким образом координаты лунок будут у всех одинаковые и каждому пользователю не нужно будет высчитывать их значения для себя.
; Ему будет достаточно задать некий "унифицированный" номер месторождения (суть индекс в массиве $deposits).
; Будет ли это всё работать - ещё надо проверить...
Global $deposits[75][5] = [ _ 
[3, 472, 777, 0, 'townhall'], _
[1, 582, 940, 0, 'fish'], _
[1, 534, 940, 0, 'fish'], _
[1, 393, 940, 0, 'fish'], _
[1, 266, 948, 0, 'fish'], _
[1, 370, 854, 0, 'fish'], _
[1, 231, 768, 0, 'fish'], _
[1, 277, 321, 0, 'fish'], _
[1, 311, 286, 0, 'fish'], _
[1, 184, 250, 0, 'fish'], _
[1, 184, 234, 0, 'fish'], _
[1, 371, 235, 0, 'fish'], _
[1, 511, 177, 0, 'fish'], _
[1, 674, 149, 0, 'fish'], _
[1, 699, 149, 0, 'fish'], _
[1, 1564, 825, 0, 'fish'], _
[1, 1540, 825, 0, 'fish'], _
[1, 1471, 770, 0, 'fish'], _
[1, 1424, 797, 0, 'fish'], _
[1, 1354, 941, 0, 'fish'], _
[1, 1283, 911, 0, 'fish'], _
[1, 638, 1049, 0, 'fish'], _
[1, 722, 969, 0, 'fish'], _
[1, 662, 903, 0, 'fish'], _
[1, 570, 847, 0, 'fish'], _
[1, 535, 452, 0, 'fish'], _
[2, 758, 868, 0, 'wild'], _
[2, 756, 764, 0, 'wild'], _
[2, 218, 227, 0, 'wild'], _
[2, 535, 249, 0, 'wild'], _
[2, 733, 105, 0, 'wild'], _
[2, 1002, 184, 0, 'wild'], _
[2, 1353, 249, 0, 'wild'], _
[2, 1375, 263, 0, 'wild'], _
[2, 1435, 401, 0, 'wild'], _
[2, 1446, 421, 0, 'wild'], _
[2, 1213, 552, 0, 'wild'], _
[2, 1447, 610, 0, 'wild'], _
[2, 1599, 717, 0, 'wild'], _
[2, 1353, 797, 0, 'wild'], _
[2, 1014, 911, 0, 'wild'], _
[2, 1015, 775, 0, 'wild'], _
[2, 769, 884, 0, 'wild'], _
[4, 393, 624, 0, 'Медная руда'], _
[4, 417, 593, 0, 'Медная руда'], _
[4, 452, 571, 0, 'Медная руда'], _
[4, 895, 888, 0, 'Медная руда'], _
[4, 943, 863, 0, 'Медная руда'], _
[4, 1001, 884, 0, 'Медная руда'], _
[4, 941, 816, 0, 'Золотая руда'], _
[4, 896, 832, 0, 'Золотая руда'], _
[4, 967, 775, 0, 'Золотая руда'], _
[4, 1446, 134, 0, 'Золотая руда'], _
[4, 1388, 184, 0, 'Золотая руда'], _
[4, 1318, 200, 0, 'Золотая руда'], _
[4, 1271, 214, 0, 'Золотая руда'], _
[4, 1422, 322, 0, 'Золотая руда'], _
[4, 637, 370, 0, 'Железная руда'], _
[4, 689, 372, 0, 'Железная руда'], _
[4, 721, 348, 0, 'Железная руда'], _
[4, 873, 239, 0, 'Железная руда'], _
[4, 943, 209, 0, 'Железная руда'], _
[4, 1038, 227, 0, 'Железная руда'], _
[4, 1107, 152, 0, 'Железная руда'], _
[4, 1143, 150, 0, 'Железная руда'], _
[4, 299, 563, 0, 'Железная руда'], _
[4, 321, 549, 0, 'Железная руда'], _
[4, 1315, 484, 0, 'Железная руда'], _
[4, 1363, 542, 0, 'Железная руда'], _
[4, 1400, 535, 0, 'Железная руда'], _
[4, 1436, 515, 0, 'Железная руда'], _
[4, 1364, 730, 0, 'Железная руда'], _
[4, 1423, 708, 0, 'Железная руда'], _
[4, 1495, 665, 0, 'Железная руда'] _
]

Global $base_xy[33][3] = [ _ ; базовые координаты элементов игры
['Рынок', 124, 841], _
['Предложение на рынок', 254, 794], _
['Первый итем', 670, 460], _
['Товар=1', 718, 692], _
['Товар=176', 846, 692], _
['Товар=200', 863, 692], _
['Товар+1', 889, 692], _
['Товар10', 889, 692], _
['Мой товар', 678, 620], _
['Его товар', 1015, 620], _
['Закладка1', 679, 619], _
['Закладка2', 789, 619], _
['Закладка3', 902, 619], _
['Сообщения', 1055, 836], _
['Сообщение 1', 849, 391], _
['Принять предложение', 807, 686], _
['Отклонить предложение', 880, 690], _
['Первый друг', 565, 917], _
['Торовать с другом', 565 + 632 - 565, 917 + 885 - 917], _
['Ок', 960, 670], _
['Принять подарок', 864, 623], _
['Искать сокровища', 811, 556], _
['ИскатьОк', 802, 655], _
['На склад', 899, 670], _
['Закрыть сообщения', 1112, 333], _
['Торговать', 852, 542], _
['Ресурс + 1', 1104, 597], _
['ОкПровиант', 980, 627], _
['ЗакрытьПровиант', 1108, 367], _
['Buff6h', 841, 483], _
['Корм для рыб', 751, 529], _
['Корм для животных', 798, 624], _
['Уха', 750, 483] _              
]


Func TransDeps()
	$clientCenter[0] = $clientPos[0] + Round($clientPos[2] / 2)
	$clientCenter[1] = $clientPos[1] + Round($clientPos[3] / 2)
	Local $d[2] = [$clientCenter[0] - $cc_b[0], $clientCenter[1] - $cc_b[1]]
	For $i = 0 to UBound($deposits,1) - 1
		$deposits[$i][1] = $deposits[$i][1] + $d[0] 
		$deposits[$i][2] = $deposits[$i][2] + $d[1] 
	Next
EndFunc

Func TransBase()
	$clientCenter[0] = $clientPos[0] + Round($clientPos[2] / 2)
	$clientCenter[1] = $clientPos[1] + Round($clientPos[3] / 2)
	Local $d[2] = [$clientCenter[0] - $cc_b[0], $clientCenter[1] - $cc_b[1]]
	For $i = 0 to UBound($base_xy,1) - 1
		$base_xy[$i][1] = $base_xy[$i][1] + $d[0] 
		$base_xy[$i][2] = $base_xy[$i][2] + $d[1] 
	Next
EndFunc

; -------------------------------------------------------------------------------------------
; Служебные переменные
; -------------------------------------------------------------------------------------------
; Параметры браузера, окон
Global $clientWindow  = 0   ; дескриптор окна клиента
Global $browserWindow = 0   ; дескриптор окна браузера
Global $browser[3]          ; данные браузера (содержит строчку из $browsers с текущим браузером)

; Переменные геометрии элементов управления игры. Вычисляются по ходу дела
Global $clientPos, $starPos, $menuPos[2], $slotsPos[19][2], $tabsPos[6][2], $tabsBasePos[6][2], $sbPos[2]
Global $clientCenter[2]


; Известные константы геометрии
Global Const $slotSize[2] = [56, 70]
Global Const $menuSize[2] = [384, 251]

; Флаги
Global $starNeverOpen = True  ; Звезда ещё ни разу не открывалась?
Global $currentSector = 0     ; Текущий сектор на карте

Global $clientCenter[2]

;~ хендл клиентского окна
Global $clWnd = 0
; путь до лог-файла
Global $logpath = ""