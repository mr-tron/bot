
; -------------------------------------------------------------------------------------------
;                  СКРИПТ АВТОКОРМЁЖКИ ДЛЯ DIE SIEDLERS ONLINE
; -------------------------------------------------------------------------------------------
;
;                         ИГРА:  http://www.diesiedleronline.de
;                       СКРИПТ:  http://settlers.onbb.ru/viewtopic.php?id=104
; 
; Проверено на последних версиях браузеров firefox, opera, chrome, safari.
; Internet Explorer не тестировался. Скорее всего - не работает. Такой он.
;
; Изменено 2011.04.20 Чтобы скрипт находил нужные слоты с ресурсами, они должны быть где-то сверху. Скрипт не скроллит меню!
; После изменения с помощью переменной $scrollpages можно указать количество прокручиваемых страниц при поиске
;
; TIPS:
;  - Если что-то пошло не так и надо прервать выполнение скрипта - Escape.
;  - Можно скомпилировать скрипт в *.exe файл.
; 
; 
; -------------------------------------------------------------------------------------------
;                                        КАК ЗАПУСТИТЬ
; -------------------------------------------------------------------------------------------
; 
;   1. Скачать дистрибутив скриптовой оболочки AutoIt:
;      http://www.autoitscript.com/site/autoit/downloads/
;   2. Установить.
;   3. Открыть файл "Your Task.au3", прочитать, написать своё задание.
;   4. Можно запускать скрипт "Your Task.au3" двойным кликом.
;
;
; -------------------------------------------------------------------------------------------
;                                      ИСТОРИЯ ВЕРСИЙ
; -------------------------------------------------------------------------------------------
;
; 0.2.9 (2011.09.07)
;   - в Autoaccept добавлено скидывание найденных карт в звезду
;   - изменен алгоритм автологина под новые заморочки сервера
; 0.2.8 (2011.07.26)
;   - добавлена возможность поиска сокровищ и приключений разных видов (Карта1, Карта2, Карта3).
;   - добавлена возможность торговли товаром из 4-й вкладки.
;   - алгоритм торговли изменен под максимальное количество товара 400 вместо 200.
;   - добавлены хеши лута от приключений (Titanerz, Pferde, Würste)
; 0.2.7.5 (2011.05.22)
;   - добавлена функция восстановления засохших родников/полей, а также других зданий: BuildAll(Наименование здания)
; 0.2.7.4 (2011.05.19)
;   - исправлены мелкие баги.
;   - запуск файла PositionCapture позволяет получать массивы цветов пикселей для последующего использования
; 0.2.7.3 (2011.05.12)
;   - доработано использование бота в разных разрешениях экрана
; 0.2.7.2 (2011.05.12)
;   - добавлена функция DropSlot(Имя итема, количество кормежек)
;	- добавлены хеши обычных и длинных луков
;   - исправлен баг с кликом по иконке сообщений
; 0.2.7.1 (2011.05.11)
;   - Добавлены функции торговли TradeHandle, TradeFriend, TradeGilde
;   - Добавлен хеш железных мечей для дропа
;   - Добавлена функция AutoAccept - смотрит в сообщения и принимает/отклоняет предложения торговли и подарки
; 0.2.7 (2011.05.05)
;   - Добавлен автологин
;   - Добавлены функции Build, BuffAll, Search, CreateProviant
; 0.2.6.3 (2011.04.20)
;   - Добавлена переменная $scrollpages - количество страниц для пролистывания при поиске дропов и кормежки
; 0.2.6.2 (2011.04.20)
;   - Процедуры Drop и Feed адаптированы под новую систему позиционирования
; 0.2.6.1 (2011.04.18)
;   - Добвлен хэш пасхальных яиц и корзинок с экзотическими фруктами
;   - Пофиксена GetAllSlotHashes()
; 0.2.6 (2011.02.23)
;   - Добвлен хэш угля
;   - Чтобы получить хэш слота, которого ещё нет - просто пишем в файле заданий GetAllSlotHashes()
;   - Прервать выполнение скрипта - Escape
;   - Анти-бан меры:
;     - Скорость перемещения может меняться случайным образом при помощи настроек $mouseMoveSpeedMin и $mouseMoveSpeedMax
;     - Позиция кликов по элементам управления меняется случайным образом
; 0.2.5.1 (2011.02.19)
;   - багфиксы
;   - слегка изменился синтаксис заданий - количество кормёжек - "?" - спрашивать юзера, "*" - бесконечно
; 0.2.5 (2011.02.19) - unstable alpha
;   - Введена опция $verbose - показывать или нет сообщения в конце заданий (мешают, если несколько заданий)
;   - Настройки можно задавать отдельно для каждого файла заданий
;   - При выборе слота дожидается закрытия меню - если по какой-то причине слот не выбрался - снова его выбирает.
;     Теперь можно поставить $mouseMoveSpeed = 1 и полюбоваться ))) вполне стабильно работает даже на такой скорости.
;   - Абстрагирована функция кормёжки. Need refactor. Later.
;   - Новый вид задания Settle() - вселять поселенцев.
;   - Новый вид задания Drop() - скидывать дроп в ратушу. Пока работают только Fir wood planks, Stones,
;     Hard wood planks, Marble, Gold, Hard wood planks, Tools. Это то, что у меня было. Контрибутим хэши других ресурсов!
;   - Добавлен браузер Firefox 4 (feedback @yagoda)
; 0.2.4 (2011.02.18) - unstable alpha
;   - Добавлена возможность в Feed() указывать несколько лунок, которые скрипт будет
;     кормить поочереди
; 0.2.3.1 (2011.02.18) - unstable alpha
;   - Убран лишний WinWaitActive при старте
; 0.2.3 (2011.02.18) - unstable alpha
;   - Пофиксено позиционирование в опере.
;   - Скрипт разделён на две части - библиотека и файл(ы) заданий.
;     Удобно создавать несколько видов разных заданий.
;   - Publish!
; 0.2.2 (2011.02.17) - unstable alpha
;   - Заданы координаты всех лунок с рыбой и мясом
;   - Реализована кормёжка дичи.
;   - Нарисована карта лунок (map.jpg).
;   - Написана утилита PositionCapture.au3, с помощью которой можно определять
;     "универсальные" координаты объектов.
;   - Вселение поселенцев в ратушу - Feed(0). Пока так.
;   - Вычислены хэши слотов некоторых наиболее распространённых объектов (на будущее).
;   - Убран слип для открытия меню - вместо этого скрипт ждёт столько сколько нужно.
;     В результате, с одной стороры, если клиент тормозит - скрипт всё равно дожидается
;     когда меню откроется, с другой, - если клиент шустро реагирует, то и скрипт
;     зря не спит. Есть таймаут. Настраивается.
;   - Определение какая из вкладок активна (лишний раз не открывает уже активную вкладку).
;   - Убран слип для перемещения по вкладкам. Слипов нет!
; 0.2.1 (2011.02.15) - unstable alpha
;   - Однозначно определяет позицию звезды и меню по их битмапам - если что-то пошло не так,
;     то ругается, а не таскает мышь по странице с википедией (её пользователь смотрел)
;     100 раз (так пользователь заказал) думая, что там лунки
;   - Состояние слотов определяется по их хэшам (тобиш быстро)
;   - Работает как с открытой френдлентой, так и с закрытой
;   - Отлажена система позиционирования на лунках - работает в firefox, chrome, safari,
;     в опере не работает, в ie не проверялось. later.
; 0.2.0 (2011.02.14) - unstable alpha
;   Автор - peepcode. Основная цель - минимизировать настройки скрипта
;   - Автоматически определяются браузер с игрой и размеры клиента
;   - Попытка унифицировать положения элементов управления
;   - Попытка унифицировать положения объектов игры (лунки)
;   - Убраны ненужные sleep'ы. Предполагается, что пока курсор перемещается клиент успевает
;     отрисовать то, что ему надо
;   - Более умная система выбора слотов кормёжки - скрипт сам ищет доступные слоты с нужными
;     ресурсомами
;   - Мгновенная активация окна браузера (без клика по контролу)
;   - Можно менять скорость перемещений указателя курсора
;   - Пока умеет только рыбу кормить
; 0.1.0 (не известно) - "под напильник"
;   Первоначальная версия, основные идеи скрипта. Автор - doktorgradus
;
;
; -------------------------------------------------------------------------------------------
;                                                 TODO
; -------------------------------------------------------------------------------------------
;
;  - Проблема с несколькими инстансами флэш-плагина ???
;
;
;
; -------------------------------------------------------------------------------------------

