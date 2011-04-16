# -*- coding: utf-8 -*-

class PyClientMeta(object):
	
	def activate(self, window_title = None):
		"""
		Finds and activates browser window with a game.
		"""
		raise NotImplementedError


	def pos(self):
		"""
		Retrieves position of the game client area as `(top, left, right, bottom)`.
		"""
		raise NotImplementedError

	
	def size(self):
		"""
		Retrieves size of the game client area as `(width, height)`.
		"""
		raise NotImplementedError

