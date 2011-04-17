
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


