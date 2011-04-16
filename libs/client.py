# -*- coding: utf-8 -*-

"""

## `client`

Here sits all platform-specific stuff not being directly related to the bot logic.

### Common
	


### Supported platforms:

 - Windows - supported (requires: `pywin32`);

 - Unix - supported (requires: `wnck`, `gtk`);

 - Mac - **not supported** (requires: );



### Examples

	from libs import client

	client.activate()
	client.activate("Chrooooome")
	client.error("There's no more food left...")
	client.fatal("Game over", 666)
	client.debug("Elvis has entered the building")
	client.activate().zoomout().debug("Action!!!")



### API


"""

from PyClient import PyClient
from mouse import mouse
from screen import screen
from keyboard import keyboard as key
from utils import classproperty, tic, tac
import utils, sys


pyclient = PyClient()

# алгоритм "в лоб" для определения размеров клиента по изменившимся пикселям.
# тупой перебор. занимает 2 сек на моём компе. ниже оптимизированная версия.
# т.к. код ещё не устоялся - оставил. может кому надо будет.
def dimdetect1(image1, image2, R):
	
	w, h = image1.size
	image1, image2 = image1.load(), image2.load()
	yy, xx = [0] * h, [0] * w
	
	for y in range(h):
		for x in range(w):
			val = int(image1[x, y] == image2[x, y])
			xx[x] += val
			yy[y] += val
	
	yy = [100 * y / w for y in yy]
	xx = [100 * x / h for x in xx]
	
	#print 'Y:', '\n', ' '.join(map(str, yy))
	#print 'X:', '\n', ' '.join(map(str, xx))
	
	def dim(arr, init, inc, R):
		l = len(arr)
		var = init - inc
		while 0 <= (var + inc) < l:
			if arr[var + inc] > R: var += inc
			else: return var;
		return None
	
	l = dim(xx, 0, 1, R)
	r = dim(xx, w - 1, -1, R)
	t = dim(yy, 0, 1, R)
	b = dim(yy, h - 1, -1, R)
	
	return (l, t, r, b + 1)

# оптимизированная версия.
# в 10 раз быстрее чем тупой перебор.
# R = 0..100 (%) - смысл: как только алгоритм найдёт строку/колонку, в которой < R процентов неизменившихся пикселей - это будет граница браузур-клиент.
# before, after - тип Image, скриншоты до и после.
# сделал механизм "смарт"-подстройки параметра R в случае, если не удаётся определить какой-либо размер. Но по-моему херня получилась. Надо ещё тут подумать...
def dimdetect2(before, after, R):
	
	def is_solid(dir, dim, range, lim):
		acc = 0
		for var in range:
			x, y = (var, dim) if dir else (dim, var)
			acc += int(before[x, y] == after[x, y])
			if acc >= lim: return True
		return False

	def scan(dir, step, dim, min, max, range, lim):
		while min <= dim < max:
			if is_solid(dir, dim, range, lim): dim += step
			else: return dim
		return None

	def smartscan(dir, step, init, min, max, rmin, rmax):
		lim = (rmax - rmin + 1) * R / 100
		while lim > 0:
			dim = scan(dir, step, init, min, max, range(rmin, rmax + 1), lim)
			if dim != None: return dim
			else: lim = lim * 9 / 10
		return dim

	W, H = before.size
	before, after = before.load(), after.load()

	#   smartscan(dir, step, init, min, max, rmin, rmax):
	t = smartscan(  1,    1,    0,   0,   H,    0,  W-1)
	b = smartscan(  1,   -1,  H-1, t+1,   H,    0,  W-1)
	l = smartscan(  0,    1,    0,   0,   W,    t,    b)
	r = smartscan(  0,   -1,  W-1, l+1,   W,    t,    b)
	
	return (l - 1, t - 1, r + 1, b + 1 + 1)



class client:
	
	@classmethod
	def activate(self, window_title = None):
		"""
		 - `client.activate([window_title = "Die Siedler Online"])`  
		   Tries to find game window, activate it and recognize flash-plugin dimensions.  
		   Returns `self`.
		"""
		# searching and activating browser window
		if not pyclient.activate(window_title): self.fatal('Failed to find or activate game window')
		
		# trying to recognize flash client dimensions
		# click on client to move the focus in
		mouse.move(screen.center).click().sleep(0.2)
		self.debug('Event: Client focus in')

		key.press('k0').sleep(0.3)
		self.debug('Event: Client goto map center')
	
		before = screen.shot()
	
		# dragging the map for some distance
		self.debug('Event: Client dragging the map for some distance')
		offset = [i - 100 for i in screen.center]
		mouse.down().sleep(0.1).move(offset).sleep(0.1).up().sleep(0.1)
	
		after = screen.shot()
	
		self.debug('Trying to recognize flash client dimensions')
		self.pos = dimdetect2(before, after, 70)
		if None in self.pos: self.fatal('Not all of client dimensions were recognized.')
		self.size = utils.rectsize(self.pos)
		self.center = utils.rectcenter(self.pos)
		self.debug('Success. Client pos: ' + str(self.pos))
		self.debug('Success. Client size: ' + str(self.size))
		
		# if we got here after all, we're lucky ;)
		return self

		
	# TODO
	# функции ниже надо сделать кроссплатформенно и на ГУИ. Желательно, чтобы не в виде модал-диалогов, а как-то в виде консольки доступной юзеру
	# TODO надо сделать чтобы несколько мессаджей можно было передавать (моя не умеет на питоне так делать ;))
	@classmethod
	def error(self, message):
		"""
		 - `client.error(message)`  
		   Standart error message.  
		   Returns `self`.
		"""
		print '\033[7;31mError:\033[0;31m ' + message + '\033[0m'
		return self

	
	@classmethod
	def fatal(self, message, code = 1):
		"""
		 - `client.fatal(message, [code = 1])`  
		   Standart fatal error message. Terminates execution with exit `code`.
		"""
		print '\033[7;31mFatal error:\033[0;31m ' + message + '\033[0m'
		sys.exit(code)

	
	@classmethod
	def debug(self, message):
		"""
		 - `client.debug(message)`  
		   Standart debug message.  
		   Returns `self`.
		"""
		print '\033[36m' + message + '\033[0m'
		return self


	@classmethod
	def zoomout(self):
		"""
		 - `client.zoomout()`  
		   Zoom the fuck out!  
		   Returns `self`.
		"""
		for i in range(20): key.press('minus')
		return self
		
