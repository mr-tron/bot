# -*- coding: utf-8 -*-

class PyKeyboardMeta(object):
	
	# TODO unify KEYCODES
	
	def __init__(self):
		self.KEYCODES = {}
	
	def _lookup(self, keynames):
		"""
		"""
		keycodes = []
		for k in keynames.split('+'):
			keyname = k.strip().lower()
			if keyname in self.KEYCODES:
				keycodes.append(self.KEYCODES[keyname])
			else:
				raise UserWarning, 'Illegal keyname input: "' + k + '" in "' + keynames + '"' # FIXME как там в ваших питонах это правильно делают?
		if len(keycodes) == 0:
			raise UserWarning, 'Illegal empty keyname input: "' + keynames + '"' # FIXME как там в ваших питонах это правильно делают?
		else:
			return keycodes

	
	def _play(self, keynames, event = 'press'):
		"""
		"""
		keycodes = self._lookup(keynames)
		if event in ('press', 'down'):
			for vk in keycodes: self._fire('down', vk)
		if event in ('press', 'up'):
			for vk in keycodes: self._fire('up', vk)


	def _fire(self, event, vk):
		"""
		"""
		raise NotImplementedError


	def down(self, keynames):
		"""
		"""
		self._play(keynames, 'down')


	def up(self, keynames):
		"""
		"""
		self._play(keynames, 'up')

	
	def press(self, keynames):
		"""
		"""
		self._play(keynames, 'press')

