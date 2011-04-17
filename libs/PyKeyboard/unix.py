# -*- coding: utf-8 -*-

from Xlib import X
from Xlib.display import Display
from Xlib.ext import xtest
from base import PyKeyboardMeta


EVENTCODES = {
	'up'   : X.KeyRelease,
	'down' : X.KeyPress
}

display = Display(':0')


class PyKeyboard(PyKeyboardMeta):

	def __init__(self):
		# TODO добавить кодов, чтоб как в винде было. И ссылку здесь оставьте где это добро перечисляется!
		self.KEYCODES = {
			'left'      : 100,
			'right'     : 102,
			'up'        : 98,
			'down'      : 104,
			'home'      : 97,
			'end'       : 103,
			'pageup'    : 99,
			'pagedown'  : 105,
			'enter'     : 36,
			'shift'     : 50,
			'f1'        : 67,
			'f2'        : 68,
			'f3'        : 69,
			'f4'        : 70,
			'f5'        : 71,
			'f6'        : 72,
			'minus'     : 20,
			'plus'      : 21,
			'k1'        : 10, # Вот, по-моему, по-русски это должно называться "0" - "9". От куда этот "k" взялся??
			'k2'        : 11,
			'k3'        : 12,
			'k4'        : 13,
			'k5'        : 14,
			'k6'        : 15,
			'k7'        : 16,
			'k8'        : 17,
			'k9'        : 18,
			'k0'        : 19,
			'shift_l'   : 50,
			'control_l' : 37,
		}

	
	def _fire(self, event, vk):
		xtest.fake_input(display, EVENTCODES[event], vk)
	
	def _play(self, keynames, event = 'press'):
		super(PyKeyboard, self)._play(keynames, event)
		display.sync()