#Include <Array.au3>
#Include <Color.au3>
#Include <WinAPI.au3>
#Include <Misc.au3>
#Include <Date.au3>
;~ #Include <Encoding.au3>

; for TextDisplay
#include <GUIEdit.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>

#include <consts.au3>
#include <vars.au3>
; -------------------------------------------------------------------------------------------
; Индивидуальные настройки
; -------------------------------------------------------------------------------------------
; Скорость перемещения указателя курсора: от 0 до 100: 0 - мгновенно, 1 - очень быстро, 100 - очень медленно.
; Не рекомендуется ставить значения меньше 3, т.к. клиент игры не будет успевать реагировать. На слабых машинах возможно стоит увеличить значение.
If Not IsDeclared("mouseMoveSpeedMin") Then Global Const $mouseMoveSpeedMin = 2
If Not IsDeclared("mouseMoveSpeedMax") Then Global Const $mouseMoveSpeedMax = 5
; Количество кормёжек по-умолчанию, которое будет подставлено в поле ввода при запросе у пользователя
If Not IsDeclared("defaultFeedCount") Then Global Const $defaultFeedCount = 100
; Максимальное время ожидания открытия менюшек
If Not IsDeclared("menuTimeout") Then Global Const $menuTimeout = 5000
; Сообщать об окончании очереди, недоступности слотов и т.д.
If Not IsDeclared("verbose") Then Global Const $verbose = True
If Not IsDeclared("scrollpages") Then Global Const $scrollpages = 0
if Not IsDeclared("debug") Then Global Const $debug = false
if Not IsDeclared("debugconsole") Then Global Const $debugconsole = false
if Not IsDeclared("logpath") Then Global Const $logpath = ''
; -------------------------------------------------------------------------------------------
; Тело программы
; -------------------------------------------------------------------------------------------

HotKeySet("{ESCAPE}", "Terminate")
HotKeySet("{PAUSE}", "TogglePause")


; -------------------------------------------------------------------------------------------
;  ОБЩЕЕ
; -------------------------------------------------------------------------------------------
Func GoToZeroPt()
	$cur_scroll[0] = 0
	$cur_scroll[1] = 0
	MouseMove($clientPos[0] + Round($clientPos[2] / 2), $clientPos[1] + 100)
	MouseClick('left')
	Sleep(100)
	Send('0')
	Sleep(100)
	MouseWheel("down", 10)  ; минимальный масштаб карты
