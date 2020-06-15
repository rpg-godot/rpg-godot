class_name SaveManager
const script_name := "save_manager"

static func save():
	Core.player
	var file = File.new()
	var filepath = "user://characters/" + Core.player.name + " - " + Core.player.timeCreated + ".json"
	
	if Directory.new().file_exists("user://characters/"):
		var error = Directory.new().make_dir("user://characters/")
		if error:
			Core.emit_signal("msg", "Error making dir user://characters Code: "
				+ str(error), Log.WARN, "save_game")
	
	var SaveData = {
		player = Core.player,
		allies = [],
		enemies = []
	}
	file.open(filepath, File.WRITE)
	file.store_string(JSON.print(SaveData))
	file.close()

static func load_file(character_file):
	#Core.emit_signal("msg", "Loading character " + character_id + "...", Log.DEBUG, "save_game")
	var file = File.new()
	var filepath = "user://characters/" + str(character_file)
	
	file.open(filepath, file.READ)
	var text = file.get_as_text()
	var SaveData = parse_json(text)
	file.close()
	#if !data.has("player"):
	#	Core.emit_signal("msg", "Player save file does not contain player info! " + str(data), Log.WARN, "save_game")
	#	return false
	return SaveData

static func load_all():
	var saves = []
	for fileName in list_files_in_directory():
		var SaveData = load_file(fileName)
		Core.emit_signal("msg", "Player info from load_character: " + SaveData.player.name, Log.TRACE, "save_game")
		if SaveData:
			saves.append(SaveData)
	return saves

static func list_files_in_directory():
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
