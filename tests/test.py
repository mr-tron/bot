#!/usr/bin/env python
# -*- coding: utf-8 -*-
from koordinat_seacher import find_template
from PIL import Image
from screenshot import get_screenshot
search_image = get_screenshot()
template_image = Image.open("/home/mr_tron/downloads/template.png")
#print find_template(search_image, template_image)

from send_key import my_keyboard, kc

k = my_keyboard()
k.send(10)