EndFunc

; Активирует рабочее окно
Func ActivateClient()
	
	Local $i, $hwnd
	
	; Ищем окно клиента игры
	For $i = 0 To UBound($browsers) - 1          ; пробуем каждый доступный браузер
		$clientWindow = ControlGetHandle("[TITLE:" & $browserTitle & "; CLASS:" & $browsers[$i][1] & "]", "", "[CLASS:" & $browsers[$i][2] & "]")
		If Not $clientWindow = 0 Then            ; если какое-то окошко нашлось
			$browser = _ArrayRow($browsers, $i)  ; запоминаем какой у нас браузер
			ExitLoop                             ; считаем, что нашли, прекращаем поиск
		EndIf
	Next
	
	; Если клиент не найден - делать нечего, выходим
	If $clientWindow = 0 Then
		if $verbose Then
			Err("Не удалось найти окно клиента игры")
			Exit
		EndIf
		AddLog("Не удалось найти окно клиента игры")
		Return False
	EndIf
	
	; Ищем окно браузера - получаем всех родителей клиента, забираем самого старшего с соответствующим классом браузера
	$hwnd = $clientWindow
	While Not $hwnd = 0
		$hwnd = _WinAPI_GetParent($hwnd)
		If (_WinAPI_GetClassName($hwnd) = $browser[1]) Then
			$browserWindow = $hwnd
		EndIf
	WEnd

	If Not $browserWindow = 0 Then
		If BitAnd(WinGetState($browserWindow, ""), 16) Then  ; если браузер минимизирован
			WinSetState($browserWindow, "", @SW_RESTORE)     ; восстанавливаем
		EndIf
		WinActivate($browserWindow, "")                      ; активируем окно браузера на всякий случай
	EndIf

	; Активируем окно клиента
	If WinActivate($clientWindow, "") = 0 Then
		Err("Не удалось активировать требуемое окно браузера")
		Exit
	EndIf
	
	; Получаем размеры клиента в формате [x, y, width, height]
	$clientPos = WinGetPos($clientWindow, "")
	If $clientPos = 0 Then
		Err("Не удалось получить размеры окна браузера")
		Exit
	EndIf
	
	; Ищем положение центра звезды по битмапу
	$starPos = BitmapSearch($starBitmap, $clientPos[0], $clientPos[1] + $clientPos[3] - 200, $clientPos[0] + $clientPos[2], $clientPos[1] + $clientPos[3])
	If $starPos = 0 Then
		if $Verbose then 
			Err("Не удалось получить положение звезды." & @CRLF & "Убедитесь, что вкладка браузера с игрой активна и в игре не открыты модальные окна (например, окно сообщений)")
			Exit
		Endif
		AddLog("Не удалось получить положение звезды." & @CRLF & "Убедитесь, что вкладка браузера с игрой активна и в игре не открыты модальные окна (например, окно сообщений)")
		Return False
	EndIf
	
	GotoZeroPt()
	; Преобразовываем координаты $deposits и $base_xy
	TransDeps()
	TransBase()
	Return True;
EndFunc

; Спрашивает у пользователя количество кормёжек
Func AskFeedCount($title = 'AutoFeed')
	Local $answer
	While 1
		$answer = InputBox($title, 'Количество кормёжек (* - бесконечно)', $defaultFeedCount)
		If @error = 0 Then
			If StringIsInt($answer) And Int($answer) > 0 Then
				WinActivate($clientWindow, "")
				Return Int($answer)
			ElseIf $answer == '*' Then
				WinActivate($clientWindow, "")
				Return $answer
			Else
				Err("Необходимо ввести правильное целое число")
			EndIf
		ElseIf @error = 1 Then
			Exit
		Else
			Err("Неизвестная ошибка в AskFeedCount()")
			Exit
		EndIf
	WEnd
EndFunc

; Перемещает курсор в положение на экране, где клиент реагирует на нажатия клавиш
; Если курсор мыши находится над окошками (окно здания, окно менюшек), то клиент игнорирует скроллинг и нажатия клавиш перехода к секторам.
; Есть под курсором менюшка, или нет - мы точно не знаем, поэтому надо увести мышь куда-то, где как-будто точно менюшки нет.
; Пока ничего лучше, чем отвести мыша чуть влево от менюшки звезды не придумал...
Func MouseMoveToScrollSafe()
	If $starNeverOpen Then OpenStar()
	MoveMouse($menuPos[0] - 10, $menuPos[1])
EndFunc

; Перемещает карту в нужный сектор
Func GoToSector($sector)
	If $currentSector <> $sector Then
		MouseMoveToScrollSafe()
		Send($sector)              ; нажимаем кнопку с номером сектора
		$currentSector = $sector   ; запомнили, чтобы 10 раз не тыркаться
	EndIf
EndFunc

