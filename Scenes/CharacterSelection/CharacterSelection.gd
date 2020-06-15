extends Control
const script_name := "character_selection"

onready var CharacterSelectionButton = preload("res://Scenes/CharacterSelection/CharacterSelectionButton.tscn")

var selectedCharacter = ''

func _ready():
	load_saves()
	Core.emit_signal("scene_loaded", self)

func load_saves():
	#Clear old save file buttons
	for saveButton in get_node('VBox/Scroll/HBox/VBox/ButtonsVBox/').get_children():
		saveButton.free()
	var saves = SaveManager.load_all()
	for saveData in saves:
			var player = saveData.player
			var id = player.get("timeCreated", "unknown")
			var name = player.get("name", "unknown")
			var info = player.get("info", "unknown")
			
			var picture = player.get("picture", "unknown")	
			if id != "unknown":
				add_character(id, name, info, picture, player)
	if saves.size() == 0:
		_on_Create_pressed()

func add_character(id: String, name: String, info: String, picture: Dictionary, player: Dictionary):
	var SelectButton = CharacterSelectionButton.instance()
	
	SelectButton.name = str(id)
	get_node("VBox/Scroll/HBox/VBox/ButtonsVBox").add_child(SelectButton)
	var ButtonInstance = get_node("VBox/Scroll/HBox/VBox/ButtonsVBox/" + str(id))
	
	# Set Picture
	if picture:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile/Picture").texture = load(picture.path)
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile/Picture").flip_h = player.picture.flip_profile[0]
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile/Picture").flip_v = player.picture.flip_profile[1]
	else:
		ButtonInstance.get_node("VBox/Content/HBox/CenterProfile/HBox/Profile").visible = false
	
	# Set Text
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Name").text = name.to_upper()
	ButtonInstance.get_node("VBox/Content/HBox/CenterText/VBox/Info").text = info.to_upper()
	
	ButtonInstance.get_node("VBox/Content/Button").connect("pressed", self, "_on_button_press", [ player ])

func _on_button_press(save: Dictionary):
	if selectedCharacter == save.timeCreated:
		deactivate_selection_buttons()
		selectedCharacter = ''
		Core.player = {}
		for child in get_node('VBox/Scroll/HBox/VBox/ButtonsVBox/').get_children():
			child.pressed = false
	else:
		activate_selection_buttons()
		selectedCharacter = save.timeCreated
		Core.player = save
		for child in get_node('VBox/Scroll/HBox/VBox/ButtonsVBox/').get_children():
			if child.name != selectedCharacter:
				child.pressed = false

func activate_selection_buttons():
	get_node("VBox/UI/Play/FlashingText").state = FlashingText.States.FLASHING
	get_node("VBox/UI/Delete/FlashingText").state = FlashingText.States.FLASHING
	get_node("VBox/UI/Play").disabled = false
	get_node("VBox/UI/Delete").disabled = false
func deactivate_selection_buttons():
	get_node("VBox/UI/Play/FlashingText").state = FlashingText.States.DISABLED
	get_node("VBox/UI/Delete/FlashingText").state = FlashingText.States.DISABLED
	get_node("VBox/UI/Play").disabled = true
	get_node("VBox/UI/Delete").disabled = true

func _on_Create_pressed():
	Core.get_parent().add_child(load("res://Scenes/CharacterCreation/CharacterCreation.tscn").instance())
	queue_free()


func _on_play_pressed():
	if Core.player != {}:
		Core.get_parent().add_child(load("res://Scenes/Battle/Battle.tscn").instance())
	
		var player2 = CharacterManager.create("alrune")
	
		var enemy1 = CharacterManager.create("death_hound")
		CharacterManager.load_class(enemy1, "death_hound")
		CharacterManager.set_level(enemy1, int(rand_range(1, 10)))
		
		var enemy2 = CharacterManager.create("death_hound")
		CharacterManager.load_class(enemy2, "death_hound")
		CharacterManager.set_level(enemy2, int(rand_range(1, 10)))
		
		var enemy3 = CharacterManager.create("death_hound")
		CharacterManager.load_class(enemy3, "death_hound")
		CharacterManager.set_level(enemy3, int(rand_range(1, 10)))
	
		Core.get_parent().get_node("Battle").load_battle("Wolf Den", "res://Assets/Images/Backgrounds/Forest.jpg", [Core.player, player2], [enemy1, enemy2])
		queue_free()

func _on_Delete_pressed():
	if Core.player != {}:
		var filepath = "user://characters/" + Core.player.name + " - " + Core.player.timeCreated + ".json"
		var dir = Directory.new()
		dir.remove(filepath)
		deactivate_selection_buttons()
		selectedCharacter = ''
		Core.player = {}
		load_saves()
