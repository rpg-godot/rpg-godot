extends Control

onready var CharacterSelectionButton = preload("res://Scenes/CharacterSelection/CharacterSelectionButton.tscn")

	
#[
#	{
#		name = "Legondary Dragon",
#		info = "Breathes fire",
#		picture = "dragon.png"
#		saveFile = name+utctimestamp,
#		companions = {
#			companionName: = "Billy"
#			otherStats =...
#			}
#		location = {}
#		quests = []
#	}
#]

func setup(data: Array):
	
	for character in data:
		add_character(character)

func add_character(character):
	var id = character["saveFile"]
	var name = character.name
	var info = character.info
	var picture = character.picture
	var SelectButton = CharacterSelectionButton.instance()
	SelectButton.name = str(id)
	get_node("Scroll/HBox/VBox/ButtonsVBox").add_child(SelectButton)
	var ButtonInstance = get_node("Scroll/HBox/VBox/ButtonsVBox/" + str(id))
	
	# Set Picture
	if picture:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").texture = load(picture)
	else:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").visible = false
	
	# Set Text
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Name").text = name.to_upper()
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Info").text = info.to_upper()
	
	ButtonInstance.get_node("VBox/Content/Button").connect("pressed", self, "_on_button_press", [ character ])

func _on_button_press(character: Dictionary):
	Core.emit_signal("_gui_pushed", "select_character", character)


func _on_Create_pressed():
	Core.add_child(load("res://Scenes/CharacterCreation/CharacterCreation.tscn").instance())
	Core.remove_child(self)