; Пересчитывает размеры меню звезды
Func CalcMenuDimensions($pos)
	
	; $pos - опорная точка в центре маленькой звезды над меню - относительно неё и считаем
	
	; Положение меню звезды
	$menuPos[0] = $pos[0] - 191
	$menuPos[1] = $pos[1] + 28
	
	; Положение первого слота
	Local $firstSlotPos[2] = [ $pos[0] - 184, $pos[1] + 39 ]
	
	; Положение центров слотов меню
	For $row = 1 To 3
		For $cell = 1 To 6
			$slot = $cell + 6 * ($row - 1)  ; номер слота
			; Положение центра слота $slot (0.5 - смещение к центру)
			$slotsPos[$slot][0] = $firstSlotPos[0] + $slotSize[0] * ($cell - 0.5)
			$slotsPos[$slot][1] = $firstSlotPos[1] + $slotSize[1] * ($row - 0.5)
		Next
	Next
	
	; Положения вкладок меню
	For $tab = 1 to 5
		; Положение центра вкладки $tab - место для клика (0.5 - смещение к центру)
		$tabsPos[$tab][0] = $menuPos[0] + Round(($tab - 0.5) * ($menuSize[0] / 5))
		$tabsPos[$tab][1] = $menuPos[1] + $menuSize[1] - 15
		; Положение точки на левом краю вкладки $tab - место для забора цвета для определения её активности
		$tabsBasePos[$tab][0] = $menuPos[0] + Round(($tab - 1) * ($menuSize[0] / 5)) + 5
		$tabsBasePos[$tab][1] = $tabsPos[$tab][1]
	Next
	
EndFunc

Func Rand($a, $b)
	If $a == $b Then
		Return $a
	Else
		Return Random($a, $b, 1)
	EndIf
EndFunc

Func MoveMouse($bx, $by, $dx = 0, $dy = 0, $scroll = false)
	Local $x = $bx, $y = $by
	if $scroll then
		$x = $bx - $cur_scroll[0]
		$y = $by - $cur_scroll[1]
		while $y < $clientPos[1] + 40
			MouseMove($clientCenter[0] - 150, $clientCenter[1])
			MouseDown("left")
			MouseMove($clientCenter[0] - 150, $clientCenter[1]+200)
			MouseUP("left")
			$y = $y + 200
		Wend
		while $y + 200 > $clientPos[1] + $clientPos[3]
			MouseMove($clientCenter[0] - 150, $clientCenter[1])
			MouseDown("left")
			MouseMove($clientCenter[0] - 150, $clientCenter[1]-200)
			MouseUP("left")
			$y = $y - 200
		wend
		$cur_scroll[0] = $bx - $x
		$cur_scroll[1] = $by - $y
	EndIf
	MouseMove($x + Rand(-$dx, $dx), $y + Rand(-$dy, $dy), Rand($mouseMoveSpeedMin, $mouseMoveSpeedMax))
EndFunc

Func Terminate()
	AddLog("Остановлено пользователем")
    Exit
EndFunc

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(1000)
        ToolTip('Script is "Paused"',0,0)
    WEnd
    ToolTip("")
EndFunc


; -------------------------------------------------------------------------------------------
;  ЗВЕЗДА
; -------------------------------------------------------------------------------------------

; Перемещает указатель курсора в центр звезды
Func MouseMoveToStar()
	MoveMouse($starPos[0], $starPos[1], 8, 8)
EndFunc

; Определяет открыта ли звезда
Func IsStarOpened()
	
	If $starNeverOpen Then
		; Если меню ни разу не открывалось, то ищем его по битмапу
		$pos = BitmapSearch($menuBitmap, $clientPos[0], $clientPos[1], $clientPos[0] + $clientPos[2], $clientPos[1] + $clientPos[3])
		If $pos = 0 Then                                  ; не нашли
			Return False                                  ; значит меню закрыто
		Else                                              ; если нашли на экране битмап, то
			$sbPos[0] = $pos[0] + 164
			$sbPos[1] = $pos[1] + 232
			$menuHashPos = $pos                           ; запомним позицию найденного битмапа
			$menuHash = GetHashAtPoint($pos[0], $pos[1])  ; найдём и запомним хэш в этой точке
			CalcMenuDimensions($pos)                      ; определим размеры меню по найденной позиции битмапа
			$starNeverOpen = False                        ; снимем флаг девственности
			Return True                                   ; точняк меню открыто
		EndIf
	Else
		; Если меню уже открывалось, то факт его открытости устанавливаем с помощью ранее определённого хэша
		Return IsHashAtPoint($menuHashPos[0], $menuHashPos[1], $menuHash)
	EndIf
	
EndFunc

; Ждёт открытия меню звезды в отведённое время $timeout. Возврвщает открылось окно или нет
Func WaitStarOpen($timeout = $menuTimeout)
	
	Local $tic = TimerInit()                   ; включаем таймер
	While Not IsStarOpened()                   ; всё время проверяем - не открылось ли
		If (TimerDiff($tic) >= $timeout) Then  ; если ждём больше чем $timeout, то отрицательно выходим
			If $verbose Then Err("Не удалось открыть меню звезды или определить его положение." & @CRLF & "Возможно клиент не успевает реагировать на щелчки мыши. Попробуйте увеличить время ожидания в секции индивидуальных настроек.")
			Return False
		EndIf
	WEnd
	Return True
	
EndFunc

; Ждёт закрытия меню звезды в отведённое время $timeout. Возврвщает закрылось окно или нет
Func WaitStarClose($timeout = $menuTimeout, $verbose = True)
	
	Local $tic = TimerInit()                   ; включаем таймер
	While IsStarOpened()                       ; всё время проверяем - не открылось ли
		If (TimerDiff($tic) >= $timeout) Then  ; если ждём больше чем $timeout, то отрицательно выходим
			If $verbose Then Err("Не удалось дождаться закрытия меню звезды.")
			Return False
		EndIf
	WEnd
	Return True
	
EndFunc

; Открывает звезду
Func OpenStar()
	
	If IsStarOpened() Then Return
	MouseMoveToStar()
	MouseClick("left")
	If Not WaitStarOpen() Then 
		if $verbose Then
			Exit
		Else
			Return false
		EndIf
	EndIf
	
