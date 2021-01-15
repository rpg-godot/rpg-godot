class_name CharacterManager
const script_name := "character_manager"

static func create(character_name: String):
	return DictionaryFunc.clone_dict(Characters.characters[character_name])

static func load_class(character_data: Dictionary, character_class: String):
	# Add equipment to the character inventory and equip those items
	for item in Characters.starting_equipment[character_class]:
		add(character_data, Items.items[item.name], item.quantity)
		equip(character_data, Items.items[item.name])
	
	# Add character attacks
	for attack_type in Characters.starting_attacks[character_class].keys():
		for attack_name in Characters.starting_attacks[character_class][attack_type]:
			learn_attack(character_data, attack_type, attack_name)
	return character_data

static func learn_attack(character_data: Dictionary, attack_type: String, attack_name: String):
	if !character_data.attacks[attack_type].has(attack_name):
		character_data.attacks[attack_type].append(attack_name)
		if Attacks[attack_type][attack_name].APcost < character_data.attacks.lowestCost:
			character_data.attacks.lowestCost = Attacks[attack_type][attack_name].APcost

static func calcuate_stats(character_data):
	var racialStats = character_data.racialModifier
	for race in character_data.subRaces:
		DictionaryFunc.add_dict(racialStats, race[1])
	var stats1 = DictionaryFunc.add_dict(character_data.stats, character_data.levelBuffs)
	var stats2 = DictionaryFunc.multiply_dict(stats1, racialStats)
	return DictionaryFunc.add_dict(stats2, character_data.equipBuffs)

static func add(character_data: Dictionary, item_data: Dictionary, quantity:=1):
	return InventoryManager.add(character_data.inventory, item_data, quantity)

static func remove(character_data: Dictionary, item_data: Dictionary, quantity:=1):
	return InventoryManager.remove(character_data.inventory, item_data, quantity)

static func equip(character_data: Dictionary, item:Dictionary):
	if InventoryManager.check(character_data.inventory, item, 1)[0]:
		if character_data.equipment[item.broadType][item.type] == -1:
			if item.broadType == "weapons":
				if "two-hand" in item.subType:
					if item.type == "melee" && character_data.equipment[item.broadType].magic != -1:
						return [false, "Dual handed weapon, magic cannot be equipped too"]
					elif item.type == "mana" && character_data.equipment[item.broadType].melee != -1:
						return [false, "Dual handed weapon, melee cannot be equipped too"]
			if item.levelRequirement <= character_data.level:
				character_data.equipment[item.broadType][item.type] = InventoryManager.check(character_data.inventory, item, 1)[1]
				for buffKey in item.buffs.keys():
					character_data.equipBuffs[buffKey] += item.buffs[buffKey]
				return [true, "Done"]
			else:
				return [false, "Level Requirement Not Met"]
		else:
			return [false, "All ready equipped"]
	else:
		return [false, "Doesn't Exist"]

static func unequip(character_data: Dictionary, item:Dictionary):
	if InventoryManager.check(character_data.inventory, item, 1)[0]:
		if character_data.equipment[item.broadType][item.type] == InventoryManager.check(character_data.inventory, item, 1)[1]:
			character_data.equipment[item.broadType][item.type] = -1
			for buffKey in item.buffs.keys():
				character_data.equipBuffs[buffKey] -= item.buffs[buffKey]
			return [true, "Done"]
		else:
			return [false, "Doesn't Exist"]

static func set_level(character_data: Dictionary, level: int):
	character_data.level = level
	process_level_buffs(character_data)

static func process_level_buffs(character_data: Dictionary):
	var temp_level = character_data.level
	var count = 1
	var levelBuffs = Characters.zero_stats
	match character_data.classType:
		"Death Hound":
			while temp_level >= 5:
				levelBuffs.strength += 1
				levelBuffs.intelligence += 1
				levelBuffs.agility +=1
				levelBuffs.luck += 1
				
				if count%3==0:
					levelBuffs.perception += 1
					levelBuffs.endurance += 1
					levelBuffs.charisma += 1
				count+=1
				temp_level-=5
	character_data.levelBuffs = levelBuffs
