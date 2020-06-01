extends Control

onready var CharacterSelectionButton = preload("res://Scenes/CharacterSelection/CharacterSelectionButton.tscn")
onready var SaveGame = get_node("/root/Variables").SaveGame
	
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

func _ready():
	var saves = SaveGame.load_all()
	for save in saves:
		add_character(save)

func add_character(save):
	var id = save["saveFile"]
	var name = save.name
	var info = save.info
	var picture = save.picture
	var player = save.player
	var SelectButton = CharacterSelectionButton.instance()
	SelectButton.name = str(id)
	get_node("Scroll/HBox/VBox/ButtonsVBox").add_child(SelectButton)
	var ButtonInstance = get_node("Scroll/HBox/VBox/ButtonsVBox/" + str(id))
	
	# Set Picture
	if picture:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").texture = load(picture)
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").flip_h = player.pic[1][0]
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").flip_v = player.pic[1][1]
	else:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").visible = false
	
	# Set Text
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Name").text = name.to_upper()
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Info").text = info.to_upper()
	
	ButtonInstance.get_node("VBox/Content/Button").connect("pressed", self, "_on_button_press", [ save ])

func _on_button_press(save: Array):
	Core.emit_signal("_gui_pushed", "select_character", save)


func _on_Create_pressed():
	Core.add_child(load("res://Scenes/CharacterCreation/CharacterCreation.tscn").instance())
	Core.remove_child(self)
