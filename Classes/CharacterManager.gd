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

static func calcuate_item_buffs(character_data):
	Core.emit_signal("msg", "This function is not implemented yet!", Log.WARN, "character_manager")
	#for item in player.items:
	#	pass


static func add(character_data: Dictionary, item_data: Dictionary, quantity:=1):
	return InventoryManager.add(character_data.inventory, item_data, quantity)

static func remove(character_data: Dictionary, item_data: Dictionary, quantity:=1):
	return InventoryManager.remove(character_data.inventory, item_data, quantity)

static func equip(character_data: Dictionary, item:Dictionary):
	if InventoryManager.check(character_data.inventory, item, 1)[0]:
		if character_data.equipment[item.broadType][item.type] == -1:
			if item.level_requirement <= character_data.level:
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
	Core.emit_signal("msg", "Setting character level to " + str(character_data.level), Log.INFO, "character_manager")
	character_data.level = level
	process_level_buffs(character_data)

static func process_level_buffs(character_data: Dictionary):
	Core.emit_signal("msg", "Processing character: " + character_data.name + " level buffs", Log.INFO, "character_manager")
	var temp_level = character_data.level
	var count = 1
	var level_buffs = Characters.zero_stats
	match character_data.classType:
		"Death Hound":
			while temp_level >= 5:
				level_buffs.strength += 1
				level_buffs.intelligence += 1
				level_buffs.agility +=1
				level_buffs.luck += 1
				
				if count%3==0:
					level_buffs.perception += 1
					level_buffs.endurance += 1
					level_buffs.charisma += 1
				count+=1
				temp_level-=5
	character_data.level_buffs = level_buffs