EndFunc

; Перемещает указатель курсора в вкладки $tab меню звезды
Func MouseMoveToStarTab($tab)
	If $starNeverOpen Then OpenStar()
	MoveMouse($tabsPos[$tab][0], $tabsPos[$tab][1], 15, 3)
EndFunc

; Определяет активна ли вкладка меню звезды
Func IsStarTabActive($tab)
	; неактивные вкладки : rgb(89,71,45)   = 0x59472D
	; активные вкладки   : rgb(131,102,65) = 0x836641
	If $starNeverOpen Then OpenStar()
	Return ColorMatches(PixelGetColor($tabsBasePos[$tab][0], $tabsBasePos[$tab][1]), 0x836641, 10)
EndFunc

; Активирует заданную вкладку в звезде
Func ActivateStarTab($tab)
	
	OpenStar()
	If IsStarTabActive($tab) Then Return
	
	Local $tic, $tac
	
	MouseMoveToStarTab($tab)
	MouseClick("left")

	$tic = TimerInit()
;~ 	While Not IsStarTabActive($tab)     ; ждём пока не откроется вкладка
;~ 		$tac = TimerDiff($tic)          ; сколько уже ждём?
;~ 		If ($tac >= $menuTimeout) Then  ; устали ждать
;~ 			Err("Не удалось активировать вкладку меню." & @CRLF & "Возможно клиент не успевает реагировать на щелчки мыши. Попробуйте увеличить время ожидания в секции индивидуальных настроек.")
;~ 			Exit
;~ 		EndIf
;~ 	WEnd

EndFunc



; -------------------------------------------------------------------------------------------
;  СЛОТЫ
; -------------------------------------------------------------------------------------------
; Слоты нумеруются слева-направо сверху-вниз - от 0 до 18

; Перемещает указатель мыши на центр слота $slot
Func MouseMoveToSlot($slot)
	If $starNeverOpen Then OpenStar()
	MoveMouse($slotsPos[$slot][0], $slotsPos[$slot][1], 18, 25)
EndFunc

; Определяет соответствует ли слот $slot типу $type (по хэшу)
Func IsSlotOfType($slot, ByRef $type)
	Local $slotHash = GetHashAtPoint($slotsPos[$slot][0], $slotsPos[$slot][1])
	Local $slotId = _ArraySearch($slotHashes, $slotHash)
	If $slotId < 0 Then Return False
	If IsNumber($type) Then Return $slotId = $type
	If IsArray($type) Then Return _ArraySearch($type, $slotId) >= 0
	Return False
EndFunc

; Ищет во всём меню первый слот с типом $type, начиная со слота $start
Func FindSlotOfType(ByRef $type, $scroll = true)
	OpenStar()
	if $scroll then
		for $page = 0 to $scrollpages
			if $page > 0 then
				MouseClick("left", $sbPos[0], $sbPos[1])    ; Пролистываем
				Sleep(200)
			EndIf
			For $slot = 1 To 18
				If IsSlotOfType($slot, $type) Then Return $slot
			Next
		Next
	Else
		For $slot = 1 To 18
			If IsSlotOfType($slot, $type) Then Return $slot
		Next
	Endif
	Return 0
EndFunc

Func SelectSlot(ByRef $slotTypes, $scroll = true)
	
	Local $slot
	; Ищем первый подходящий ресурс в звезде.
	; Загвоздка в том, что найденный ресурс может сдвинуться в списке пока мы к нему мышкой ползли...
	While 1
		$slot = FindSlotOfType($slotTypes, $scroll)       ; ищем слот
		If $slot = 0 Then Return False            ; если не нашли - кормить нечем, выходим
		MouseMoveToSlot($slot)                    ; иначе, перемешаем курсор на найденный слот ресурса
		If IsSlotOfType($slot, $slotTypes) Then  ; если пока курсор двигался этот слот не пропал, то
			MouseClick("left")                          ; быстренько кликаем по слоту с ресурсом
			If WaitStarClose(500, False) Then           ; и ждём закрытия окна звезды - открылось - продолжаем, иначе - снова идём в начало цикла
				ExitLoop                                ; эта проверка нужна потому что иногда случается, что клик по слоту происходит в тот момент,
			EndIf                                       ; когда клиент обновляет менюшку и клик не защитывает, следовательно слот не выбирается,
														; меню не закрывается, значит нужно снова всё повторить.
		EndIf
	WEnd
	
	Return True
	
EndFunc



; -------------------------------------------------------------------------------------------
; ЗАДАНИЯ
; -------------------------------------------------------------------------------------------

; Перемещает курсор на заданную лунку с месторождением
Func MouseMoveToTarget($target)
	;GoToSector($deposits[$target][3])  ; перемещаем карту в сектор с лункой
	;Local $sectorCenter[2] = [$clientPos[0] + Round($clientPos[2]/2), $clientPos[1] + _Iif($clientPos[3] < 800, 400, Round($clientPos[3]/2))] ; хитрая позиция центра сектора
	MoveMouse($deposits[$target][1], $deposits[$target][2],0,0,true)  ; идём по координатам относительно центра сектора
EndFunc

