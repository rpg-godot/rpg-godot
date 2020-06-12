class_name Inventory

var items = {"armor":{"head":[],"torso":[], "arms":[], "legs":[], "feet":[], "shield":[]}, "weapons":{"melee":[], "ranged":[], "consumables":[], "magic":[]}, "other":[]}
var money = 0

## false if failed or true if succeeded
func add(item:Item, quantity:int):
	if quantity > 0:
		if item.broadType != "other":
			if self.check(item, 1)[0]:
				items[item.broadType][item.type][self.check(item, 1)[1]][1] += quantity
			else:
				items[item.broadType][item.type].append([item, quantity])
		if item.broadType == "other":
			if self.check(item, 1)[0]:
				items[item.broadType][self.check(item, 1)[1]][1] += quantity
			else:
				items[item.broadType].append([item, quantity])
		return [true, "Done"]
	else:
		return [false, "Quantity Error"]

## false if failed or true if succeeded
func remove(item:Item, quantity:int):
	if quantity > 0:
		if item.broadType != "other":
			if self.check(item, quantity)[0]:
				items[item.broadType][item.type][self.check(item, 1)[1]][1] -= quantity
				if items[item.broadType][item.type][self.check(item, 0)[1]][1] == 0:
					items[item.broadType][item.type].remove(self.check(item, 0)[1])
				return [true, "Done"]
			else:
				return [false, "Doesn't Exist"]
		if item.broadType == "other":
			if self.check(item, quantity)[0]:
				items[item.broadType][self.check(item, 1)[1]][1] -= quantity
				if items[item.broadType][self.check(item, 1)[1]][1] == 0:
					items[item.broadType].remove(self.check(item, 1)[1])
				return [true, "Done"]
			else:
				return [false, "Doesn't Exist"]
	else:
		return [false, "Quantity Error"]

## [if that many exist, index of that many items]
func check(item:Item, quantity:int):
	var done = false
	if item.broadType != "other":
		for item2 in items[item.broadType][item.type]:
			if item.isTheSameAs(item2[0]) && item2[1] >= quantity:
				return [true, items[item.broadType][item.type].find(item2)]
	elif item.broadType == "other":
		for item2 in items[item.broadType]:
			if item.isTheSameAs(item2[0]) && item2[1] >= quantity:
				return [true, items[item.broadType].find(item2)]
	if !done:
		return [false, -1]
func text():
	return "items: " + str(items) + " money: " + str(money)
