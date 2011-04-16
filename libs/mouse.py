# -*- coding: utf-8 -*-

"""

## `mouse`

Lib to control the mouse.


### Common
 
 - `speed` -- the speed of mouse movements in the range `1` (fastest) to `100` (slowest). A speed of `0` will move the mouse instantly. Default speed is `10`.

 - `button` -- specifies on which mouse button to perform an action. Posible values are: `1`, `"l"`, `"left"` - for left; `2`, `"r"`, `"right"` - for right; `3`, `"m"`, `"middle"` - for middle. Default is `1`.

 - Methods suppot chaining.


### Supported platforms:

 - All (thanks to [PyMouse](https://github.com/pepijndevos/PyMouse)).


### Examples

	from libs import mouse
	
	# moving:
	mouse.move(100, 100)     # move mouse cursor to point (100, 100) with default speed
	mouse.speed = 5          # make movements faster by default
	mouse.move(200, 200)     # now with `speed` = 5
	point1 = (100, 100)      # some "list-point"
	mouse.move(point, 50)    # move to `point1` very slow
	point2 = [200, 200]      # some "tuple-point"
	mouse.move(point2, 0)    # move to `point2` immediately

	# imitate drag'n'drop:
	mouse.move(item)         # move cursor to item
	mouse.down()             # press down left mouse button
	mouse.sleep(0.5)         # wait a bit
	mouse.move(dest)         # drag item to destination
	mouse.up()               # release mouse button
	
	# the same with chaining:
	mouse.move(item).down().sleep(0.5).move(dest).up()  # who stole my `mouse.`'s??

	# clicks:
	mouse.click()            # simple clicking with left mouse button by default
	mouse.click("right")     # trigger context menu on some item
	mouse.click("r")         # the same
	mouse.click(2)           # the same

	print mouse.position     # > (340, 685)


### API

"""

from PyMouse import PyMouse
from time import sleep
from utils import classproperty

pymouse = PyMouse()

buttons = {'left' : 1, 'right' : 2, 'middle' : 3, 'l' : 1, 'r' : 2, 'm' : 3, 1 : 1, 2 : 2, 3 : 3}

def mouseMoveSmooth(x1, y1, x2, y2, speed):
	"""
	Человекоимитирующий акселератор мыши честно сворован из исходников AutoHotkey
	(http://www.autohotkey.com/), а они в свою очередь взяли у AutoIt.
	(искать в /source/script_autoit.cpp#2053, DoIncrementalMouseMove())
	(x1,y1) - начальная точка,
	(x2,y2) - конечная.
	speed - скорость (точнее, медленность), 0 - мгновенно, больше - медленней
	"""
	
	min_delta = 0.5
	sleeping = 0.030
	speed = float(speed)
	
	def step(c1, c2):
		delta = max(abs(c2 - c1) / speed, min_delta)
		if   c1 < c2: c1 = min(c1 + delta, c2)
		elif c1 > c2: c1 = max(c1 - delta, c2)
		return c1
	
	while x1 != x2 or y1 != y2:
		x1 = step(x1, x2)
		y1 = step(y1, y2)
		pymouse.move(int(x1), int(y1))
		sleep(sleeping)


def parseButton(button):
	if button in buttons: return buttons[button]
	else: raise UserWarning, 'Illegal button input: "' + button + '"' # FIXME как там в ваших питонах это правильно делают?


class mouse:

	speed = 10
	"""
	 - `mouse.speed = 10`  
	   Defines default mouse movement speed. Read & Write property.
	"""

	
	@classmethod
	def move(self, x, y = None, speed = None):
		"""
		 - `mouse.move(x, y, [speed = 10])`  
		   `mouse.move(point, [speed = 10])`  
		    Move mouse cursor to a given `x`, `y` or `point` with a given `speed`.  
		    Returns `self`.
		"""
		if isinstance(x, (list, tuple)):
			speed = y
			x, y = x
		
		if speed == None: speed = self.speed
		if speed == 0:
			pymouse.move(x, y)
		else:
			pos = pymouse.position()
			mouseMoveSmooth(pos[0], pos[1], x, y, speed)
		return self


	@classmethod
	def down(self, button = 1):
		"""
		 - `mouse.down([button = "left"])`  
		   Press given mouse `button`.  
		   Returns `self`.
		"""
		pos = pymouse.position()
		pymouse.press(pos[0], pos[1], parseButton(button))
		return self


	@classmethod
	def up(self, button = 1):
		"""
		 - `mouse.up([button = "left"])`  
		   Release given mouse `button`.  
		   Returns `self`.
		"""
		pos = pymouse.position()
		pymouse.release(pos[0], pos[1], parseButton(button))
		return self


	@classmethod
	def click(self, button = 1):
		"""
		 - `mouse.click([button = "left"])`  
		   Click (press & release) given mouse `button`.  
		   Returns `self`.
		"""
		pos = pymouse.position()
		pymouse.click(pos[0], pos[1], parseButton(button))
		return self


	@classproperty
	def position(self):
		"""
		 - `mouse.position`  
		   Get current mouse cursor position on screen in pixels.  
		   Returns `(x, y)` - a tuple of 2 integers.  
		   Read-only property.
		"""
		return pymouse.position()


	@classmethod
	def sleep(self, seconds):
		"""
		 - `mouse.sleep(seconds)`  
		   Just a handy clone of standart `time.sleep()` for cozy chaining.  
		   Returns `self`.
		"""
		sleep(seconds)
		return self
	

