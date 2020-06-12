class_name SaveGame
const script_name := "save_game"

static func save_character(data):
	var file = File.new()
	var filepath = "user://characters/" + str(data.file) + ".json"
	
	if Directory.new().file_exists("user://characters/"):
		var error = Directory.new().make_dir("user://characters/")
		if error:
			Core.emit_signal("msg", "Error making dir user://characters Code: "
				+ str(error), Core.WARN, "save_game")
	
	file.open(filepath, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()

static func load_character(character_id):
	#Core.emit_signal("msg", "Loading character " + character_id + "...", Core.DEBUG, "save_game")
	var file = File.new()
	var filepath = "user://characters/" + str(character_id)
	
	file.open(filepath, file.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	#if !data.has("player"):
	#	Core.emit_signal("msg", "Player save file does not contain player info! " + str(data), Core.WARN, "save_game")
	#	return false
	return data

static func load_all():
	var saves = []
	for fileName in list_files_in_directory():
		var save = load_character(fileName)
		Core.emit_signal("msg", "Player info from load_character: " + str(save), Core.TRACE, "save_game")
		if save:
			saves.append(save)
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
