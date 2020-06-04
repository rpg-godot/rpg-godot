const script_name := "save_game"

func save_character(data):
	var file = File.new()
	var filepath = "user://characters/" + str(data["saveFile"]) + ".json"
	
	if !Directory.new().file_exists("user://characters/"):
		Directory.new().make_dir("user://characters/")
	
	data.player = character_class_to_data(data.player)
	file.open(filepath, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()

func character_class_to_data(Character):
	var Player = {}
	Player["name"] = Character.name
	Player["stats"] = [Character.stats["Strength"], Character.stats["Perception"], Character.stats["Endurance"], Character.stats["Charisma"], Character.stats["Intelligence"], Character.stats["Agility"], Character.stats["Luck"]]
	Player["pic"] = Character.pic[0]
	Player["picBorder"] = Character.picBorder
	Player["attacks"] = Character.attacks
	Player["level"] = Character.level
	Player["skills"] = Character.skills
	Player["APmax"] = Character.APmax
	Player["APspeed"] = Character.APspeed
	Player["AP"] = Character.AP
	Player["healthMax"] = Character.healthMax
	Player["health"] = Character.health
	Player["manaMax"] = Character.manaMax
	Player["mana"] = Character.mana
	Player["kills"] = Character.kills
	Player["equipment"] = Character.equipment
	Player["inventory"] = Character.inventory
	Player["equipBuffs"] = Character.equipBuffs
	
	
	Player.attacks = [Character.attacks["melee"], Character.attacks["ranged"], Character.attacks["mana"]]
	return Player
	
func data_to_character_class(Player):
	var Character = Core.get_node("/root/Variables").Classes.CreateCharacter(Player["name"], Player["stats"], Player["pic"], Player["picBorder"], Player["attacks"], Player["level"], Player["skills"], Player["APmax"], Player["APspeed"], Player["healthMax"], Player["manaMax"])
	Character.health = Player["health"]
	Character.mana = Player["mana"]
	Character.kills = Player["kills"]
	Character.equipment = Player["equipment"]
	Character.inventory = Player["inventory"]
	Character.equipBuffs = Player["equipBuffs"]
	return Character

func load_character(character_id):
	print (character_id)
	var file = File.new()
	var filepath = "user://characters/" + str(character_id)
	
	file.open(filepath, file.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	if !data.has("player"):
		print('Error: Player save file does not contain player info!')
		return false
	data.player = data_to_character_class(data.player)
	return data

func load_all():
	var saves = []
	for fileName in list_files_in_directory():
		var save = load_character(fileName)
		print ('Player info from load_character: ' + str(save))
		if save:
			saves.append(save)
	return saves

func list_files_in_directory():
	var saveLocation = "user://characters/"
	var files = []
	var dir = Directory.new()
	dir.open(saveLocation)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file.ends_with(".json"):
				files.append(file)

	dir.list_dir_end()

	return files
