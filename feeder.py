# -*- coding: utf-8 -*-

import sys

from libs import *
from time import time as microtime
import Image

from libs.utils import tic, tac

from slots import slots, slot_hashes

# TODO:
#CalcMenuDimensions(pos)


class Game:
	
	def __init__(self):
		
		client.activate()
		self.star = Star(self)


class Star:
	
	def __init__(self, game):
		self.center = None
		self.image   = Image.open('res/star-center.png') # linking image of the menu, used for searching it on the screen
		
		# have to locate the star center to deal with it
		client.debug('Locating Star...')
		self.center = screen.find(self.image, client.pos)
		if self.center == None: client.fatal('Failed to find Star center on the screen')
		client.debug('Success. Located Star at: ' + str(self.center))
		
		self.menu = StarMenu(self) # reference to StarMenu object

	def click(self):
		"""
		Move mouse cursor to center of the star and click it.
		"""
		mouse.move(self.center).click()
		return self



class StarMenu:
	
	def __init__(self, star):
		self.never     = True     # whether the menu have never been opened
		self.pos       = None     # position of found image
		self.timeout   = 5        # seconds to wait for menu to be opened
		self.image     = Image.open('res/star-menu-center.png') # linking image of the menu, used for searching it on the screen
		self.star      = star     # reference to Star object
		self.size      = (384, 251)
		self.slot_size = (56, 70)
	
	
	def calc(self):
	
		# Положение меню звезды
		menupos = (self.pos[0] - 191, self.pos[1] + 28)
		
		# Положение первого слота
		first_slot = (menupos[0] + 7, menupos[1] + 11)
		
		# Положение центров слотов меню
		self.slots_pos = [0]
		for row in range(1, 4):
			for col in range(1, 7):
				# Положение центра слота (0.5 - смещение к центру) - место для клика
				self.slots_pos.append((
					int(first_slot[0] + self.slot_size[0] * (col - 0.5)),
					int(first_slot[1] + self.slot_size[1] * (row - 0.5))
				))
	
		# Положения вкладок меню
		self.tabs_open_pos = [0]
		self.tabs_test_pos = [0]
		for tab in range(1, 6):
			# Положение центра вкладки - место для клика (0.5 - смещение к центру)
			self.tabs_open_pos.append((
				menupos[0] + int((tab - 0.5) * self.size[0] / 5),
				menupos[1] + self.size[1] - 15,
			))
			# Положение точки на левом краю вкладки - место для забора цвета для определения её активности
			self.tabs_test_pos.append((
				menupos[0] + int((tab - 1) * self.size[0] / 5) + 5,
				menupos[1] + self.size[1] - 15
			))
	
	
	# Перемещает указатель курсора в вкладки $tab меню звезды
	def point_at_tab(self, tab):
		if self.never: self.open()
		mouse.move(self.tabs_open_pos[tab])
		return self
		

	# Определяет активна ли вкладка меню звезды
	def tab_opened(self, tab):
		# неактивные вкладки : rgb(89,71,45)   = 0x59472D
		# активные вкладки   : rgb(131,102,65) = 0x836641
		if self.never: self.open()
		return screen.pixel(self.tabs_test_pos[tab]) == (131, 102, 65)


	# Активирует заданную вкладку в звезде
	def open_tab(self, tab):

		self.open()
		if self.tab_opened(tab): return True

		self.point_at_tab(tab)
		client.debug('Event: Click at tab #%d' % tab)
		mouse.click()

		timer = microtime()
		while not self.tab_opened(tab):     # ждём пока не откроется вкладка
			if microtime() - timer >= self.timeout:  # устали ждать
				client.error('Не удалось активировать вкладку меню.\nВозможно клиент не успевает реагировать на щелчки мыши. Попробуйте увеличить время ожидания в секции индивидуальных настроек.') # TODO i18n
				return False
		return True


	# Перемещает указатель мыши на центр слота $slot
	def point_at_slot(self, slot):
		if self.never: self.open()
		mouse.move(self.slots_pos[slot])
		return self
	
	
	# for devs
	def get_slot_image(self, slot, savepath = ''):
		if not self.opened: self.open()
		center = self.slots_pos[slot]
		radius = 5
		area = (center[0] - radius, center[1] - radius, center[0] + radius, center[1] + radius)
		image = screen.shot(area)
		if (savepath): image.save(savepath)
		return image
		
	# for easy detecting new or absent slot types
	# just open desired tab in starmenu, run detect_slots()
	# and watch debug console
	def detect_slots(self):
		if not self.opened: self.open()
		client.debug('Detecting slots on opened tab...')
		detected = {}
		for n in range(1, 19):
			saved = ''
			image = menu.get_slot_image(n)
			hash = utils.image_hash(image)
			if hash in slot_hashes:
				slot = slot_hashes[hash]
			elif hash in detected:
				slot = detected[hash]
			else:
				slot = {
					'title' : 'Unknown type of slot #%02d' % n,
					'hash'  : hash
				}
				saved = 'slot-%02d.png' % n
				image.save(saved)
				detected[hash] = slot
			client.debug('   %02d : %s (%s)%s' % (n, slot['title'], slot['hash'], saved and (', saved to "%s"' % saved)))
		client.debug('Found new slot types: %d' % len(detected))
	
	
	def test_slot(self, slot, image):
		if self.never: self.open()
		center = self.slots_pos[slot]
		radius = 5
		pos = (center[0] - radius, center[1] - radius)
		return screen.test(image, pos)
		
	
	@property
	def opened(self):
		"""
		Detects whether menu is opened or not. Returns `True` or `False`.
		"""
		if self.never:
			# for the first time the menu is opened we don't know it's position
			# therefore we have to find it in the client area using it's known linking image
			client.debug('Locating Star menu...')
			self.pos = screen.find(self.image, client.pos)
			if self.pos == None:       # if failed to find
				client.debug('Star menu not found')
				return False           # consider menu is closed
			else:                      # if found
				client.debug('Success. Located Star menu: ' + str(self.pos))
				self.never = False     # not a virgin any more
				self.calc()            # calculate menu dimensions on the basis of found point
				return True            # it is definitely opened
		else:
			# if it has been opened earlier, then we already know
			# it's position and can quickly check if it's there
			return screen.test(self.image, self.pos)

	
	def _wait(self, state, message = None, timeout = None):
		"""
		Waits till menu is in the given `state` (`True` - opened, `False` - closed)
		in a given `timeout`. Shows error-`message` if it is not.
		Returns `True` or `False` - whether it reached given `state` or not.
		"""
		if timeout == None: timeout = self.timeout
		timer = microtime()                      # start the timer
		while self.opened != state:              # constantly check whether it is in desired state
			if microtime() - timer >= timeout:   # if elapsed time is more than timeout, then give up,
				if message: client.error(message)  # show error,
				return False                     # and false-exit
		return True                              # if we got here, then menu is in desired state

	
	def wait_open(self, timeout = None):
		"""
		Waits for menu to be opened in a given `timeout`.
		Returns `True` or `False` - opened or not.
		"""
		message = "Не удалось открыть меню звезды или определить его положение.\nВозможно клиент не успевает реагировать на щелчки мыши. Попробуйте увеличить время ожидания в секции индивидуальных настроек." # TODO i18n
		return self._wait(True, message, timeout)


	def wait_close(self, timeout = None):
		"""
		Waits for menu to be closed in a given `timeout`.
		Returns `True` or `False` - closed or not.
		"""
		message = "Не удалось дождаться закрытия меню звезды." # TODO i18n
		return self._wait(False, message, timeout)
	
	def _toggle(self, state):
		"""
		open(), close() helper
		"""
		if self.opened != state:
			client.debug('Event: Click at Star')
			self.star.click()
			if (state and not self.wait_open()) or (not state and not self.wait_close()):
				sys.exit(1)
		return self

	def open(self):
		"""
		Trys to open the menu - clicks the star and waits till menu is visible.
		Returns `self` on success. **Exits the script** on falure.
		"""
		return self._toggle(True)


	def close(self):
		"""
		Trys to close the menu - clicks the star and waits till menu is hidden.
		Returns `self` on success. **Exits the script** on falure.
		"""
		return self._toggle(False)


