class Character:
	var name = "Default Name"
	var stats = {"Strength":3, "Perception":3, "Endurance":3, "Charisma":3, "Intelligence":3, "Agility":3, "Luck":3}
	var pic = ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", true, false]
	var picBorder = [true, "res://Assets/Images/Profiles/ImageBorder.png"]
	var attacks = {"melee":[], "ranged":[], "mana":[]}
	var level = 1
	var skills = []
	var APmax = 1
	var APspeed = 0.5
	var AP = APmax
	var healthMax = 100
	var health = healthMax
	var manaMax = 50
	var mana = manaMax
	var kills = 0
	var equipment = Inventory.new()
	var inventory = Inventory.new()
	var equipBuffs = {"Strength":0, "Perception":0, "Endurance":0, "Charisma":0, "Intelligence":0, "Agility":0, "Luck":0, "MeleeAttack":0, "ManaAttack":0,  "Defense":0}
	## true if slot empty and item is owned
	func equip(item:Item):
		if inventory.check(item, 1)[0]:
			if equipment.items[item.broadType][item.type].size() == 0:
				if item.levelRequirement <= level:
					equipment.add(item, 1)
					for buffKey in item.buffs.keys():
						equipBuffs[buffKey] +=item.buffs[buffKey]
					return [true, "Done"]
				else:
					return [false, "Level Requirement Not Met"]
			else:
				return [false, "Doesn't Exist"]
	func unequip(item:Item):
		if equipment.check(item, 1)[0]:
			equipment.remove(item, 1)
			for buffKey in item.buffs.keys():
				equipBuffs[buffKey] -=item.buffs[buffKey]
			return [true, "Done"]
		else:
				return [false, "Doesn't Exist"]
	func text():
		return name

## charName, [Strength, Perception, Endurance, Charisma, Intelligence, Agility, Luck], [imageLocation, flipH, flipV], [useBorder, borderLocation], [[meleeAttacks], [rangeAttacks], [manaAttacks]], level, [skills], APmax, APrecoverySpeedPerTurn, healthMax, manaMax
static func CreateCharacter(name:String, stats:Array, pic:Array, picBorder:Array, attacks:Array, level:int, skills:Array, APmax:int, APspeed:int, healthMax:int, manaMax:int):
	var newCharacter = Character.new()
	newCharacter.name = name
	newCharacter.stats = {"Strength":stats[0], "Perception":stats[1], "Endurance":stats[2], "Charisma":stats[3], "Intelligence":stats[4], "Agility":stats[5], "Luck":stats[6]}
	newCharacter.pic = pic
	newCharacter.picBorder = picBorder
	newCharacter.attacks["melee"] = attacks[0]
	newCharacter.attacks["ranged"] = attacks[1]
	newCharacter.attacks["mana"] = attacks[2]
	newCharacter.level = level
	newCharacter.skills = skills
	newCharacter.APmax = APmax
	newCharacter.APspeed = APspeed
	newCharacter.AP = APmax
	newCharacter.healthMax = healthMax
	newCharacter.health = healthMax
	newCharacter.manaMax = manaMax
	newCharacter.mana = manaMax
	return newCharacter

## [[meleeAttacks], [rangeAttacks], [manaAttacks]], level, [skills], APmax, APrecoverySpeedPerTurn, healthMax
static func DeathHound(attacks:Array, level:int, skills:Array, APmax:int, APspeed:int, healthMax:int):
	var newCharacter = Character.new()
	newCharacter.name = "Death Hound"
	newCharacter.stats = {"Strength":3, "Perception":3, "Endurance":3, "Charisma":3, "Intelligence":3, "Agility":3, "Luck":3}
	newCharacter.pic = ["res://Assets/Images/Profiles/Enemies/MonstersAvatarIcons_61.PNG", false, false]
	newCharacter.picBorder = [false]
	newCharacter.attacks = [[2, 3], [], []]
	newCharacter.level = level
	newCharacter.skills = skills
	newCharacter.APmax = APmax
	newCharacter.APspeed = APspeed
	newCharacter.AP = APmax
	newCharacter.healthMax = healthMax
	newCharacter.health = healthMax
	newCharacter.manaMax = 0
	newCharacter.mana = 0
	for attacktype in attacks:
		for attack in attacktype:
			if newCharacter.attacks[attacks.find(attacktype)].find(attack) == -1:
				newCharacter.attacks[attacks.find(attacktype)].append(attack)
	## Set stat values based off level
	var tempLevel = newCharacter.level
	var count = 1
	while tempLevel >= 5:
		newCharacter.stats["Strength"] += 1
		newCharacter.stats["Intelligence"] += 1
		newCharacter.stats["Agility"] += 1
		newCharacter.stats["Luck"] += 1
		if count%3==0:
			newCharacter.stats["Perception"] += 1
			newCharacter.stats["Endurance"] += 1
			newCharacter.stats["Charisma"] += 1
		count+=1
		tempLevel-=5
	return newCharacter

