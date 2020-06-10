class_name CharacterManager
const script_name := "character_manager"

static func create(character):
	return CharacterDefaults.characters[character]

## true if slot empty and item is owned
static func equip(inventory, item):
	pass
#	var check = inventory.check(item, 1)
#	if !check:
#		return false
#
#	if check[0]:
#		if equipment.items[item.broadType][item.type].size() == 0:
#			if item.levelRequirement <= level:
#				equipment.add(item, 1)
#				for buffKey in item.buffs.keys():
#					equipBuffs[buffKey] +=item.buffs[buffKey]
#				return [true, "Done"]
#			else:
#				return [false, "Level Requirement Not Met"]
#		else:
#			return [false, "Doesn't Exist"]

#var money = 0
## false if failed or true if succeeded
static func add(item, quantity:int):
	pass
#	if quantity > 0:
#		if item.broadType != "other":
#			if self.check(item, 1)[0]:
#				items[item.broadType][item.type][self.check(item, 1)[1]][1] += quantity
#			else:
#				items[item.broadType][item.type].append([item, quantity])
#		if item.broadType == "other":
#			if self.check(item, 1)[0]:
#				items[item.broadType][self.check(item, 1)[1]][1] += quantity
#			else:
#				items[item.broadType].append([item, quantity])
#		return [true, "Done"]
#	else:
#		return [false, "Quantity Error"]

## false if failed or true if succeeded
static func remove(item, quantity:int):
	pass
#	if quantity > 0:
#		if item.broadType != "other":
#			if self.check(item, quantity)[0]:
#				items[item.broadType][item.type][self.check(item, 1)[1]][1] -= quantity
#				if items[item.broadType][item.type][self.check(item, 0)[1]][1] == 0:
#					items[item.broadType][item.type].remove(self.check(item, 0)[1])
#				return [true, "Done"]
#			else:
#				return [false, "Doesn't Exist"]
#		if item.broadType == "other":
#			if self.check(item, quantity)[0]:
#				items[item.broadType][self.check(item, 1)[1]][1] -= quantity
#				if items[item.broadType][self.check(item, 1)[1]][1] == 0:
#					items[item.broadType].remove(self.check(item, 1)[1])
#				return [true, "Done"]
#			else:
#				return [false, "Doesn't Exist"]
#	else:
#		return [false, "Quantity Error"]

## [if that many exist, index of that many items]
static func check(item, quantity:int):
	pass
#	var done = false
#	if item.broadType != "other":
#		if !items.has(item.broadType) or !items[item.broadType].has(item.type):
#			print('Invalid item type' + str(item.broadType) + ', ' + str(item.type))
#			return false
#
#		for inventory_item in items[item.broadType][item.type]:
#			if item.isTheSameAs(inventory_item[0]) && inventory_item[1] >= quantity:
#				return [true, items[item.broadType][item.type].find(inventory_item)]
#	else:
#		for inventory_item in items[item.broadType]:
#			if item.isTheSameAs(inventory_item[0]) && inventory_item[1] >= quantity:
#				return [true, items[item.broadType].find(inventory_item)]
#	if !done:
#		return [false, -1]
#func text():
#	return "items: " + str(items) + " money: " + str(money)

static func unequip(item):
	pass
#	if equipment.check(item, 1)[0]:
#		equipment.remove(item, 1)
#		for buffKey in item.buffs.keys():
#			equipBuffs[buffKey] -=item.buffs[buffKey]
#		return [true, "Done"]
#	else:
#			return [false, "Doesn't Exist"]
#func text():
#	return character_name

static func set_level():
	pass
#		var tempLevel = level
#	var count = 1
#	while tempLevel >= 5:
#		stats["Strength"] += 1
#		stats["Intelligence"] += 1
#		stats["Agility"] += 1
#		stats["Luck"] += 1
#		if count%3==0:
#			stats["Perception"] += 1
#			stats["Endurance"] += 1
#			stats["Charisma"] += 1
#		count+=1
#		tempLevel-=5