Func GetSlotTypeForTaskTarget($taskName, $target)
	
	Switch $taskName
		Case "Feed"
			Return $deposits[$target][0]
		Case "Settle"
			Return 3
		Case "Buff"
			Local $suxx[4] = [12, 13, 14, 15]
			Return $suxx
		Case "Drop"
			Local $suxx[21] = [4, 5, 6, 7, 8, 9, 10, 11, 18, 19, 20, 21, 23, 24, 25, 26, 27, 28, 29, 30, 31]
			Return $suxx
		Case "Сокровища", "Сокровища1", "Сокровища2", "Сокровища3", "Сокровища4", "Карта1", "Карта2", "Карта3"
			Return 16
		Case "Камень", "Медная руда", "Мрамор", "Железная руда"
			Local $suxx[2] = [17, 22]
			Return $suxx
		Case Else
			Return False
	EndSwitch
	
EndFunc

; Пытается кормить лунку $deposit путём поска нужных слотов в меню, начиная со слота $startSlot
Func PerformFeedingTasks($taskName, $targets, $count = 0, $starTab = 4)
	
	If Not IsArray($targets) Then
		$targets = ParseNumberRange($targets, 0, UBound($deposits) - 1)
	EndIf
	If ($targets[0] = 0) Then Return False
	
	If $count == '?' Then
		$count = AskFeedCount($taskName) ; спрашиваем у пользователя
	ElseIf $count == '-' Then ; не повторять кормёжки - каждое здание - только один раз
		$count = $targets[0]
	ElseIf $count == '*' Then ; беcконечно
		$count = '*'
	ElseIf ($count <= 0) Then         ; если количество кормёжек не задано явно
		Return 0
	EndIf
	
	Local $feeded    = 0  ; лунок накормлено (точнее, количество успешных попыток)
	Local $targetId  = 0  ; текущая лунка
	Local $target         ; текущая лунка
	Local $slotType
	
	While ($count == '*') Or ($feeded < $count)
		$targetId = _Iif($targetId >= $targets[0], 1, $targetId + 1)  ; перешли на следующую лунку
		$target   = $targets[$targetId]
		$slotType = GetSlotTypeForTaskTarget($taskName, $target)
		
		; пытаемся кормить текущую лунку
		ActivateStarTab($starTab)     ; активируем вкладку ресурсов в звезде
		If Not SelectSlot($slotType) Then
			If $verbose Then Err('Не найдено доступных слотов с кормёжкой. Накормлено: ' & $feeded) ; сообщаем ; TODO не очень хорошо. если дальше идут ещё задания, то пока юзер по кнопке не кликнет - их выполнение будет заблокировано
			Return $feeded                                           ; завершаем задание
		EndIf
		MouseMoveToTarget($target)    ; перемешаем курсор на лунку
		MouseClick("left")            ; кликаем по лунке, тобиш кормим её
		$feeded += 1                  ; считаем, что накормили
	WEnd
	
	If $verbose Then
		Sleep(500)  ; поспим, чтобы последняя лунка успела съесть, чтобы фокус не перешёл на msgbox
		Msg('Очередь кормёжки закончена. Накормлено: ' & $feeded)   ; подводим итоги ; TODO см. выше
	EndIf
	Return $feeded
	
EndFunc

; Выполняет серию кормёжек лунки
;   $targets  -  номера лункок, которые требуется кормить в виде "1,5,32-33". Если указано несколько лунок, то кормить будет поочереди
;   $count    -  общее количество кормёжек, если 0, то спросить у пользователя
Func Feed($targets, $count = '?')
	Local $targetsArray = ParseDepositsRange($targets)    ; парсим переданную строку, получаем массив нужных лунок
	If $targetsArray = False Then Return False            ; ошибки в строке
	Return PerformFeedingTasks("Feed", $targetsArray, $count)
EndFunc

Func Settle($count = '?')
	Return PerformFeedingTasks('Settle', 0, $count)
EndFunc

Func Drop($count = '*')
	Return PerformFeedingTasks('Drop', 0, $count)
EndFunc

Func DropSlot($sname, $cnt = 0)
	Local $bid = -1
	MouseMove($clientCenter[0], $clientPos[1] + 100)
	Send('0')
	MouseWheel("down", 10)  ; минимальный масштаб карты
	Sleep(200)
	$bid = _ArraySearch($deposits, 'townhall', 0, 0, 0, 0, 1, 4)
	Local $slotid = _ArraySearch($slotHashes, $sname, 0, 0, 0, 0, 1, 1)
	if $slotid = -1 Then
		$slotid = 15 ; яйца
	Endif
	if $bid < 0 Then return
	Local $qty = $cnt
	Local $cntr = 0
	if $cnt = 0 Then $qty = 1000
	while $cntr < $qty 
		$cntr = $cntr + 1 
		ActivateStarTab(4)     ; активируем вкладку ресурсов в звезде
		If Not SelectSlot($slotid) Then
			Return                                           ; завершаем задание
		EndIf
		ClickP($deposits[$bid][1], $deposits[$bid][2], False)
	Wend
EndFunc

Func Buff($targets)
	Return PerformFeedingTasks('Buff', $targets, '-', 3)
EndFunc


Func AddTarget($name, $x, $y, $sector)
	
	Local $i = UBound($deposits)
	ReDim $deposits[$i + 1][4]
	$deposits[$i][0] = $name
	$deposits[$i][1] = $x
	$deposits[$i][2] = $y
	$deposits[$i][3] = $sector
	Return $i
	
EndFunc

; -------------------------------------------------------------------------------------------
; Вспомогательные функции
; -------------------------------------------------------------------------------------------

; Стандартное соотщение
Func Msg($message)
	MsgBox(4096, "Сообщение", $message)
EndFunc

; Стандартное соотщение об ошибке
Func Err($message)
	MsgBox(4096, "Ошибка", $message)
EndFunc

