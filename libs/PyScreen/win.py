# -*- coding: utf-8 -*-

import win32gui, win32api
from PIL import ImageGrab
from ctypes import *
from base import PyScreenMeta

class PyScreen(PyScreenMeta):
	
	def screen_size(self):
		width  = win32api.GetSystemMetrics(0)
		height = win32api.GetSystemMetrics(1)
		return width, height

	def screen_width(self):
		return win32api.GetSystemMetrics(0)


	def screen_height(self):
		return win32api.GetSystemMetrics(1)


	def get_pixel_color(self, x, y):
		color = int(win32gui.GetPixel(win32gui.GetWindowDC(win32gui.GetDesktopWindow()), x, y))
		return (color & 255), ((color >> 8) & 255), ((color >> 16) & 255)

	
	def get_screenshot(self, left = 0, top = 0, right = None, bottom = None):
		if right == None: right = self.screen_width()
		if bottom == None: bottom = self.screen_height()
		return ImageGrab.grab((left, top, right, bottom))

