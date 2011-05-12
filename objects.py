
slots = {
	'fish-food' : {
		'hash'  : '8D6590FB',
		'title' : 'Fish food',
		'type'  : 'food',
	},
	'meat-food' : {
		'hash'  : '29AB81DB',
		'title' : 'Meat food',
		'type'  : 'food',
	},
	'stone' : {
		'hash'  : '5F2990E7',
		'title' : '+ Stone',
		'type'  : 'res',
	},
	'fir-wood-planks' : {
		'hash'  : 'A61C58B2',
		'title' : '+ Fir wood planks',
		'type'  : 'res',
	},
	'marble' : {
		'hash'  : '52DBB76F',
		'title' : '+ Marble',
		'type'  : 'res',
	},
	'hard-wood-planks' : {
		'hash'  : '382170A6',
		'title' : '+ Hard wood planks',
		'type'  : 'res',
	},
	'gold' : {
		'hash'  : '77A590E8',
		'title' : '+ Gold',
		'type'  : 'res',
	},
	'iron-sword' : {
		'hash'  : '18207052',
		'title' : '+ Iron sword',
		'type'  : 'res',
	},
	'bow' : {
		'hash'  : 'CE1A5084',
		'title' : '+ Bow',
		'type'  : 'res',
	},
	'easter-egg' : {
		'hash'  : 'B5F6B2E8',
		'title' : '+ Easter egg',
		'type'  : 'res',
	},
	'boost6h' : {
		'hash'  : 'AAA378D5',
		'title' : "Irma's basket",
		'type'  : 'boost',
	},
	'settler' : {
		'hash'  : '3B6D9377',
		'title' : 'Settler',
		'type'  : 'settler',
	},
}

for slotname, slot in slots.iteritems(): slot['name'] = slotname
slot_hashes = dict((slots[slotname]['hash'], slots[slotname]) for slotname in slots)



objects = {
	0  : {'res': None,   'type': 'city',    'pos': (-364, 265)},
	1  : {'res': 'fish', 'type': 'deposit', 'pos': (-258, 425)},
	2  : {'res': 'fish', 'type': 'deposit', 'pos': (-305, 426)},
	3  : {'res': 'fish', 'type': 'deposit', 'pos': (-447, 427)},
	4  : {'res': 'fish', 'type': 'deposit', 'pos': (-575, 433)},
	5  : {'res': 'fish', 'type': 'deposit', 'pos': (-470, 338)},
	6  : {'res': 'fish', 'type': 'deposit', 'pos': (-608, 253)},
	7  : {'res': 'fish', 'type': 'deposit', 'pos': (-565, -194)},
	8  : {'res': 'fish', 'type': 'deposit', 'pos': (-529, -230)},
	9  : {'res': 'fish', 'type': 'deposit', 'pos': (-656, -266)},
	10 : {'res': 'fish', 'type': 'deposit', 'pos': (-657, -281)},
	11 : {'res': 'fish', 'type': 'deposit', 'pos': (-469, -283)},
	12 : {'res': 'fish', 'type': 'deposit', 'pos': (-330, -339)},
	13 : {'res': 'fish', 'type': 'deposit', 'pos': (-166, -367)},
	14 : {'res': 'fish', 'type': 'deposit', 'pos': (-141, -366)},
	15 : {'res': 'fish', 'type': 'deposit', 'pos': (724, 309)},
	16 : {'res': 'fish', 'type': 'deposit', 'pos': (701, 309)},
	17 : {'res': 'fish', 'type': 'deposit', 'pos': (630, 253)},
	18 : {'res': 'fish', 'type': 'deposit', 'pos': (583, 281)},
	19 : {'res': 'fish', 'type': 'deposit', 'pos': (513, 426)},
	20 : {'res': 'fish', 'type': 'deposit', 'pos': (444, 396)},
	21 : {'res': 'fish', 'type': 'deposit', 'pos': (-119, 122)},
	22 : {'res': 'fish', 'type': 'deposit', 'pos': (-37, 43)},
	23 : {'res': 'fish', 'type': 'deposit', 'pos': (-95, -22)},
	24 : {'res': 'fish', 'type': 'deposit', 'pos': (-189, -79)},
	25 : {'res': 'fish', 'type': 'deposit', 'pos': (-305, -65)},
	26 : {'res': 'meat', 'type': 'deposit', 'pos': (-83, 346)},
	27 : {'res': 'meat', 'type': 'deposit', 'pos': (-84, 246)},
	28 : {'res': 'meat', 'type': 'deposit', 'pos': (-622, -287)},
	29 : {'res': 'meat', 'type': 'deposit', 'pos': (-306, -266)},
	30 : {'res': 'meat', 'type': 'deposit', 'pos': (-24, -410)},
	31 : {'res': 'meat', 'type': 'deposit', 'pos': (244, -330)},
	32 : {'res': 'meat', 'type': 'deposit', 'pos': (514, -267)},
	33 : {'res': 'meat', 'type': 'deposit', 'pos': (536, -252)},
	34 : {'res': 'meat', 'type': 'deposit', 'pos': (595, -115)},
	35 : {'res': 'meat', 'type': 'deposit', 'pos': (606, -94)},
	36 : {'res': 'meat', 'type': 'deposit', 'pos': (372, 35)},
	37 : {'res': 'meat', 'type': 'deposit', 'pos': (607, 93)},
	38 : {'res': 'meat', 'type': 'deposit', 'pos': (758, 201)},
	39 : {'res': 'meat', 'type': 'deposit', 'pos': (513, 281)},
	40 : {'res': 'meat', 'type': 'deposit', 'pos': (173, 389)},
	41 : {'res': 'meat', 'type': 'deposit', 'pos': (173, 259)},
	42 : {'res': 'meat', 'type': 'deposit', 'pos': (10, -43)},
}

for o, obj in objects.iteritems():
	if obj['type'] == 'deposit':
		obj['accepts'] = [ slots[obj['res'] + '-food']['hash'] ]
	elif obj['type'] == 'city':
		obj['accepts'] = [slots[s]['hash'] for s in slots if slots[s]['type'] == 'res' or slots[s]['type'] == 'settler']