; Ищет на экране заданный битмап. Аналогичено PixelSearch, только ищет не отдельный пиксель, а их массив (битмап)
Func BitmapSearch($bitmap, $left = 0, $top = 0, $right = @DesktopWidth, $bottom = @DesktopHeight, $tolerance = 0, $step = 1, $hwnd = 0)
	
	Local $color = $bitmap[0][0], $x = $left, $y = $top, $point
	
	While 1
		$point = PixelSearch($x, $y, $right, _Iif($x = $left, $bottom, $y), $color, $tolerance, $step, $hwnd) 
		If IsArray($point) Then
			If _BitmapMatch($bitmap, $point[0], $point[1]) Then
				Return $point
			Else
				$x = $point[0] + 1
				$y = $point[1]
			EndIf
		ElseIf ($x = $left) Then
			Return 0
		Else
			$x = $left
			$y = $y + 1
		EndIf
	WEnd
	
EndFunc

; Для целей BitmapSearch - проверяет соответствие $bitmap и экрана в точке ($x0; $y0)
Func _BitmapMatch($bitmap, $x0, $y0, $tolerance = 0)
	
	Local $x, $y
	Local $falses = 0
	
	For $x = 0 To UBound($bitmap, 1) - 1
		For $y = 0 To UBound($bitmap, 2) - 1
			If Not ColorMatches(PixelGetColor($x0 + $x, $y0 + $y), $bitmap[$x][$y], 0) Then $falses=$falses + 1
			if $falses > 0 and $x = 0 and $y = 0 then return False
			if $falses > 3 then return False
		Next
	Next
	Return True
	
EndFunc

; Получает хэш (checksum) пикселей области экана радиусом $radius вокруг (воквадрат, на самом деле) точки $point
Func GetHashAtPoint($x, $y, $radius = 2)
	Return PixelChecksum($x - $radius, $y - $radius, $x + $radius, $y + $radius)
EndFunc

; Проверяет соответствует ли хэш в точке $point радиусом $radius требуемому хэшу $hash
Func IsHashAtPoint($x, $y, $hash, $radius = 2)
	Return $hash = GetHashAtPoint($x, $y, $radius)
EndFunc

; Нечётко сравнивает (допуск $tolerance: 0 - строго, больше - мягче) два цвета друг с другом.
; Цвета можно задавать в виде массива RGB и числом
Func ColorMatches($color, $sample, $tolerance = 0)
	If $tolerance Then  ; для оптимизации
		If Not IsNumber($color)  Then $color  = _ColorSetRGB($color)   ; приводим тип к числу
		If Not IsNumber($sample) Then $sample = _ColorSetRGB($sample)  ; приводим тип к числу
		Return $color = $sample   ; строгое равенство
	EndIf
	If IsNumber($color)  Then $color  = _ColorGetRGB($color)   ; приводим тип к массиву RGB
	If IsNumber($sample) Then $sample = _ColorGetRGB($sample)  ; приводим тип к массиву RGB
	For $c = 0 To 2   ; покомпонентное сравнение
		If ($color[$c] > ($sample[$c] + $tolerance)) Or ($color[$c] < ($sample[$c] - $tolerance)) Then
			Return False
		EndIf
	Next
	Return True
EndFunc

; Преобразует строку вида "2,5,7-9,12" в массив чисел
Func ParseNumberRange($value, $min = '', $max = '')
	
	Local $values[1] = [0]
	_ParseNumberRange($value, $values, $min, $max)
	$values[0] = UBound($values) - 1
	Return $values
	
	
EndFunc

; Преобразует строку вида "2,5,7-9,12" в массив чисел
Func _ParseNumberRange($value, ByRef $array, $min = '', $max = '')
	
	If IsNumber($value) Then
		If IsNumber($min) And ($value < $min) Then Return False
		If IsNumber($max) And ($value > $max) Then Return False
		_ArrayAdd($array, $value)
	ElseIf StringIsInt($value) Then
		Return _ParseNumberRange(Int($value), $array, $min, $max)
	ElseIf IsString($value) Then  ; "2,5,7-9,12"
		Local $values = StringSplit($value, ',')
		For $i = 1 to $values[0]
			If StringInStr($values[$i], '-') Then  ; this is a range
				Local $range = StringSplit($values[$i], '-')
				If $range[0] <> 2 Then Return False  ; malformed range
				Local $start = StringStripWS($range[1], 8)
				Local $end   = StringStripWS($range[2], 8)
				If Not StringIsInt($start) Or Not StringIsInt($end) Then Return False  ; malformed range
				$start = Int($start)
				$end   = Int($end)
				If $start >= $end Then Return False  ; malformed range
				For $r = $start To $end
					If _ParseNumberRange($r, $array, $min, $max) = False Then Return False
				Next
			Else
				If _ParseNumberRange(StringStripWS($values[$i], 8), $array, $min, $max) = False Then Return False
			EndIf
		Next
	ElseIf IsArray($value) Then
		For $i = 0 to UBound($values) - 1
			If _ParseNumberRange($values[$i], $array, $min, $max) = False Then Return False
		Next
	Else
		Return False
	EndIf
	
	Return True
	
EndFunc

Func ParseDepositsRange($string)
	
	Local $values[1]
	
	If _ParseNumberRange($string, $values, 1, UBound($deposits) - 1) = False Then
		dbg('Неверно задан диапазон месторождений.')
		Return 0
	Else
		$values[0] = UBound($values) - 1
		Return $values
	EndIf
	
EndFunc

