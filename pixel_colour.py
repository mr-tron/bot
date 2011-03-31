#!/usr/bin/env python
# -*- coding: utf-8 -*-
import gtk # python-gtk
def get_colour(pixel):
	o_gdk_pixbuf = gtk.gdk.Pixbuf(gtk.gdk.COLORSPACE_RGB, False, 8, 1, 1)
	o_gdk_pixbuf.get_from_drawable(gtk.gdk.get_default_root_window(), gtk.gdk.colormap_get_system(), pixel[0], pixel[1], 0, 0, 1, 1)
	return o_gdk_pixbuf.get_pixels_array().tolist()[0][0]
