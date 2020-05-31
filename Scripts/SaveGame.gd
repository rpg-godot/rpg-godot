func save_character(data):
	var file = File.new()
	var filepath = "user://characters/" + str(data["saveFile"]) + ".json"
	
	if !Directory.new().file_exists("user://characters/"):
		Directory.new().make_dir("user://characters/")
	
	file.open(filepath, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()

func load_character(character_id):
	print (character_id)
	var file = File.new()
	var filepath = "user://characters/" + str(character_id)
	
	file.open(filepath, file.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	
	return data

func load_all():
	var saves = []
	for fileName in list_files_in_directory():
		var save = load_character(fileName)
		saves.append(save)
		print (save)
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
