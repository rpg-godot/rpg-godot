func save_character(character_id, data):
	var file = File.new()
	var filepath = "user://characters/" + str(character_id) + ".json"
	
	if !Directory.new().file_exists("user://characters/"):
		Directory.new().make_dir("user://characters/")
	
	file.open(filepath, File.WRITE)
	file.store_string(JSON.print(data))
	file.close()

func load_character(character_id):
	var file = File.new()
	var filepath = "user://characters/" + str(character_id) + ".json"
	
	file.open(filepath, file.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	
	return data