##  Name, HP Damage, Mana Damage, AP Cost, Target-Type (true = enemy, false = friendly), image type, weapon type needed, weapon level needed
var meleeAttackList = {
		1:{"name":"Punch", "hpDamage":5, "manaDamage":0, "APcost":0.5, "target":true, "image":"Fists", "weaponNeeded":["none"], "itemLevelRequirements":1},
		2:{"name":"Scratch", "hpDamage":10, "manaDamage":0, "APcost":1, "target":true, "image":"Claws", "weaponNeeded":["none"], "itemLevelRequirements":1},
		3:{"name":"Bite", "hpDamage":15, "manaDamage":0, "APcost":1.5, "target":true, "image":"Teeth", "weaponNeeded":["none"], "itemLevelRequirements":1},
		4:{"name":"Strike", "hpDamage":25, "manaDamage":0, "APcost":1, "target":true, "image":"Sword", "weaponNeeded":["one-handed sword", "two-handed swords", "two-handed axe"], "itemLevelRequirements":1}
}
##  Name, HP Damage, Mana Damage, AP Cost, Target-Type (true = enemy, false = friendly), image type, ammo used, [weapon type needed, arrow type needed], weapon level needed, arrow level needed
var rangedAttackList = {
		1:{"name":"Quick Shot", "hpDamage":20, "manaDamage":0, "APcost":1, "target":true, "image":"Bow", "ammoCost":1, "weaponNeeded":[["bow", "hunting bow"], ["arrow"]], "itemLevelRequirements":1, "arrowLevelRequirements":1}
		2:{"name":"Percision Shot", "hpDamage":40, "manaDamage":0, "APcost":2, "target":true, "image":"Bow", "ammoCost":1, "weaponNeeded":[["bow", "hunting bow"], ["arrow"]], "itemLevelRequirements":2, "arrowLevelRequirements":1}
}
##  Name, HP Damage, Mana Damage, AP Cost, Mana Cost, Target-Type (true = enemy, false = friendly), SFX type, weapon type needed, weapon level needed
var manaAttackList = {
		1:{"name":"Flame", "hpDamage":25, "manaDamage":5, "APcost":1, "manaCost":20, "target":true, "image":"Fire-Small", "weaponNeeded":["staff"], "itemLevelRequirements":1}
}
##Weapon type, Image location
var attackImages = {
	"Fists":"res://Assets/Images/Icons/Attacks/Fists Attack.png",
	"Claws":"res://Assets/Images/Icons/Attacks/Claws Attack.PNG",
	"Sword":"res://Assets/Images/Icons/Attacks/Sword Attack.PNG",
	"Bow":"res://Assets/Images/Icons/Attacks/Bow Attack.png",
	"Teeth":"res://Assets/Images/Icons/Attacks/Teeth Attack.png",
	"Fire-Small":"res://Assets/Images/Icons/Attacks/Fire-Small Attack.png"
}

## items.broadType.type[Item, quantity]
class Inventory:
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
class Item:
	var broadType = ""
	var type = ""
	var name = ""
	var typeStat = 0
	var buffs = {"Strength":0, "Perception":0, "Endurance":0, "Charisma":0, "Intelligence":0, "Agility":0, "Luck":0}
	var levelRequirement = 1
	var subType = "None"
	## Compare with another item
	func isTheSameAs(item2:Item):
		return (self.type == item2.type && self.name == item2.name && self.buffs == item2.buffs && self.levelRequirement == item2.levelRequirement)
	func text():
		return "broadType: " + broadType + " type: " + type + " name: " + name + " buffs: " + str(buffs) + " levelRequirement: " + str(levelRequirement)
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
