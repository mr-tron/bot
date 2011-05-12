# -*- coding: utf-8 -*-

import sys

from libs import *
from time import time as microtime
import Image
import itertools

from libs.utils import tic, tac

from objects import slots, slot_hashes, objects



class Game:
	
	def __init__(self):
		
		sleeping = 0.1
		
		client.debug('> Trying to activate client').activate()
		
		self.star = Star(self)
		
		# trying to recognize flash client dimensions
		# click on client to move the focus in
		client.debug('Event: Client focus in')
		mouse.move(screen.center).click().sleep(sleeping)
		
		# here we trigger starmenu location and calculation it's dimensions
		if self.star.menu.opened:
			self.star.menu.close() # and close it to let us send mouse and keyboard event to the client
			mouse.move(screen.center) # move mouse pointer away from Star
		
		client.debug('Event: Client goto map center')
		key.press('0').sleep(3*sleeping)
		
		before = screen.shot()
		
		# dragging the map for some distance
		client.debug('Event: Client dragging the map for some distance')
		offset = (screen.center[0] - 100, screen.center[1] - 100)
		mouse.down().sleep(sleeping).move(offset).sleep(sleeping).up().sleep(sleeping)
	
		after = screen.shot()
	
		client.debug('> Trying to recognize flash client dimensions')
		client.pos = utils.diffmotion(before, after, 70)
		if None in client.pos: client.fatal('Not all of client dimensions were recognized.')
		client.size = utils.rectsize(client.pos)
		client.center = utils.rectcenter(client.pos)
		client.debug('Success. Client pos: ' + str(client.pos))
		client.debug('Success. Client size: ' + str(client.size))

		key.press('0').sleep(3*sleeping)
		for i in range(10): key.press('minus')
		key.sleep(5*sleeping)


class Star:
	
	def __init__(self, game):
		self.center = None
		self.image   = Image.open('res/star-center.png') # linking image of the menu, used for searching it on the screen
		
		# have to locate the star center to deal with it
		client.debug('> Trying to locate Star...')
		self.center = screen.find(self.image)
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
		self.timeout   = 3        # seconds to wait for menu to be opened
		self.image     = Image.open('res/star-menu-center.png') # linking image of the menu, used for searching it on the screen
		self.star      = star     # reference to Star object
		self.size      = (384, 251)
		self.slot_size = (56, 70)
	
	
	def gauge(self):
	
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
		if self.tab_opened(tab): return self

		self.point_at_tab(tab)
		client.debug('Event: Click at tab #%d' % tab)
		mouse.click()

		timer = microtime()
		while not self.tab_opened(tab):     # ждём пока не откроется вкладка
			if microtime() - timer >= self.timeout:  # устали ждать
				client.error('Не удалось активировать вкладку меню.\nВозможно клиент не успевает реагировать на щелчки мыши. Попробуйте увеличить время ожидания в секции индивидуальных настроек.') # TODO i18n
		return self


	# Перемещает указатель мыши на центр слота $slot
	def point_at_slot(self, slot):
		if self.never: self.open()
		mouse.move(self.slots_pos[slot])
		return self
	
	
	def get_slot_image(self, slot, savepath = ''):
		if not self.opened: self.open()
		center = self.slots_pos[slot]
		radius = 5
		area = (center[0] - radius, center[1] - radius, center[0] + radius, center[1] + radius)
		image = screen.shot(area)
		if (savepath): image.save(savepath)
		return image

	def get_slot_hash(self, slot):
		return utils.image_hash(self.get_slot_image(slot))
		
		
	# for easy detecting new or absent slot types
	# just open desired tab in starmenu, run detect_slots()
	# and watch debug console
	def detect_slots(self):
		if not self.opened: self.open()
		client.debug('\033[1;33mDetecting slots on opened tab...\033[0m')
		detected = {}
		for n in range(1, 19):
			saved = ''
			image = self.get_slot_image(n)
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
			if (saved): print '\033[32m   %02d : \033[1m%s\033[0;32m %s, saved to "\033[1m%s\033[0;32m"\033[0m' % (n, slot['hash'], slot['title'], saved)
			else:       print '\033[33m   %02d : \033[1m%s\033[0;33m %s\033[0m' % (n, slot['hash'], slot['title'])
		print '\033[33mFound new slot types: \033[1m%d\033[0m' % len(detected)
		return self
	
	
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
			self.pos = screen.find(self.image)
			if self.pos == None:       # if failed to find
				client.debug('Star menu not found')
				return False           # consider menu is closed
			else:                      # if found
				client.debug('Success. Located Star menu: ' + str(self.pos))
				self.never = False     # not a virgin any more
				self.gauge()            # calculate menu dimensions on the basis of found point
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

	
	def wait_open(self, verbose = True, timeout = None):
		"""
		Waits for menu to be opened in a given `timeout`.
		Returns `True` or `False` - opened or not.
		"""
		message = "Не удалось открыть меню звезды или определить его положение.\nВозможно клиент не успевает реагировать на щелчки мыши. Попробуйте увеличить время ожидания в секции индивидуальных настроек." if verbose else '' # TODO i18n
		return self._wait(True, message, timeout)


	def wait_close(self, verbose = True, timeout = None):
		"""
		Waits for menu to be closed in a given `timeout`.
		Returns `True` or `False` - closed or not.
		"""
		message = "Не удалось дождаться закрытия меню звезды." if verbose else '' # TODO i18n
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



