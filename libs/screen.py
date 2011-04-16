# -*- coding: utf-8 -*-

"""

## `screen`

Screen abstraction layer.


### Common

 - Most methods accept input arguments in several formats:
 
    - points can be passed as `do(x, y)` or `do(point)`, where `point` is a tuple / list of `x` and `y`.

    - boxes can be passed as `do(left, top, right, bottom)` or `do(from_point, to_point)` or `do(rect)`, where `rect` is a tuple / list of `left`, `top`, `right` and `bottom`.

 - Images returned by methods are instances of [Image](http://www.pythonware.com/library/pil/handbook/image.htm) class.


### Supported platforms:

 - Windows - all methods (need tests) (requires: `PIL`, `ctypes`);

 - Unix - all methods (requires: `gtk`, `PIL`, `Xlib`);

 - Mac - **not supported**;


### Examples

from libs import screen

	# dimensions:
	print screen.size       # > (1440, 900)
	print screen.width      # > 1440
	print screen.height     # > 900
	print screen.center     # > (720, 450)

	# retrieving data from screen:
	print screen.pixel(100, 100)      # > (150, 191, 226)
	c = screen.center
	print screen.pixel(c)             # > (35, 35, 35)
	sshot = screen.shot()             # capture entire screen
	sshot.show()                      # show it
	sshot.save('blabla.png')          # save it
	print dir(sshot)                  # show what else it can do
	p1 = (c[0] - 100, c[1] - 100)     # upper left point > (620, 350)
	p2 = (c[0] + 100, c[1] + 100)     # lower bottom point > (820, 550)
	sshot = screen.shot(p1, p2)       # capture 200×200 area
	box = p1 + p2                     # > (620, 350, 820, 550)
	sshot = screen.shot(box)          # capture 200×200 area again
	# Image API: http://www.pythonware.com/library/pil/handbook/image.htm

	# searching on the screen:
	color = (150, 191, 226)               # we got it earlier in (100, 100)
	print screen.find(color)              # > (100, 100) - yep, it's still there
	print screen.locate(color)            # > [(100, 100), (223, 100), (1084, 869)]
	print screen.locate(color, p1)        # > [(1084, 869)]
	print screen.locate(color, p1, p2)    # > []
	print screen.find(color, box)         # > None

	# testing:
	print screen.test(color, 100, 100)    # > True
	print screen.test(color, [223, 100])  # > True
	print screen.test(color, c)           # > False
	print screen.test(sshot, p1)          # > True
	print screen.test(sshot, p2)          # > False


### API

"""

from PyScreen import PyScreen
import PIL, Image
from time import sleep
from utils import classproperty

pyscreen = PyScreen()


def parse_box_args(left, top, right, bottom):
	if isinstance(left, (tuple, list)):
		if len(left) == 4:
			return left
		elif isinstance(top, (tuple, list)):
			return left + top
		else:
			return left + (right, bottom)
	else:
		return left, top, right, bottom


def find_locate(self, object, left, top, right, bottom, multi):
	left, top, right, bottom = parse_box_args(left, top, right, bottom)
	if is_image(object):
		result = pyscreen.find_image(object, left, top, right, bottom, multi)
	elif isinstance(object, (list, tuple)) and len(object) == 3:
		result = pyscreen.find_pixel(object, left, top, right, bottom, multi)
	else:
		raise TypeError, 'Illegal input type: "' + str(what) + '"'
	if multi:
		return result
	elif len(result) == 0:
		return None
	else:
		return result[0]

def is_image(obj):
	return isinstance(obj, (Image.Image, PIL.Image.Image))


class screen(object):
	
	@classproperty
	def size(self):
		"""
		 - `screen.size`  
		   Get current screen size in pixels.  
		   Returns `(width, height)` tuple of 2 integers.  
		   Read-only property.
		"""
		return pyscreen.screen_size()


	@classproperty
	def width(self):
		"""
		 - `screen.width`  
		   Get current screen width in pixels.  
		   Returns integer.  
		   Read-only property.  
		"""
		return pyscreen.screen_width()


	@classproperty
	def height(self):
		"""
		 - `screen.height`  
		   Get current screen height in pixels.  
		   Returns integer.  
		   Read-only property.
		"""
		return pyscreen.screen_height()

		
	@classproperty
	def center(self):
		"""
		 - `screen.center`  
		   Get current screen center point.  
		   Returns `(x, y)` a tuple of 2 integers.  
		   Read-only property.
		"""
		return (self.width / 2, self.height / 2)


	@classmethod
	def pixel(self, x, y = None):
		"""
		 - `screen.pixel(x, y)`  
		   `screen.pixel(point)`  
		   Get the color of given (`x`, `y`)-pixel (or `point`) on the screen.  
		   Returns `(r, g, b)` tuple of 3 integers.
		"""
		if type(x) in (tuple, list): x, y = x
		return pyscreen.get_pixel_color(x, y)


	@classmethod
	def shot(self, left = 0, top = 0, right = None, bottom = None):
		"""
		 - `screen.shot([left = 0, top = 0, right = screen.width, bottom = screen.height])`  
		   `screen.shot([from_point, to_point])`  
		   `screen.shot([box])`  
		   Get screenshot of the screen area.  
		   Returns `Image` object.
		"""
		left, top, right, bottom = parse_box_args(left, top, right, bottom)
		return pyscreen.get_screenshot(left, top, right, bottom)


	@classmethod
	def find(self, object, left = 0, top = 0, right = None, bottom = None):
		"""
		 - `screen.find(object, [left = 0, top = 0, right = screen.width, bottom = screen.height])`  
		   `screen.find(object, [from_point, to_point])`  
		   `screen.find(object, [box])`  
		   If `object` is `(r,g,b)`-color - searches for the pixel of that color on the screen.  
		   If `object` is `Image` - searches for that image on the screen.  
		   Stops on first match.  
		   Returns position of found object as a tuple `(x, y)` of 2 integers if found or `None` if search fails.
		"""
		return find_locate(self, object, left, top, right, bottom, False)


	@classmethod
	def locate(self, object, left = 0, top = 0, right = None, bottom = None):
		"""
		 - `screen.locate(object, [left = 0, top = 0, right = screen.width, bottom = screen.height])`  
		   `screen.locate(object, [from_point, to_point])`  
		   `screen.locate(object, [box])`  
		   If `object` is `(r,g,b)`-color - searches for the pixels of that color on the screen.  
		   If `object` is `Image` - searches for that image on the screen.  
		   Tries to find all occurences.  
		   Returns positions of all found objects in a list of `(x, y)` tuples for each occurrence, empty if search fails.
		"""
		return find_locate(self, object, left, top, right, bottom, True)


	@classmethod
	def test(self, object, x, y = None):
		"""
		 - `screen.test(object, x, y)`  
		   `screen.test(object, point)`  
		   Checks if a given `object` is found in `(x, y)`-positon on the screen.  
		   `object` can be `(r,g,b)`-color or `Image`.  
		   Returns `True` if it is, `False` otherwise.
		"""
		if type(x) in (tuple, list): x, y = x
		if is_image(object):
			return pyscreen.check_image(object, x, y)
		elif isinstance(object, (list, tuple)) and len(object) == 3:
			return pyscreen.get_pixel_color(x, y) == object
		else:
			raise TypeError, 'Illegal input type: "' + str(object) + '"'


