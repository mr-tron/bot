
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

