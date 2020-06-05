extends Control

var character_selection = load("res://Scenes/CharacterSelection/CharacterSelection.tscn").instance()

func _ready():
	Core.emit_signal("scene_loaded", self)
	get_node("AnimationPlayer").play("FadeIn")

func _input(event):
	if event.is_action_pressed("ui_select") or event.is_action_pressed("ui_accept"):
		start_game()

func start_game():
	var error = Core.connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		Core.emit_signal("msg", "Event scene_loaded failed to bind", Core.WARN, self)
	
	Core.emit_signal("request_scene_load", character_selection)

func _on_scene_loaded(scene):
	if scene == character_selection:
		queue_free()
