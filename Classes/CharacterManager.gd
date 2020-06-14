class_name CharacterManager
const script_name := "character_manager"

static func create(character_name: String):
	return Characters.characters[character_name]


static func load_class(character_data: Dictionary, character_class: String):
	# Add equipment to the character inventory and equip those items
	for item in Characters.starting_equipment[character_class]:
		var item_index = add(character_data, Items.items[item.name], item.quantity)
		equip(character_data, item_index)
	
	# Add character attacks
	for attack_type in Characters.starting_attacks[character_class].keys():
		for attack_name in Characters.starting_attacks[character_class][attack_type]:
			learn_attack(character_data, attack_type, attack_name)
	
	character_data.character_class = character_class
	return character_data


static func learn_attack(character_data: Dictionary, attack_type: String, attack_name: String):
	character_data.attacks[attack_type].append(attack_name)


static func calcuate_item_buffs(character_data):
	Core.emit_signal("msg", "This function is not implemented yet!", Log.WARN, "character_manager")
	#for item in player.items:
	#	pass


static func add(character_data: Dictionary, item_data: Dictionary, quantity:=1):
	return InventoryManager.add(character_data.items.inventory, item_data, quantity)


static func remove(character_data: Dictionary, item_data: Dictionary, quantity:=1):
	InventoryManager.remove(character_data.items.inventory, item_data, quantity)


static func equip(character_data: Dictionary, item_index: int):
	if !character_data.items.inventory[item_index]:
		return false
	var item = character_data.items.inventory[item_index]

	if item.level_requirement <= character_data.level:
		character_data.items[item.type][item.subtype].append(item_index)
	else:
		return false


static func unequip(character_data: Dictionary, item_index: int):
	if !character_data.items.inventory[item_index]:
		return false
	var item = character_data.items.inventory[item_index]
	
	character_data.items[item.type][item.subtype].erase(item_index)

static func set_level(character_data: Dictionary, level: int):
	Core.emit_signal("msg", "Setting character level to " + str(character_data.level), Log.INFO, "character_manager")
	character_data.level = level
	
	character_data.level_buffs = process_level_buffs(level, character_data.character_class)

static func process_level_buffs(level: int, character_class: String):
	Core.emit_signal("msg", "Processing character level " + str(level) + " stats", Log.INFO, "character_manager")
	var temp_level = level
	var count = 1
	var level_buffs = Characters.zero_stats
	match character_class:
		"death_hound":
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
	return level_buffs
