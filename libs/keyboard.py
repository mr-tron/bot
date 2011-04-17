# -*- coding: utf-8 -*-

"""

## `keyboard`

Keyboard abstraction layer.


### Common
	
 - To specify several keys join them with `"+"`: `"ctrl+a"`.  

 - Keycodes are case-insensitive.

    TODO: Key codes...


### Supported platforms:

 - Windows - supported (requires: `pywin32`);

 - Unix - supported (requires: `Xlib`);

 - Mac - **not supported** (requires: );


### Examples

	from libs import keyboard as key

	key.press('plus')
	key.press('minus')
	key.press('f1')
	key.press('ctrl+alt+del')


### API

"""

from PyKeyboard import PyKeyboard
from time import sleep
from utils import classproperty

pykeyboard = PyKeyboard()

class keyboard(object):

	@classmethod
	def down(self, keys):
		"""
		 - `keyboard.down(keys)`  
		   Press down given keyboard `keys`.  
		   Returns `self`.
		"""
		pykeyboard.down(keys)
		return self


	@classmethod
	def up(self, keys):
		"""
		 - `keyboard.up(keys)`  
		   Release given keyboard `keys`.  
		   Returns `self`.
		"""
		pykeyboard.up(keys)
		return self


	@classmethod
	def press(self, keys):
		"""
		 - `keyboard.press(keys)`  
		   Press (press down & release) given keyboard `keys`.  
		   Returns `self`.
		"""
		pykeyboard.press(keys)
		return self


	@classmethod
	def sleep(self, seconds):
		"""
		 - `keyboard.sleep(seconds)`  
		   Just a handy clone of standart `time.sleep()` for cozy chaining.  
		   Returns `self`.
		"""
		sleep(seconds)
		return self
	

