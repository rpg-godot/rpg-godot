class_name CharacterManager
const script_name := "character_manager"

static func create(character):
	return CharacterDefaults.new().characters[character]

# true if slot empty and item is owned
static func equip(player, item):
	var check = player.items.inventory.check(item, 1)
	if !check:
		return false

	if check[0]:
		if player.items.equipment.items[item.broadType][item.type].size() == 0:
			if item.levelRequirement <= player.level:
				player.items.equipment.add(item, 1)
				for buffKey in item.buffs.keys():
					if buffKey == "mana_attack" or  buffKey == "defense" or buffKey == "melee_attack":
						pass
					else:
						player.equip_buffs[buffKey] += item.buffs[buffKey]
				return [true, "Done"]
			else:
				return [false, "Level Requirement Not Met"]
		else:
			return [false, "Doesn't Exist"]

static func unequip(player, item):
	if player.items.equipment.check(item, 1)[0]:
		player.items.equipment.remove(item, 1)
		for buffKey in item.buffs.keys():
			player.equipBuffs[buffKey] -= item.buffs[buffKey]
		return [true, "Done"]
	else:
			return [false, "Doesn't Exist"]

static func set_level(player):
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