mouse.speed = 1.8
game = Game()
menu = game.star.menu


print 'client.center:', client.center
kopilo = {}
def gc(key): cc = (960, 631); mp = mouse.position; op = (mp[0] - cc[0], mp[1] - cc[1]); kopilo[key] = { 'pos' : op, 'res' : 'meat', 'type' : 'deposit' }


# Перемещает указатель мыши в точку dest, заданную в относительных координатах (`objects`)
def goto(x, y = None):
	if isinstance(x, (list, tuple)): x, y = x
	c = list(client.center)
	if client.size[1] < 800: c[1] = client.pos[1] + 400
	mouse.move(x + c[0], y + c[1])

# Перемещает указатель мыши на центр слота $slot
def mouse_move_to_slot(slot):
	self = game.star.menu
	if self.never: self.open()
	mouse.move(self.slots_pos[slot])

# Определяет соответствует ли слот $slot типу $type (по хэшу)
def is_slot_of_type(slot, hashes):
	self = game.star.menu
	return self.get_slot_hash(slot) in hashes


# Ищет во всём меню первый слот с типом $type, начиная со слота $start
def find_slot_by_hash(hashes):
	self = game.star.menu
	self.open()
	for slot in range(1, 19):
		if is_slot_of_type(slot, hashes): return slot
	return None


def select_slot(hashes):
	self = game.star.menu
	# Ищем первый подходящий ресурс в звезде.
	# Загвоздка в том, что найденный ресурс может сдвинуться в списке пока мы к нему мышкой ползли...
	while True:
		slot = find_slot_by_hash(hashes)       # ищем слот
		if slot == None: return False            # если не нашли - кормить нечем, выходим
		mouse_move_to_slot(slot)                    # иначе, перемешаем курсор на найденный слот ресурса
		if is_slot_of_type(slot, hashes):  # если пока курсор двигался этот слот не пропал, то
			mouse.click()                          # быстренько кликаем по слоту с ресурсом
			if self.wait_close(False):           # и ждём закрытия окна звезды - открылось - продолжаем, иначе - снова идём в начало цикла
				return True                                # эта проверка нужна потому что иногда случается, что клик по слоту происходит в тот момент,
			else:                                       # когда клиент обновляет менюшку и клик не защитывает, следовательно слот не выбирается,
				continue                               # меню не закрывается, значит нужно снова всё повторить.


# setl -> slot-employ-target-loop :)
def _setl(targets, count = '*', accepts = None):
	self = game
	
	if isinstance(targets, str):
		targets = [objects[t] for r in (ranges.split('-') for ranges in targets.split(',')) for t in range(int(r[0]), int(r[-1]) + 1)]
	elif isinstance(targets, int):
		targets = [objects[targets]]
	elif isinstance(targets, (list, tuple)):
		targets = (objects[t] for t in targets)
	else:
		raise TypeError
	
	targets = itertools.cycle(targets)
	
	if count == '?': # TODO: ask user
		count = '*'
	elif count == '-': # don't loop over targets
		count = len(targets)
	elif count == '*': # endless
		count = '*'
	elif not isinstance(count, int) or count <= 0: # illegal
		raise TypeError

	feeded = 0  # лунок накормлено (точнее, количество успешных попыток)
	
	while count == '*' or feeded < count:
		target = targets.next()
		self.star.menu.open_tab(4) # TODO generalize
		if not select_slot(accepts or target['accepts']):
			client.error('Не найдено доступных слотов с кормёжкой. Накормлено: %d' % feeded)
			return feeded
		goto(target['pos']) # перемешаем курсор на target
		mouse.sleep(0.1).click().sleep(0.2)    # кликаем по лунке, тобиш кормим её
		feeded += 1      # считаем, что накормили
	
	client.debug('Очередь кормёжки закончена. Накормлено: %d' % feeded)
	return feeded

# Выполняет серию кормёжек лунки
#   $targets  -  номера лункок, которые требуется кормить в виде "1,5,32-33". Если указано несколько лунок, то кормить будет поочереди
#   $count    -  общее количество кормёжек, если 0, то спросить у пользователя
def feed(targets, count = '?'):
	self = game
	# TODO only deposits
	return _setl(targets, count)

def settle(count = '?'):
	# TODO only settlers
	return _setl(0, count, slots['settler']['hash'])

def drop(count = '*'):
	# TODO exclude settlers
	return _setl(0, count)


#mouse.speed = 2
#menu.detect_slots()
#feed('32-33')
#drop()
#settle('*')


"""
for i in range(20):
	key.down('left').sleep(0.2).up('left')
"""
#menu.open_tab(3).detect_slots().close()




