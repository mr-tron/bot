#!/usr/bin/env python
# -*- coding: utf-8 -*-
def find_template(search_image, template_image, full=False): #передаём исходное изображение, образец поиска и флаг искать до конца или первого совпадения
	results = [] #кортеж с результатами поиска
	search_width = search_image.size[0]
	search_height = search_image.size[1]
	template_first_pixel = template_image.getpixel((0,0)) 
	for ys in range(search_height):
		for xs in range(search_width):
			search_pixel = search_image.getpixel((xs,ys))
			if search_pixel == template_first_pixel: #если первый пиксель темплейта совпадае с одним из перебираемых пикселей,то запускаем попиксельное сравнение
				result = template_compare(search_image, template_image, xs, ys)
				if full == False and result != None:
					return [result]
				elif full != False and result != None:
					results.append(result) 					
	return results

def template_compare(search_image, template_image, xs, ys): #служебная подфункция
	template_width = template_image.size[0]
	template_height = template_image.size[1]
	search_width = search_image.size[0]
	search_height = search_image.size[1]
	if template_width + xs > search_width or template_height + ys > search_height:
		return None
	for yt in range(template_height):
		for xt in range(template_width):
			template_pixel = template_image.getpixel((xt,yt))
			search_pixel = search_image.getpixel((xs+xt,ys+yt))
			if search_pixel != template_pixel:
				return None
	return xs, ys	
