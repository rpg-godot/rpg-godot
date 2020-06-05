extends Control
const script_name := "character_selection"

onready var CharacterSelectionButton = preload("res://Scenes/CharacterSelection/CharacterSelectionButton.tscn")

var selected_character = ''

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
	
	Core.emit_signal("scene_loaded", self)

func add_character(save):
	var id = save["saveFile"]
	var name = save.name
	var info = save.info
	var picture = save.picture
	var player = save.player
	var SelectButton = CharacterSelectionButton.instance()
	SelectButton.name = str(id)
	get_node("VBox/Scroll/HBox/VBox/ButtonsVBox").add_child(SelectButton)
	var ButtonInstance = get_node("VBox/Scroll/HBox/VBox/ButtonsVBox/" + str(id))
	
	# Set Picture
	if picture:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").texture = load(picture)
		#ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").flip_h = player.pic[1][0]
		#ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").flip_v = player.pic[1][1]
	else:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").visible = false
	
	# Set Text
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Name").text = name.to_upper()
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Info").text = info.to_upper()
	
	ButtonInstance.get_node("VBox/Content/Button").connect("pressed", self, "_on_button_press", [ save ])

func _on_button_press(save: Dictionary):
	Core.emit_signal("gui_pushed", "select_character", save)
	print('Button pressed!')
	selected_character = save.saveFile
	
	for child in Core.get_parent().get_node('CharacterSelection/VBox/Scroll/HBox/VBox/ButtonsVBox/').get_children():
		if child.name != selected_character:
			child.pressed = false
	
	#var button = Core.get_node('CharacterSelection/Scroll/HBox/VBox/ButtonsVBox/' + save.saveFile)


func _on_Create_pressed():
	Core.get_parent().add_child(load("res://Scenes/CharacterCreation/CharacterCreation.tscn").instance())
	queue_free()


func _on_play_pressed():
	print('Play pressed!')
