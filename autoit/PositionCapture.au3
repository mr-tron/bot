
; Определение набора пикселей для последующего поиска с помощью функции FindBMP
; Ставим мышь на нужную позицию, зажимаем Shift, уводим мышь с позиции подальше - чтобы курсор не загораживал битмап. Отпускаем Shift, получаем массив цветов пикселей и координату
; Для выхода - ESCAPE

#include <WindowsConstants.au3>
#include <StructureConstants.au3>
#Include <WinAPI.au3>

HotKeySet("{ESCAPE}", "Terminate")
OnAutoItExitRegister("Cleanup")

Global Const $tagMSLLHOOKSTRUCT = 'int x;int y;DWORD mouseData;DWORD flags;DWORD time;ULONG_PTR dwExtraInfo'

Global $hModule = _WinAPI_GetModuleHandle(0)

Global $hKeyboardProc = DllCallbackRegister("LowLevelKeyboardProc", "long", "int;wparam;lparam")
Global $pKeyboardProc = DllCallbackGetPtr($hKeyboardProc)
Global $hKeyboardHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, $pKeyboardProc, $hModule)
Global $pos[2]

While 1
WEnd

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
				$pos = MouseGetPos()
			Case $WM_KEYUP
				Local $radius = 2
				Local $c, $sText = "Global const $VarName["&($radius*2 + 1)&"]["&($radius*2 + 1)&"] = [["
				for $i = -$radius to $radius
					for $j = -$radius to $radius
						$c = PixelGetColor($pos[0]+$i, $pos[1] + $j)
						if $j <> -$radius then $sText = $sText&", "
						$sText = $sText&"0x"&Hex($c, 6)
					Next
					if $i = $radius then 
						$sText = $sText&"]" 
					else 
						$sText = $sText&"], ["
					EndIf
				Next
				$sText = $sText&"]"
				ConsoleWrite(";~ point = ("&$pos[0]&", "&$pos[1]&")"& @CRLF)
				ConsoleWrite($sText& @CRLF)
			EndSwitch
		EndIf
		
	EndIf

EndFunc

Func Cleanup()
	_WinAPI_UnhookWindowsHookEx($hKeyboardHook)
	DllCallbackFree($hKeyboardProc)
EndFunc

Func Terminate()
    Exit 0
EndFunc