## items.broadType.type[Item, quantity]
class_name Inventory
const script_name := "inventory"

var items = { 
	"armor" : { 
		"head":[],"torso":[], "arms":[], "legs":[], "feet":[], "shield":[]
	}, 
	"weapons":{
		"melee":[], "ranged":[], "consumables":[], "magic":[]
	}, 
	"other":[]
}
var money = 0
## false if failed or true if succeeded
func add(item:Item, quantity:int):
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
		if !items.has(item.broadType) or !items[item.broadType].has(item.type):
			print('Invalid item type' + str(item.broadType) + ', ' + str(item.type))
			return false
		
		for inventory_item in items[item.broadType][item.type]:
			if item.isTheSameAs(inventory_item[0]) && inventory_item[1] >= quantity:
				return [true, items[item.broadType][item.type].find(inventory_item)]
	else:
		for inventory_item in items[item.broadType]:
			if item.isTheSameAs(inventory_item[0]) && inventory_item[1] >= quantity:
				return [true, items[item.broadType].find(inventory_item)]
	if !done:
		return [false, -1]
func text():
	return "items: " + str(items) + " money: " + str(money)

## Armor/weapon, class, subType, name, (typestat bonus, eg weapon: damage, armor: def)[0,0,0,0,0,0,0], levelNeeded
func CreateItem(broadType:String, type:String, subType:String, name:String, buffs:Array, levelRequirement:int):
	var newItem = Item.new()
	newItem.broadType = broadType
	newItem.type = type
	newItem.subType = subType
	newItem.name = name
	newItem.buffs = {"Strength":buffs[0], "Perception":buffs[1], "Endurance":buffs[2], "Charisma":buffs[3], "Intelligence":buffs[4], "Agility":buffs[5], "Luck":buffs[6], "MeleeAttack":buffs[7], "ManaAttack":buffs[8],  "Defense":buffs[9]}
	newItem.levelRequirement = levelRequirement
	return newItem
