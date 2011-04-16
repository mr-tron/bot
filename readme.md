

# Istalling

## On Windows

 - download and install **Python** from <http://www.python.org/download/>
 - download and install **pywin32** from <http://sourceforge.net/projects/pywin32>
 - download and install **pyHook** from <http://sourceforge.net/projects/pyhook>
 - download and install **PIL** from <http://www.pythonware.com/products/pil/>
 - run script files with double-click

quicklinks:
  • [python/2.7.1](http://www.python.org/ftp/python/2.7.1/python-2.7.1.msi)
  • [pywin32/216](http://sourceforge.net/projects/pywin32/files/pywin32/Build216/pywin32-216.win32-py2.7.exe/download)
  • [pyHook/1.5.1](http://sourceforge.net/projects/pyhook/files/pyhook/1.5.1/pyHook-1.5.1.win32-py2.7.exe/download)
  • [PIL/1.1.7](http://effbot.org/downloads/PIL-1.1.7.win32-py2.7.exe)


## On Unix

**TODO**


## On Mac

**TODO**



# Libs


## `mouse`

Lib to control the mouse.


### Common
 
 - `speed` -- the speed of mouse movements in the range `1` (fastest) to `100` (slowest). A speed of `0` will move the mouse instantly. Default speed is `10`.

 - `button` -- specifies on which mouse button to perform an action. Posible values are: `1`, `"l"`, `"left"` - for left; `2`, `"r"`, `"right"` - for right; `3`, `"m"`, `"middle"` - for middle. Default is `1`.

 - Methods suppot chaining.


### Supported platforms:

 - All (thanks to [PyMouse](https://github.com/pepijndevos/PyMouse)).


### Examples

	from libs import mouse
	
	# moving:
	mouse.move(100, 100)     # move mouse cursor to point (100, 100) with default speed
	mouse.speed = 5          # make movements faster by default
	mouse.move(200, 200)     # now with `speed` = 5
	point1 = (100, 100)      # some "list-point"
	mouse.move(point, 50)    # move to `point1` very slow
	point2 = [200, 200]      # some "tuple-point"
	mouse.move(point2, 0)    # move to `point2` immediately

	# imitate drag'n'drop:
	mouse.move(item)         # move cursor to item
	mouse.down()             # press down left mouse button
	mouse.sleep(0.5)         # wait a bit
	mouse.move(dest)         # drag item to destination
	mouse.up()               # release mouse button
	
	# the same with chaining:
	mouse.move(item).down().sleep(0.5).move(dest).up()  # who stole my `mouse.`'s??

	# clicks:
	mouse.click()            # simple clicking with left mouse button by default
	mouse.click("right")     # trigger context menu on some item
	mouse.click("r")         # the same
	mouse.click(2)           # the same

	print mouse.position     # > (340, 685)


### API

 - `mouse.speed = 10`  
   Defines default mouse movement speed. Read & Write property.

 - `mouse.move(x, y, [speed = 10])`  
   `mouse.move(point, [speed = 10])`  
    Move mouse cursor to a given `x`, `y` or `point` with a given `speed`.  
    Returns `self`.

 - `mouse.down([button = "left"])`  
   Press given mouse `button`.  
   Returns `self`.

 - `mouse.up([button = "left"])`  
   Release given mouse `button`.  
   Returns `self`.

 - `mouse.click([button = "left"])`  
   Click (press & release) given mouse `button`.  
   Returns `self`.

 - `mouse.position`  
   Get current mouse cursor position on screen in pixels.  
   Returns `(x, y)` - a tuple of 2 integers.  
   Read-only property.

 - `mouse.sleep(seconds)`  
   Just a handy clone of standart `time.sleep()` for cozy chaining.  
   Returns `self`.




## `screen`

Screen abstraction layer.


### Common

 - Most methods accept input arguments in several formats:
 
    - points can be passed as `do(x, y)` or `do(point)`, where `point` is a tuple / list of `x` and `y`.

    - boxes can be passed as `do(left, top, right, bottom)` or `do(from_point, to_point)` or `do(rect)`, where `rect` is a tuple / list of `left`, `top`, `right` and `bottom`.

 - Images returned by methods are instances of [Image](http://www.pythonware.com/library/pil/handbook/image.htm) class.


### Supported platforms:

 - Windows - all methods (need tests) (requires: `PIL`, `ctypes`);

 - Unix - all methods (requires: `gtk`, `PIL`, `Xlib`);

 - Mac - **not supported**;


### Examples

from libs import screen

	# dimensions:
	print screen.size       # > (1440, 900)
	print screen.width      # > 1440
	print screen.height     # > 900
	print screen.center     # > (720, 450)

	# retrieving data from screen:
	print screen.pixel(100, 100)      # > (150, 191, 226)
	c = screen.center
	print screen.pixel(c)             # > (35, 35, 35)
	sshot = screen.shot()             # capture entire screen
	sshot.show()                      # show it
	sshot.save('blabla.png')          # save it
	print dir(sshot)                  # show what else it can do
	p1 = (c[0] - 100, c[1] - 100)     # upper left point > (620, 350)
	p2 = (c[0] + 100, c[1] + 100)     # lower bottom point > (820, 550)
	sshot = screen.shot(p1, p2)       # capture 200×200 area
	box = p1 + p2                     # > (620, 350, 820, 550)
	sshot = screen.shot(box)          # capture 200×200 area again
	# Image API: http://www.pythonware.com/library/pil/handbook/image.htm

	# searching on the screen:
	color = (150, 191, 226)               # we got it earlier in (100, 100)
	print screen.find(color)              # > (100, 100) - yep, it's still there
	print screen.locate(color)            # > [(100, 100), (223, 100), (1084, 869)]
	print screen.locate(color, p1)        # > [(1084, 869)]
	print screen.locate(color, p1, p2)    # > []
	print screen.find(color, box)         # > None

	# testing:
	print screen.test(color, 100, 100)    # > True
	print screen.test(color, [223, 100])  # > True
	print screen.test(color, c)           # > False
	print screen.test(sshot, p1)          # > True
	print screen.test(sshot, p2)          # > False


### API

 - `screen.size`  
   Get current screen size in pixels.  
   Returns `(width, height)` tuple of 2 integers.  
   Read-only property.

 - `screen.width`  
   Get current screen width in pixels.  
   Returns integer.  
   Read-only property.  

 - `screen.height`  
   Get current screen height in pixels.  
   Returns integer.  
   Read-only property.

 - `screen.center`  
   Get current screen center point.  
   Returns `(x, y)` a tuple of 2 integers.  
   Read-only property.

 - `screen.pixel(x, y)`  
   `screen.pixel(point)`  
   Get the color of given (`x`, `y`)-pixel (or `point`) on the screen.  
   Returns `(r, g, b)` tuple of 3 integers.

 - `screen.shot([left = 0, top = 0, right = screen.width, bottom = screen.height])`  
   `screen.shot([from_point, to_point])`  
   `screen.shot([box])`  
   Get screenshot of the screen area.  
   Returns `Image` object.

 - `screen.find(object, [left = 0, top = 0, right = screen.width, bottom = screen.height])`  
   `screen.find(object, [from_point, to_point])`  
   `screen.find(object, [box])`  
   If `object` is `(r,g,b)`-color - searches for the pixel of that color on the screen.  
   If `object` is `Image` - searches for that image on the screen.  
   Stops on first match.  
   Returns position of found object as a tuple `(x, y)` of 2 integers if found or `None` if search fails.

 - `screen.locate(object, [left = 0, top = 0, right = screen.width, bottom = screen.height])`  
   `screen.locate(object, [from_point, to_point])`  
   `screen.locate(object, [box])`  
   If `object` is `(r,g,b)`-color - searches for the pixels of that color on the screen.  
   If `object` is `Image` - searches for that image on the screen.  
   Tries to find all occurences.  
   Returns positions of all found objects in a list of `(x, y)` tuples for each occurrence, empty if search fails.

 - `screen.test(object, x, y)`  
   `screen.test(object, point)`  
   Checks if a given `object` is found in `(x, y)`-positon on the screen.  
   `object` can be `(r,g,b)`-color or `Image`.  
   Returns `True` if it is, `False` otherwise.




## `keyboard`

Keyboard abstraction layer.


### Common
	
 - To specify several keys join them with `"+"`: `"ctrl+a"`.  

 - Keycodes are case-insensitive.

    TODO: Key codes...


### Supported platforms:

 - Windows - supported (requires: `pywin32`);

 - Unix - supported (requires: `Xlib`);

 - Mac - **not supported** (requires: );


### Examples

	from libs import keyboard as key

	key.press('plus')
	key.press('minus')
	key.press('f1')
	key.press('ctrl+alt+del')


### API

 - `keyboard.down(keys)`  
   Press down given keyboard `keys`.  
   Returns `self`.

 - `keyboard.up(keys)`  
   Release given keyboard `keys`.  
   Returns `self`.

 - `keyboard.press(keys)`  
   Press (press down & release) given keyboard `keys`.  
   Returns `self`.

 - `keyboard.sleep(seconds)`  
   Just a handy clone of standart `time.sleep()` for cozy chaining.  
   Returns `self`.




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

 - `client.activate([window_title = "Die Siedler Online"])`  
   Tries to find game window, activate it and recognize flash-plugin dimensions.  
   Returns `self`.

 - `client.error(message)`  
   Standart error message.  
   Returns `self`.

 - `client.fatal(message, [code = 1])`  
   Standart fatal error message. Terminates execution with exit `code`.

 - `client.debug(message)`  
   Standart debug message.  
   Returns `self`.

 - `client.zoomout()`  
   Zoom the fuck out!  
   Returns `self`.



****************************************************************************************************************



у нас должны стоять пакеты для работы с xlib и gtk в python.
в моём случае (ubuntu 10.10) это python-gtk2 и python-xlib



****************************

модуль koordinat_seacher:
функция find_template принимает в качестве параметров изображение в котором ищем образец, образец изображения, и флаг full, который по-умолчанию установлен в положение False и означает поиск до первого совпадения. соответственно True - поиск всех совпадений. поиск задача достаточно требовательная к ресурсам.
возвращает список кортежей (x,y) с координатами совпадений. координаты указываются для левого верхнего пикселя совпадающего участка. если ничего не найдено то возвращает пустой список.

собственно зачем нужна функция: поиск ключевых элементов интерфейса от которых измеряются координаты кликов. также можно использовать для составления карты своего острова, для поиска иссякших полей и колодцев.

пример использования:
<code>
from koordinat_seacher import find_template
from PIL import Image
searchImage = Image.open("/home/mr_tron/work/settlers/3.png")
templateImage = Image.open("/home/mr_tron/work/settlers/template.png")
print find_template(searchImage, templateImage)
</code>
******************************************

модуль pixel_colour:
функция get_colour получает кортеж из двух координат (x,y), возвращает цвет пикселя ввиде списка [R,G,B]
зачем нужна: проверять состояние экрана. не потерялся ли коннект к серверу, открылось ли нужное окно и т.п. логично предположить, что это быстрее поиска совпадений картинок.

пример использования:
<code>
from pixel_colour import get_colour
a = (123,456)
get_colour(a)
</code>
вернёт что-то типа [224, 216, 209]. при поиске координаты за пределами экрана вернёт [0,0,0]

функцию я выпилил из чьего-то кода в интернетах. шлёт в стандартный вывод какой-то ворнинг, но работает. лень разбираться - над в исходники gtk кажись лезть. если кто разберётся - буду благодарен.

******************************************************

модуль clicker:
эмуляцию мыши я нашёл взял готовую - pymouse. чуток её поправил. класс mymouse имеет три метода: left, right, middle, каждый из которых принимает кортеж из двух координат для клика левой, правой или средней кнопкой мыши соответственно. и метод drag, который принимает два кортежаЖ с координатами откуда тащим и координатами куда тащим.
Пример использования
<code>
from clicker import mymouse
m = mymouse()
a = (10,10)
b = (30,40)
m.left(a)
m.drag(b,a)
</code>
переместит курсор и кликнет левой кнопкой мыши в экран точке (10,10), потом схватит объект в точке (40,40) и перетащит в точку (10,10)


******************************************

модуль screenshot имеет единственную функцию get_screenshot, которая возвращает объект-картинку, содержащую скриншот монитора. применять в сочетании с поиском координат.


<code>
from koordinat_seacher import find_template
from PIL import Image
from screenshot import get_screenshot
search_image = get_screenshot()
template_image = Image.open("/home/mr_tron/work/settlers/template.png")
print find_template(search_image, template_image)
</code>


*******************************************
модуль window_activate имеет внутри одноименную функцию, которая принимает заголовок окна, которое надо вывести на передний план. при незаданном параметре выводит окно с заголовком Die Siedler Online.
использование очень простое: 

import window_activate
window_activate.window_activate() 



*******************************************
модуль send_key
работает похоже на эмуляцию мыши. создаётся объект класса my_keyboard, который имеет метод send. метод принимает коды клавиш или кортеж из двух значений для нажатий клавиши с модификатором. типа alt+f4
в классе keycodes (и его синониме кратком kc) содержатся коды осноных клавишь. 
<code>
from send_key import my_keyboard, kc

k = my_keyboard()
k.send(kc.f1)
</code>
