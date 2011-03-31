#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pymouse import PyMouse
from time import sleep
class mymouse(PyMouse):
	def left(self, pixel):
		self.click(pixel[0],pixel[1],1)
		return None
	def right(self, pixel):
		self.click(pixel[0],pixel[1],2)
		return None
	def middle(self, pixel):
		self.click(pixel[0],pixel[1],3)
		return None
	def drag(self, start_pixel, end_pixel):
		self.press(start_pixel[0], start_pixel[1], 1)
		sleep(0.5)
		self.move(end_pixel[0], end_pixel[1])
		self.release(end_pixel[0], end_pixel[1], 1)
