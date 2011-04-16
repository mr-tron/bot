# -*- coding: utf-8 -*-

import sys

if sys.platform == 'darwin':
	from mac import PyKeyboard
elif sys.platform == 'win32':
	from win import PyKeyboard
else:
    from unix import PyKeyboard