; Костылеобразная Функция реализует синтаксис нормального скриптового языка: $subarray = $array[$num].
; AutoIt оперирует массивами как матрицами, а не как массивами массивов. Поэтому нельзя просто получить в переменную подмассив из массива.
Func _ArrayRow($array, $num)
	Local $row[UBound($array, 2)]
	For $i = 0 To UBound($row) - 1
		$row[$i] = $array[$num][$i]
	Next
	Return $row
EndFunc



; -------------------------------------------------------------------------------------------
; Функции отладки
; -------------------------------------------------------------------------------------------

Func dbg($message)
	ConsoleWrite($message & @CRLF)
EndFunc

Func tic()
	Global $tic = TimerInit()
EndFunc

Func tac($text = '')
	Global $tac = TimerDiff($tic)
	dbg($text & 'time: ' & $tac)
EndFunc

Func ConsoleWriteLn($message)
	ConsoleWrite($message & @CRLF)
EndFunc

Func MoveMouseOverRect($left, $top, $right, $bottom)
	Local $speed = 2
	MouseMove($left,  $bottom, $speed)
	MouseMove($left,  $top,    $speed)
	MouseMove($right, $top,    $speed)
	MouseMove($right, $bottom, $speed)
	MouseMove($left,  $bottom, $speed)
EndFunc

Func Color2Str($color)
	Return "[" & $color[0] & ", " & $color[1] & ", " & $color[2] & "]"
EndFunc

Func Point2Str($point)
	Return "[" & $point[0] & "; " & $point[1] & "]"
EndFunc

; Получает битмап области экрана из точки ($x0, $y0), шириной $width, высотой $height. Печатает готовый кусок кода в консоль
Func GetBitmap($x0, $y0, $width, $height, $var = '$bitmap')
	
	Local $x, $y, $color, $bitmap[$width][$height]
	
	ConsoleWrite($var & '[' & $width & '][' & $height & '] = [')
	$width  -= 1
	$height -= 1
	For $x = 0 To $width
		ConsoleWrite('[')
		For $y = 0 To $height
			$color = PixelGetColor($x0 + $x, $y0 + $y)
			$bitmap[$x][$y] = $color
			ConsoleWrite('0x' & Hex($color, 6) & _Iif($y = $height, '', ','))
		Next
		ConsoleWrite(']' & _Iif($x = $width, '', ','))
	Next
	ConsoleWrite(']' & @CRLF)
	
	Return $bitmap
	
EndFunc

; Получает хэш слота $slot (в центре радиусом по-умолчинию). Печатает готовый кусок кода в консоль
Func GetSlotHash($slot, $var = '$slotHash')
	
	If Not IsStarOpened() Then OpenStar()
	Local $slotHash = GetHashAtPoint($slotsPos[$slot][0], $slotsPos[$slot][1])
	ConsoleWrite($var & ' = ' & $slotHash & @CRLF)
	Return $slotHash

EndFunc

; Получает хэши всех слотов
Func GetAllSlotHashes()
	
	If Not IsStarOpened() Then OpenStar()
	Local $slotHash, $index, $name, $text = 'slot   hash             name'
	For $slot = 1 To 18
		$slotHash = GetHashAtPoint($slotsPos[$slot][0], $slotsPos[$slot][1])
		$index = _ArraySearch($slotHashes, $slotHash)
		If $index >= 0 Then
			$name = $slotHashes[$index][1]
		Else
			$name = 'unknown'
		EndIf
		$text = $text & @CRLF & $slot & ' : hash: ' & $slotHash & ', name: ' & $name
	Next
	
	TextDisplay($text)

EndFunc

; Для проверки правильности координат лунок
Func CheckDepositsPositions($from, $to)
	
	Local $slotType = 0, $slot = 0, $dep
	
	For $i = $from To $to
		$dep = _ArrayRow($deposits, $i)
		If $slotType <> $dep[0] Then
			$slot = FindSlotOfType($dep[0])
			If $slot = 0 Then
				Err('Slot of type ' & $dep[0] & ' not found: cannot check deposit #' & $i)
			Else
				$slotType = $dep[0]
				MouseMoveToSlot($slot)
				MouseClick('left')
			EndIf
		EndIf
		MouseMoveToTarget($dep)
		Sleep(1000)
	Next
	
EndFunc

Func TextDisplay($text = "", $title = "AutoFeed")

	Local $form = GUICreate($title, 620, 435, -1, -1) ; create the basic form. Width = 620, Height - 435. Left and Top = -1. -1 Is default (centered in this case)
	Local $edit = _GUICtrlEdit_Create($form, "", 0, 0, 620, 435, BitOr($ES_MULTILINE, $ES_WANTRETURN, $ES_AUTOVSCROLL)) ; Create the actual place to edit text. Left and Top = 0. Sets it so that the start is the top left corner. Width = 620, Height = 435. Makes it the same size as the window.
	GUICtrlSetResizing(-1, 102) ; Set the resizing. Control = -1. -1 is the last control created/used. Resizing = 102. Makes it grow or shrink with the window.
	_GUICtrlEdit_SetText($edit, $text) ; Set the file contents to be displayed.
	GUISetState() ; Show the window.

	While 1
		If GUIGetMsg() == $GUI_EVENT_CLOSE Then Exit
	WEnd

EndFunc

Func AddLog($text)
	if $debug Then
		if $debugconsole Then
			ConsoleWrite(""&_Now()&" : "&_Encoding_StringToUTF8($text)& @CRLF)
		elseif $logpath <> "" then
			_FileWriteLog($logpath, $text)
		Endif
	Endif
EndFunc