class_name Character
const script_name := "character"

export var character_name = "Default Name"
var stats = {"Strength":3, "Perception":3, "Endurance":3, "Charisma":3, "Intelligence":3, "Agility":3, "Luck":3}
var pic = ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", [false, false]]
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
	var check = inventory.check(item, 1)
	if !check:
		return false
	
	if check[0]:
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
	return character_name

### charName, [Strength, Perception, Endurance, Charisma, Intelligence, Agility, Luck], [imageLocation, flipH, flipV], [useBorder, borderLocation], [[meleeAttacks], [rangeAttacks], [manaAttacks]], level, [skills], APmax, APrecoverySpeedPerTurn, healthMax, manaMax
#func _init(name:String, new_stats:Array, pic:String, picBorder:Array, attacks:Array, level:int, skills:Array, APmax:int, APspeed:int, healthMax:int, manaMax:int):
#	character_name = name
#	stats = {"Strength":new_stats[0], "Perception":new_stats[1], "Endurance":new_stats[2], "Charisma":new_stats[3], "Intelligence":new_stats[4], "Agility":new_stats[5], "Luck":new_stats[6]}
#	pic = [pic, flipProfile[pic]]
#	picBorder = picBorder
#	attacks["melee"] = attacks[0]
#	attacks["ranged"] = attacks[1]
#	attacks["mana"] = attacks[2]
#	level = level
#	skills = skills
#	APmax = APmax
#	APspeed = APspeed
#	AP = APmax
#	healthMax = healthMax
#	health = healthMax
#	manaMax = manaMax
#	mana = manaMax
#	return self
