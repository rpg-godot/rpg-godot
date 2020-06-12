class_name CharacterManager
const script_name := "character_manager"


static func create(character_name: String):
	return CharacterDefaults.new().characters[character_name]


static func load_class(character_data: Dictionary, character_class: String):
	# Add equipment to the character inventory and equip those items
	for item in CharacterDefaults.starting_equipment[character_class]:
		var item_index = add(character_data, Items.items[item])
		equip(character_data, item_index)
	
	# Add character attacks
	for attack_type in CharacterDefaults.starting_attacks[character_class].keys():
		for attack_name in CharacterDefaults.starting_attacks[character_class][attack_type]:
			learn_attack(character_data, attack_type, attack_name)
	
	return character_data


static func learn_attack(character_data: Dictionary, attack_type: String, attack_name: String):
	character_data.attacks[attack_type].append(attack_name)


static func calcuate_item_buffs(character_data):
	Core.emit_signal("msg", "This function is not implemented yet!", Core.WARN, "character_manager")
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
	Core.emit_signal("msg", "This function is not implemented yet!", Core.WARN, "character_manager")
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
