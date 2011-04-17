# -*- coding: utf-8 -*-

"""

## `client`

Here sits all platform-specific stuff not being directly related to the bot logic.

### Common
	


### Supported platforms:

 - Windows - supported (requires: `pywin32`);

 - Unix - supported (requires: `wnck`, `gtk`);

 - Mac - **not supported** (requires: );



### Examples

	from libs import client

	client.activate()
	client.activate("Chrooooome")
	client.error("There's no more food left...")
	client.fatal("Game over", 666)
	client.debug("Elvis has entered the building")
	client.activate().zoomout().debug("Action!!!")



### API


"""

from PyClient import PyClient
from utils import classproperty
import sys

pyclient = PyClient()

class client:
	
	@classmethod
	def activate(self, window_title = None):
		"""
		 - `client.activate([window_title = "Die Siedler Online"])`  
		   Tries to find game window, activate it and recognize flash-plugin dimensions.  
		   Returns `self`.
		"""
		# searching and activating browser window
		if not pyclient.activate(window_title): self.fatal('Failed to find or activate game window')
		return self

		
	# TODO
	# функции ниже надо сделать кроссплатформенно и на ГУИ. Желательно, чтобы не в виде модал-диалогов, а как-то в виде консольки доступной юзеру
	# TODO надо сделать чтобы несколько мессаджей можно было передавать (моя не умеет на питоне так делать ;))
	@classmethod
	def error(self, message):
		"""
		 - `client.error(message)`  
		   Standart error message.  
		   Returns `self`.
		"""
		print '\033[7;31mError:\033[0;31m ' + message + '\033[0m'
		return self

	
	@classmethod
	def fatal(self, message, code = 1):
		"""
		 - `client.fatal(message, [code = 1])`  
		   Standart fatal error message. Terminates execution with exit `code`.
		"""
		print '\033[7;31mFatal error:\033[0;31m ' + message + '\033[0m'
		sys.exit(code)

	
	@classmethod
	def debug(self, message):
		"""
		 - `client.debug(message)`  
		   Standart debug message.  
		   Returns `self`.
		"""
		print '\033[36m' + message + '\033[0m'
		return self


	@classmethod
	def zoomout(self):
		"""
		 - `client.zoomout()`  
		   Zoom the fuck out!  
		   Returns `self`.
		"""
		for i in range(20): key.press('minus')
		return self
		
