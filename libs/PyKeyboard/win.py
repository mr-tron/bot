# -*- coding: utf-8 -*-

import win32api, win32con
from base import PyKeyboardMeta

EVENTCODES = {
	'up'   : 0x0002,
	'down' : 0x0000
}


class PyKeyboard(PyKeyboardMeta):
	
	def __init__(self):
		self.KEYCODES = {
			# http://msdn.microsoft.com/en-us/library/dd375731(v=VS.85).aspx
			# NOTE quick steal: $('#mainSection table:first tr:not(:has(th))').each(function(){ c = $(this).children('td'); val = $(c[0]).text().trim().split('\n'); VK=val[0].trim(); if (VK === '' || VK === '-') return; desc=$(c[1]).text().trim(); name = (/^(.+) key$/.test(desc)) ? RegExp.$1.toLowerCase().replace(/\s+/, '') : VK.replace(/^VK_/, '').toLowerCase(); val = /^0x/.test(VK) ? VK : val[1]; console.log('\t"' + name + '" : ' + val + ', # ' + desc.replace(/\n/g, ' ')) }), ''
			# TODO унифицировать, убрать говно
			"lbutton" : 0x01, # Left mouse button
			"rbutton" : 0x02, # Right mouse button
			"cancel" : 0x03, # Control-break processing
			"mbutton" : 0x04, # Middle mouse button (three-button mouse)
			"xbutton1" : 0x05, # X1 mouse button
			"xbutton2" : 0x06, # X2 mouse button
			"backspace" : 0x08, # BACKSPACE key
			"tab" : 0x09, # TAB key
			"clear" : 0x0C, # CLEAR key
			"enter" : 0x0D, # ENTER key
			"shift" : 0x10, # SHIFT key
			"ctrl" : 0x11, # CTRL key
			"alt" : 0x12, # ALT key
			"pause" : 0x13, # PAUSE key
			"capslock" : 0x14, # CAPS LOCK key
			"kana" : 0x15, # IME Kana mode
			"hanguel" : 0x15, # IME Hanguel mode (maintained for compatibility; use VK_HANGUL)
			"hangul" : 0x15, # IME Hangul mode
			"junja" : 0x17, # IME Junja mode
			"final" : 0x18, # IME final mode
			"hanja" : 0x19, # IME Hanja mode
			"kanji" : 0x19, # IME Kanji mode
			"esc" : 0x1B, # ESC key
			"convert" : 0x1C, # IME convert
			"nonconvert" : 0x1D, # IME nonconvert
			"accept" : 0x1E, # IME accept
			"modechange" : 0x1F, # IME mode change request
			"space" : 0x20, # SPACEBAR
			"pageup" : 0x21, # PAGE UP key
			"pagedown" : 0x22, # PAGE DOWN key
			"end" : 0x23, # END key
			"home" : 0x24, # HOME key
			"leftarrow" : 0x25, # LEFT ARROW key
			"uparrow" : 0x26, # UP ARROW key
			"rightarrow" : 0x27, # RIGHT ARROW key
			"downarrow" : 0x28, # DOWN ARROW key
			"select" : 0x29, # SELECT key
			"print" : 0x2A, # PRINT key
			"execute" : 0x2B, # EXECUTE key
			"printscreen" : 0x2C, # PRINT SCREEN key
			"ins" : 0x2D, # INS key
			"del" : 0x2E, # DEL key
			"help" : 0x2F, # HELP key
			"0" : 0x30, # 0 key
			"1" : 0x31, # 1 key
			"2" : 0x32, # 2 key
			"3" : 0x33, # 3 key
			"4" : 0x34, # 4 key
			"5" : 0x35, # 5 key
			"6" : 0x36, # 6 key
			"7" : 0x37, # 7 key
			"8" : 0x38, # 8 key
			"9" : 0x39, # 9 key
			"a" : 0x41, # A key
			"b" : 0x42, # B key
			"c" : 0x43, # C key
			"d" : 0x44, # D key
			"e" : 0x45, # E key
			"f" : 0x46, # F key
			"g" : 0x47, # G key
			"h" : 0x48, # H key
			"i" : 0x49, # I key
			"j" : 0x4A, # J key
			"k" : 0x4B, # K key
			"l" : 0x4C, # L key
			"m" : 0x4D, # M key
			"n" : 0x4E, # N key
			"o" : 0x4F, # O key
			"p" : 0x50, # P key
			"q" : 0x51, # Q key
			"r" : 0x52, # R key
			"s" : 0x53, # S key
			"t" : 0x54, # T key
			"u" : 0x55, # U key
			"v" : 0x56, # V key
			"w" : 0x57, # W key
			"x" : 0x58, # X key
			"y" : 0x59, # Y key
			"z" : 0x5A, # Z key
			"lwin" : 0x5B, # Left Windows key (Natural keyboard)
			"rwin" : 0x5C, # Right Windows key (Natural keyboard)
			"apps" : 0x5D, # Applications key (Natural keyboard)
			"computersleep" : 0x5F, # Computer Sleep key
			"numerickeypad 0" : 0x60, # Numeric keypad 0 key
			"numerickeypad 1" : 0x61, # Numeric keypad 1 key
			"numerickeypad 2" : 0x62, # Numeric keypad 2 key
			"numerickeypad 3" : 0x63, # Numeric keypad 3 key
			"numerickeypad 4" : 0x64, # Numeric keypad 4 key
			"numerickeypad 5" : 0x65, # Numeric keypad 5 key
			"numerickeypad 6" : 0x66, # Numeric keypad 6 key
			"numerickeypad 7" : 0x67, # Numeric keypad 7 key
			"numerickeypad 8" : 0x68, # Numeric keypad 8 key
			"numerickeypad 9" : 0x69, # Numeric keypad 9 key
			"multiply" : 0x6A, # Multiply key
			"plus" : 0x6B, # Add key
			"separator" : 0x6C, # Separator key
			"minus" : 0x6D, # Subtract key
			"decimal" : 0x6E, # Decimal key
			"divide" : 0x6F, # Divide key
			"f1" : 0x70, # F1 key
			"f2" : 0x71, # F2 key
			"f3" : 0x72, # F3 key
			"f4" : 0x73, # F4 key
			"f5" : 0x74, # F5 key
			"f6" : 0x75, # F6 key
			"f7" : 0x76, # F7 key
			"f8" : 0x77, # F8 key
			"f9" : 0x78, # F9 key
			"f10" : 0x79, # F10 key
			"f11" : 0x7A, # F11 key
			"f12" : 0x7B, # F12 key
			"f13" : 0x7C, # F13 key
			"f14" : 0x7D, # F14 key
			"f15" : 0x7E, # F15 key
			"f16" : 0x7F, # F16 key
			"f17" : 0x80, # F17 key
			"f18" : 0x81, # F18 key
			"f19" : 0x82, # F19 key
			"f20" : 0x83, # F20 key
			"f21" : 0x84, # F21 key
			"f22" : 0x85, # F22 key
			"f23" : 0x86, # F23 key
			"f24" : 0x87, # F24 key
			"numlock" : 0x90, # NUM LOCK key
			"scrolllock" : 0x91, # SCROLL LOCK key
		#	"0x92-96" : 0x92-96, # OEM specific
			"leftshift" : 0xA0, # Left SHIFT key
			"rightshift" : 0xA1, # Right SHIFT key
			"leftcontrol" : 0xA2, # Left CONTROL key
			"rightcontrol" : 0xA3, # Right CONTROL key
			"leftmenu" : 0xA4, # Left MENU key
			"rightmenu" : 0xA5, # Right MENU key
			"browserback" : 0xA6, # Browser Back key
			"browserforward" : 0xA7, # Browser Forward key
			"browserrefresh" : 0xA8, # Browser Refresh key
			"browserstop" : 0xA9, # Browser Stop key
			"browsersearch" : 0xAA, # Browser Search key
			"browserfavorites" : 0xAB, # Browser Favorites key
			"browserstart and home" : 0xAC, # Browser Start and Home key
			"volumemute" : 0xAD, # Volume Mute key
			"volumedown" : 0xAE, # Volume Down key
			"volumeup" : 0xAF, # Volume Up key
			"nexttrack" : 0xB0, # Next Track key
			"previoustrack" : 0xB1, # Previous Track key
			"stopmedia" : 0xB2, # Stop Media key
			"play/pausemedia" : 0xB3, # Play/Pause Media key
			"startmail" : 0xB4, # Start Mail key
			"selectmedia" : 0xB5, # Select Media key
			"startapplication 1" : 0xB6, # Start Application 1 key
			"startapplication 2" : 0xB7, # Start Application 2 key
			"oem_1" : 0xBA, # Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the ';:' key
			"forany country/region, the '+'" : 0xBB, # For any country/region, the '+' key
			"forany country/region, the ','" : 0xBC, # For any country/region, the ',' key
			"forany country/region, the '-'" : 0xBD, # For any country/region, the '-' key
			"forany country/region, the '.'" : 0xBE, # For any country/region, the '.' key
			"oem_2" : 0xBF, # Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '/?' key
			"oem_3" : 0xC0, # Used for miscellaneous characters; it can vary by keyboard.  For the US standard keyboard, the '`~' key
			"oem_4" : 0xDB, # Used for miscellaneous characters; it can vary by keyboard.   For the US standard keyboard, the '[{' key
			"oem_5" : 0xDC, # Used for miscellaneous characters; it can vary by keyboard.   For the US standard keyboard, the '\|' key
			"oem_6" : 0xDD, # Used for miscellaneous characters; it can vary by keyboard.   For the US standard keyboard, the ']}' key
			"oem_7" : 0xDE, # Used for miscellaneous characters; it can vary by keyboard.   For the US standard keyboard, the 'single-quote/double-quote' key
			"oem_8" : 0xDF, # Used for miscellaneous characters; it can vary by keyboard.
			"0xe1" : 0xE1, # OEM specific
			"oem_102" : 0xE2, # Either the angle bracket key or the backslash key on the RT 102-key keyboard
		#	"0xe3-e4" : 0xE3-E4, # OEM specific
			"imeprocess" : 0xE5, # IME PROCESS key
			"0xe6" : 0xE6, # OEM specific
			"packet" : 0xE7, # Used to pass Unicode characters as if they were keystrokes. The VK_PACKET key is the low word of a 32-bit Virtual Key value used for non-keyboard input methods. For more information, see Remark in KEYBDINPUT, SendInput, WM_KEYDOWN, and WM_KEYUP
		#	"0xe9-f5" : 0xE9-F5, # OEM specific
			"attn" : 0xF6, # Attn key
			"crsel" : 0xF7, # CrSel key
			"exsel" : 0xF8, # ExSel key
			"eraseeof" : 0xF9, # Erase EOF key
			"play" : 0xFA, # Play key
			"zoom" : 0xFB, # Zoom key
			"noname" : 0xFC, # Reserved
			"pa1" : 0xFD, # PA1 key
			"clear" : 0xFE, # Clear key
		}
	
	# 2 строчки всего - попробуйте найти их в интернете...
	def _fire(self, event, vk):
		scan = win32api.MapVirtualKey(vk, 0); # http://msdn.microsoft.com/en-us/library/ms646306(v=vs.85).aspx
		win32api.keybd_event(vk, scan, EVENTCODES[event], 0); # http://msdn.microsoft.com/en-us/library/ms646304(v=vs.85).aspx

