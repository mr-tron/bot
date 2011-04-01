#!/usr/bin/env python
# -*- coding: utf-8 -*-
import gtk
from PIL import Image
import sys

def get_screenshot_linux():
	sshot = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB, 0, 8, gtk.gdk.screen_width(), gtk.gdk.screen_height())
	sshot.get_from_drawable(gtk.gdk.get_default_root_window(), gtk.gdk.colormap_get_system(), 0, 0, 0, 0, gtk.gdk.screen_width(), gtk.gdk.screen_height())
#	sshot.save('temp.png', 'png') # для отладки. сохраняет в файл
	img = Image.frombuffer("RGB", (sshot.get_width(), sshot.get_height()), sshot.get_pixels(), "raw", "RGB",sshot.get_rowstride(),1)
	return img
	
def get_screenshot_win():
	from PIL import ImageGrab
	img = ImageGrab.grab()
	return img

def get_screenshot():
	if sys.platform == 'win32':
		return get_screenshot_win()
	else:
		return get_screenshot_linux()
