# -*- coding: utf-8 -*-

class PyScreenMeta(object):

	def screen_size(self):
		raise NotImplementedError

	def get_pixel_color(self, x, y):
		raise NotImplementedError

	def get_screenshot(self, left = 0, top = 0, right = None, bottom = None):
		raise NotImplementedError
	

	# NOTE:
	# If some platform sugests a faster "native" implementation
	# of the following methods, it should override them
	
	def screen_width(self):
		return self.screen_size()[0]


	def screen_height(self):
		return self.screen_size()[1]


	def find_pixel(self, color, left = 0, top = 0, right = None, bottom = None, totally = False):
		if right == None: right = self.screen_width()
		if bottom == None: bottom = self.screen_height()
		result = []
		screenshot = self.get_screenshot(left, top, right, bottom).getdata() # flatten array for faster iterate
		w, h = screenshot.size
		for i in range(w * h):
			if screenshot[i] == color:
				result.append((i % w + left, i / w + top)) # i to x,y
				if not totally: return result
		return result


	def find_image(self, image, left = 0, top = 0, right = None, bottom = None, totally = False):
		def fullmatch(screenshot, image, x0, y0, width, height):
			for y in range(height):
				for x in range(width):
					if screenshot[x0 + x, y0 + y] != image[x, y]:
						return False
			return True

		if right == None: right = self.screen_width()
		if bottom == None: bottom = self.screen_height()
		result = []
		screenshot = self.get_screenshot(left, top, right, bottom)
		w1, h1 = screenshot.size
		w2, h2 = image.size
		screenshot, image = screenshot.load(), image.load() # PixelAccess objects => much faster than .getpixel()
		firstpixel = image[0, 0]   # firstly, we are looking for any occurances of first `image` pixel in `screenshot`
		for y in range(h1 - h2 + 1):
			for x in range(w1 - w2 + 1):
				if screenshot[x, y] == firstpixel:
					# if that happened, have to compare `image` and `screenshot`
					# pixel by pixel starting from current (x, y)
					# and if they match - store that (x, y) in `results`
					if fullmatch(screenshot, image, x, y, w2, h2):
						result.append((x + left, y + top))
						if not totally: return result
		return result


	def check_image(self, image, x, y):
		width, height = image.size
		right, bottom = x + width, y + height
		if right > self.screen_width() or bottom > self.screen_height():
			return False
		screenshot = self.get_screenshot(x, y, right, bottom).getdata()
		image = image.getdata()
		for i in range(width * height):
			if screenshot[i] != image[i]:
				return False
		return True


