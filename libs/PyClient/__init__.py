# -*- coding: utf-8 -*-

import sys

if sys.platform == 'darwin':
	from mac import PyClient
elif sys.platform == 'win32':
	from win import PyClient
else:
    from unix import PyClient

