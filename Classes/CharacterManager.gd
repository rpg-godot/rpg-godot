class_name CharacterManager
const script_name := "character_manager"

static func create(character):
	return CharacterDefaults.new().characters[character]

static func load_class(character_data, character_class):
	# Add equipment to the character inventory and equip those items
	for item in CharacterDefaults.starting_equipment[character_class]:
		InventoryManager.add(character_data, Items.items[item])
		equip(character_data, Items.items[item])
	
	# Add character attacks
	for attack_type in CharacterDefaults.starting_attacks[character_class].keys():
		for attack_name in CharacterDefaults.starting_attacks[character_class][attack_type]:
			learn_attack(character_data, attack_type, attack_name)
	
	return character_data

static func learn_attack(character_data: Dictionary, attack_type: String, attack_name: String):
	character_data.attacks[attack_type].append(attack_name)

static func calcuate_item_buffs(player):
	Core.emit_signal("msg", "This function is not implemented yet!", Core.WARN, "character_manager")
	#for item in player.items:
	#	pass

static func equip(player, item):
	if !InventoryManager.item_exists(player, item):
		return false
	
	if item.level_requirement <= player.level:
		player.items[item.type][item.subtype].append(item)
	else:
		return false

static func unequip(player, item):
	#if !player.items.inventory.item_exists(item):
	#	return false
	
	player.items[item.type][item.subtype].erase(item)

static func set_level(player):
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
