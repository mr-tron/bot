#!/usr/bin/env python
# -*- coding: utf-8 -*-
#	
from Xlib import X
from Xlib.display import Display
from Xlib.ext import xtest
class keycodes:
	left = 100
	right = 102
	up = 98
	down = 104
	home = 97
	end = 103
	pageup = 99
	pagedown = 105
	enter = 36
	shift = 50 
	f1 = 67
	f2 = 68
	f3 = 69
	f4 = 70
	f5 = 71
	f6 = 72
	
class kc(keycodes):
	pass

class my_keyboard:
	display = Display(':0')
	def send(self, keycode):
		if type(keycode) == tuple or type(keycode) = list:
			# send with modifier
			xtest.fake_input(self.display, X.KeyPress, keycode[0])
			xtest.fake_input(self.display, X.KeyPress, keycode[1])
			xtest.fake_input(self.display, X.KeyRelease, keycode[1])
			xtest.fake_input(self.display, X.KeyRelease, keycode[0])
		else:
			# send without modifier
			xtest.fake_input(self.display, X.KeyPress, keycode)
			xtest.fake_input(self.display, X.KeyRelease, keycode)
		self.display.sync()
