#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
import pcapy
from impacket.ImpactDecoder import *
out = open("/home/mr_tron/log.txt", "w", 0666)
def recv_pkts(hdr, data):
	x = EthDecoder().decode(data).child()
	#if x.get_ip_src() == "87.119.203.37":
	y = x.child().get_data_as_string()
	out.write(y)
	print y
	
def get_int():
	devs = pcapy.findalldevs()
	i=0
	for eth in devs:
		print " %d - %s" %(i,devs[i])
		i+=1
	sel=input(" Select interface: ")
	dev=devs[sel]
	return dev

dev = 'wlan0'#get_int()
#p = pcapy.open_offline("/home/mr_tron/settlers")
p = pcapy.open_live(dev, 150000, 0, 100)
p.setfilter('tcp')
print "Listening on eth: net=%s, mask=%s\n" % (p.getnet(), p.getmask())
p.loop(-1, recv_pkts) 
