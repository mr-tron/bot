#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
import wnck
import gtk
from time import time

def window_activate(browser_title = 'Die Siedler Online'):
	
	wnck_screen = wnck.screen_get_default()
	while gtk.events_pending(): gtk.main_iteration()
	
	wnck_windows = [w for w in wnck_screen.get_windows() if w.get_name().find(browser_title) >= 0]
	if len(wnck_windows) == 0:
	    print 'Not found browser window'
	else:
	    wnck_window = wnck_windows[0]
	    wnck_window.activate(int(time()))
	
