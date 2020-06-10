extends Node
const script_name := "loading"
var splash = load("res://Scenes/Splash/Splash.tscn").instance()

func _ready():
	Core.emit_signal("msg", "RPG Godot started!", Core.INFO, self)
	
	var error = Core.connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		Core.emit_signal("msg", "Event scene_loaded failed to bind", Core.WARN, self)
	
	load_music_player()
	Core.emit_signal("request_scene_load", splash)

func _on_scene_loaded(scene):
	if scene == splash:
		queue_free()

func load_music_player():
	Core.emit_signal("msg", "Starting music...", Core.INFO, self)
	var player = AudioStreamPlayer.new()
	Core.get_parent().call_deferred("add_child", player)
	var music = load("res://Assets/Sounds/Music/Background/MainTheme/513824__georgeae2__boss-theme.ogg")
	player.stream = music
	player.play()

#func example_save():
#	var character = {}
#	character.name = "Legondary Dragon"
#	character.info = "Breathes fire"
#	character.picture = "Tex_AnimeAva_01.png"
#	SaveGame.save_character(character)