slots = {
	'fishfood' : {
		'hash' : '8D6590FB',
		'title' : 'Fish food',
		'type'  : 'food',
	},
	'boost6h' : {
		'hash' : 'AAA378D5',
		'title' : 'Irma\'s basket',
		'type' : 'boost',
	},
}

for slotname, slot in slots.iteritems(): slot['name'] = slotname
slot_hashes = dict((slots[slotname]['hash'], slots[slotname]) for slotname in slots)


def test(expression, error):
	if not expression: client.error(error); raise AssertionError


print slots
print slot_hashes

"""
import time, itertools, zlib
center = (844, 641)
radius = 2
area = (center[0] - radius, center[1] - radius, center[0] + radius, center[1] + radius)
image = screen.shot(area)
print '>>>', zlib.adler32(buffer(bytearray(list(itertools.chain.from_iterable(image.getdata()))))) & 0xffffffff
print '>>>', zlib.adler32(buffer(bytearray(list(itertools.chain.from_iterable(image.getdata())))))
"""

mouse.speed = 5
game = Game()
star = game.star
menu = game.star.menu

menu.open_tab(3)
menu.detect_slots()

menu.close()

print menu.slots_pos[12]


"""
img = menu.get_slot_image(1)
for slot in range(2, 19):
	img2 = menu.get_slot_image(slot)
	print menu.test_slot(slot, img2)
"""


# tests
"""
game.star.menu.open()
test(game.star.menu.opened, 'Menu shoud be opened')
game.star.click()
mouse.sleep(0.5)
test(not game.star.menu.opened, 'Menu shoud be closed')

for tab in range(1, 6):
	game.star.menu.open_tab(tab)
	for i in range(1, 6): test(game.star.menu.tab_opened(i) == (tab == i), 'Tab %d shoud be active' % i)

for slot in range(1, 19):
	game.star.menu.point_at_slot(slot)
"""
