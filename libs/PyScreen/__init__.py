# -*- coding: utf-8 -*-

import sys

if sys.platform == 'darwin':
	from mac import PyScreen
elif sys.platform == 'win32':
	from win import PyScreen
else:
    from unix import PyScreen

