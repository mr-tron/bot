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
