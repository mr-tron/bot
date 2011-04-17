# -*- coding: utf-8 -*-

from Quartz import *
from base import PyScreenMeta

class PyScreen(PyScreenMeta):

	def screen_size(self):
		return CGDisplayPixelsWide(0), CGDisplayPixelsHigh(0)


	def screen_width(self):
		return CGDisplayPixelsWide(0)


	def screen_height(self):
		return CGDisplayPixelsHigh(0)

