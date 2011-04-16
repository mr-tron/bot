# -*- coding: utf-8 -*-

import gtk
from PIL import Image
from Xlib.display import Display
from base import PyScreenMeta

display = Display()


class PyScreen(PyScreenMeta):

	def screen_size(self):
		width  = display.screen().width_in_pixels
		height = display.screen().height_in_pixels
		return width, height


	def screen_width(self):
		return display.screen().width_in_pixels


	def screen_height(self):
		return display.screen().height_in_pixels


	def get_pixel_color(self, x, y):
		pixbuf = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB, False, 8, 1, 1)
		pixbuf.get_from_drawable(gtk.gdk.get_default_root_window(), gtk.gdk.colormap_get_system(), x, y, 0, 0, 1, 1)
		return tuple(pixbuf.get_pixels_array()[0][0])


	def get_screenshot(self, left = 0, top = 0, right = None, bottom = None):
		if right == None: right = self.screen_width()
		if bottom == None: bottom = self.screen_height()
		(width, height) = (right - left, bottom - top)
		pixbuf = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB, False, 8, width, height)
		pixbuf.get_from_drawable(gtk.gdk.get_default_root_window(), gtk.gdk.colormap_get_system(), left, top, 0, 0, width, height)
		image = Image.frombuffer("RGB", (width, height), pixbuf.get_pixels(), "raw", "RGB", pixbuf.get_rowstride(), 1)
		return image


