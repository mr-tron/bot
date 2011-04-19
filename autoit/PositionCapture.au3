
; Определение универсальных координат объектов
; Коротко. Надо получить координаты, например, лесопилок. Запускаем скрипт. МАКСИМАЛЬНО zoom out'им. Идём в ближайший к лесопилкам сектор (цифровыми клавишами).
; Зажимаем shift и кликаем по лесопилке - получаем в консоле автоита координаты лесопилки. Так по каждой нужной точке.
; Для выхода - ESCAPE
; Замечания:
; Если вы сдвинули карту с помощью клавиш или мышью, то координаты "универсальными" уже не будут
; Скрипт запоминает в какой сектор вы переходите и выдаёт его в консоли.
; Писал под себя, чтобы быстро заполнить массив $deposits. см. там.

#include <WindowsConstants.au3>
#include <StructureConstants.au3>
#Include <AutoFeed.au3>


HotKeySet("{ESCAPE}", "Terminate")
OnAutoItExitRegister("Cleanup")

Global Const $tagMSLLHOOKSTRUCT = 'int x;int y;DWORD mouseData;DWORD flags;DWORD time;ULONG_PTR dwExtraInfo'

Global $hModule = _WinAPI_GetModuleHandle(0)

Global $hMouseProc = DllCallbackRegister("LowLevelMouseProc", "long", "int;wparam;lparam")
Global $pMouseProc = DllCallbackGetPtr($hMouseProc)
Global $hMouseHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, $pMouseProc, $hModule)

Global $hKeyboardProc = DllCallbackRegister("LowLevelKeyboardProc", "long", "int;wparam;lparam")
Global $pKeyboardProc = DllCallbackGetPtr($hKeyboardProc)
Global $hKeyboardHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, $pKeyboardProc, $hModule)

Global $sectorCenterPos[2] = [$clientPos[0] + Round($clientPos[2]/2), $clientPos[1] + _Iif($clientPos[3] < 800, 400, Round($clientPos[3]/2))]
Global $enable = False
Global $sector = 0

While 1
WEnd

; http://msdn.microsoft.com/en-us/library/ms644986(v=vs.85).aspx
Func LowLevelMouseProc($nCode, $wParam, $lParam)
	
	If $nCode >= 0 And $wParam = $WM_LBUTTONUP Then
		
		If $enable Then
			; http://msdn.microsoft.com/en-us/library/ms644970(v=vs.85).aspx
			Local $MSLLHOOKSTRUCT = DllStructCreate($tagMSLLHOOKSTRUCT, $lParam)
			Local $x = DllStructGetData($MSLLHOOKSTRUCT, 1)
			Local $y = DllStructGetData($MSLLHOOKSTRUCT, 2)
			ConsoleWrite("AddTarget('', " & StringFormat('%4d', $x - $sectorCenterPos[0]) & ', ' & StringFormat('%4d', $y - $sectorCenterPos[1]) & ', ' & $sector & ')' & @CRLF)
		EndIf
		
	EndIf

	Return _WinAPI_CallNextHookEx($hMouseHook, $nCode, $wParam, $lParam)
	
EndFunc

; http://msdn.microsoft.com/en-us/library/ms644985(VS.85).aspx
Func LowLevelKeyboardProc($nCode, $wParam, $lParam)
	
	If $nCode >= 0 Then
		
		; http://msdn.microsoft.com/en-us/library/ms644967(v=VS.85).aspx
		Local $KBDLLHOOKSTRUCT = DllStructCreate($tagMSLLHOOKSTRUCT, $lParam)
		; http://msdn.microsoft.com/en-us/library/dd375731(v=VS.85).aspx
		Local $vkCode = DllStructGetData($KBDLLHOOKSTRUCT, 1)
		If $vkCode = 0x10 Or $vkCode = 0xA0 or $vkCode = 0xA1 Then ; Shifts
			Switch $wParam
			Case $WM_KEYDOWN
				$enable = True
			Case $WM_KEYUP
				$enable = False
			EndSwitch
		ElseIf $wParam = $WM_KEYUP And ($vkCode >= 0x30) And ($vkCode <= 0x39) Then  ; 0 - 9
			$sector = $vkCode - 0x30
		ElseIf $wParam = $WM_KEYUP And ($vkCode >= 0x60) And ($vkCode <= 0x69) Then  ; NumPad 0 - NumPad 9
			$sector = $vkCode - 0x60
		EndIf
		
	EndIf

	Return _WinAPI_CallNextHookEx($hMouseHook, $nCode, $wParam, $lParam)
	
EndFunc

Func Cleanup()
	_WinAPI_UnhookWindowsHookEx($hMouseHook)
	_WinAPI_UnhookWindowsHookEx($hKeyboardHook)
	DllCallbackFree($hMouseProc)
	DllCallbackFree($hKeyboardProc)
EndFunc

;~ Func Terminate()
;~     Exit 0
;~ EndFunc