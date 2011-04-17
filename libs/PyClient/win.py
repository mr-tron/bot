# -*- coding: utf-8 -*-

import win32api, win32con, win32gui
from base import PyClientMeta


# подсобные функции, которые скрывают от нас изящество вин32
def get_window_title(window):
	return win32gui.GetWindowText(window)

def get_window_class(window):
	return win32gui.GetClassName(window)

def get_desktop():
	return win32gui.GetDesktopWindow()

def get_window_children(parent_window = None):
	if parent_window == None: parent_window = get_desktop()
	children = []
	def enum_windows(hwnd, none): children.append(hwnd)
	win32gui.EnumChildWindows(parent_window, enum_windows, None)
	return children

def activate_window(window):
	if win32gui.GetWindowPlacement(window)[1] == win32con.SW_SHOWMINIMIZED:  # if minimized
		win32gui.ShowWindow(window, win32con.SW_RESTORE)                     # restore
	win32gui.SetForegroundWindow(window)                                     # bring to top and give focus

def get_window_pos(window):
	return win32gui.GetWindowRect(window)

def get_window_size(window):
	rect = win32gui.GetWindowRect(window)
	return (rect[2] - rect[0], rect[3] - rect[1])


class PyClient(PyClientMeta):

	def __init__(self):
		# класс окна браузера                           браузер       класс окна флэш плагина
		self.browsers = {
			"Chrome_WidgetWin_0"                     : ("Chrome"   ,  "NativeWindowClass"            ),
			"OperaWindowClass"                       : ("Opera"    ,  "aPluginWinClass"              ),
			"MozillaUIWindowClass"                   : ("Firefox"  ,  "GeckoPluginWindow"            ),
			"MozillaWindowClass"                     : ("Firefox4" ,  "GeckoPluginWindow"            ),
			"{1C03B488-D53B-4a81-97F8-754559640193}" : ("Safari"   ,  "WebPluginView"                ),
			"IEFrame"                                : ("IE"       ,  "MacromediaFlashPlayerActiveX" )
		}
		self.window_title = 'Die Siedler Online'
		self.browser_window = None
		self.control_window = None
	
	# NOTE всё это дело - рабочее, но, по сути, не используется, т.к. позже решил использовать независимый от платформы способ определения размеров клиента. пока оставил здесь
	def _find_browser(self, window_title):
		if self.browser_window != None: return True
		window_title = window_title or self.window_title
		
		# getting all top-most windows
		topmost_windows = get_window_children()
		browser_classes = self.browsers.keys()
		# searching for one with one of `browser_classes` and containing `window_title`
		for window in topmost_windows:
			if  (get_window_class(window) in browser_classes) and (get_window_title(window).find(window_title) >= 0):
				self.browser_window = window
				browser_class = get_window_class(window)
				break
		if self.browser_window == None: return False
		
		# looking for flash plugin control window (it'll tell us it's size)
		control_class = self.browsers[browser_class][1]
		children = get_window_children(self.browser_window)
		for child in children:
			if get_window_class(child) == control_class:
				self.control_window = child
				break
		if self.control_window == None: return False
		return True
	
	def activate(self, window_title = None):
		if not self._find_browser(window_title): return False
		activate_window(self.browser_window)
		return True
	
	def pos(self):
		if not self._find_browser(): return None
		return get_window_pos(self.browser_window)

	def size(self):
		if not self._find_browser(): return None
		return get_window_size(self.browser_window)


