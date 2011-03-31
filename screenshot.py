#!/usr/bin/env python
# -*- coding: utf-8 -*-
import gtk
def get_screenshot():
	screenshot = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB, 0, 8, gtk.gdk.screen_width(), gtk.gdk.screen_height())
	screenshot.get_from_drawable(gtk.gdk.get_default_root_window(), gtk.gdk.colormap_get_system(), 0, 0, 0, 0, gtk.gdk.screen_width(), gtk.gdk.screen_height())
#	screenshot.save('temp.png', 'png') # для отладки. сохраняет в файл
	return screenshot
	
