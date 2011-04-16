# -*- coding: utf-8 -*-

import wnck, gtk
from time import time
from base import PyClientMeta

class PyClient(PyClientMeta):

	def __init__(self):
		self.window_title = 'Die Siedler Online'
	
	def activate(self, window_title = None):
		window_title = window_title or self.window_title
		wnck_screen = wnck.screen_get_default()
		while gtk.events_pending(): gtk.main_iteration()
		wnck_windows = [w for w in wnck_screen.get_windows() if w.get_name().find(window_title) >= 0]
		if len(wnck_windows) == 0: return False
		game_window = wnck_windows[0];
		game_window.activate(int(time()))
		return True

	def pos(self):
		raise NotImplementedError

	def size(self):
		raise NotImplementedError

