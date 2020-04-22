extends Control

onready var CharacterSelectionButton = preload("res://Scenes/CharactorSelection/CharacterSelectionButton.tscn")

# {
#    1 : {
#       name = "Legondary Dragon"
#       info = "Breathes fire"
#       picture = "dragon.png"
#    }
# }

func setup(data: Dictionary):
	add_character("new", "New Character", "", "", { })
	
	for character in data:
		add_character(character, data[character].name, 
			data[character].info, data[character].picture, data[character])

func add_character(id, name: String, info: String, picture: String, character_data):
	var SelectButton = CharacterSelectionButton.instance()
	SelectButton.name = str(id)
	get_node("Scroll/HBox/VBox/ButtonsVBox").add_child(SelectButton)
	var ButtonInstance = get_node("Scroll/HBox/VBox/ButtonsVBox/" + str(id))
	
	# Set Picture
	if picture:
		var texture = load("res://Assets/Images/Profiles/Friendlies/" + picture)
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile/Pic").texture = texture
	else:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile/Pic").visible = false
	
	# Set Text
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Name").text = name.to_upper()
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Info").text = info.to_upper()
	
	ButtonInstance.get_node("VBox/Content/Button").connect("pressed", self, "_on_button_press", [ character_data ])

func _on_button_press(character_data: Dictionary):
	Core.emit_signal("_gui_pushed", "select_character", character_data)
