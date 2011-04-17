# -*- coding: utf-8 -*-

import time, itertools, zlib


simple_timing = 0

def tic():
	global simple_timing
	simple_timing = time.time()

def tac(title = 'elapsed'):
	elapsed = time.time() - simple_timing
	print '\033[32m%s: \033[1m%0.2f\033[32m ms\033[0m' % (title, elapsed * 1000)
	return elapsed

def rectsize(rect):
	return (rect[2] - rect[0] + 1, rect[3] - rect[1] + 1)
	
def rectcenter(rect):
	if (len(rect) == 2):
		return (rect[0] / 2, rect[1] / 2)
	else:
		return ((rect[0] + rect[2]) / 2, (rect[1] + rect[3]) / 2)

class classproperty(property):
	"""Subclass property to make classmethod properties possible"""
	def __get__(self, instance, owner):
		return self.fget.__get__(owner, owner)()

def image_hash(image):
	# OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE OPTIMIZE
	# don't use on large images
	return '%08X' % (zlib.adler32(buffer(bytearray(list(itertools.chain.from_iterable(image.getdata()))))) & 0xffffffff)

def rgb(color):
	if type(color) == int:
		return ( (color & 0xff), ((color >> 8) & 0xff), ((color >> 16) & 0xff) )
	return color


def color(r, g = None, b = None):
	if type(r) == list or type(r) == tuple: r, g, b = r
	return (r << 16) + (g << 8) + b;


# алгоритм "в лоб" для определения размеров клиента по изменившимся пикселям.
# тупой перебор. занимает 2 сек на моём компе. ниже оптимизированная версия.
# т.к. код ещё не устоялся - оставил. может кому надо будет.
def diffmotion1(image1, image2, R):

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
def diffmotion(before, after, R):

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

