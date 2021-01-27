extends Node
const script_name := "loading"
var splash = load("res://Scenes/Splash/Splash.tscn").instance()

func _ready():
	var error = Core.connect("msg", self, "_on_msg")
	if error:
		Core.emit_signal("msg", "Event msg failed to bind", Log.WARN, self)
		print("Warn: Event msg failed to bind")
	
	Core.emit_signal("scene_loaded", self)
	
	Core.emit_signal("msg", "RPG Godot started!", Log.TRACE, self)
	
	error = Core.connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		Core.emit_signal("msg", "Event scene_loaded failed to bind", Log.WARN, self)
	
	AudioManager.load_music_player("Background", "Music/Background/MainTheme/513824__georgeae2__boss-theme.ogg", "Back")
	
	Core.emit_signal("request_scene_load", splash)

func _on_msg(message, level, obj):
	var script = obj
	if typeof(obj) != TYPE_STRING:
		script = obj.script_name

	var level_string = "All"
	match level:
		Log.BATTLE:
			level_string = "Battle"
		Log.FATAL:
			level_string = " Fatal"
		Log.ERROR:
			level_string = " Error"
		Log.WARN:
			level_string = "  Warn"
		Log.INFO:
			level_string = "  Info"
		Log.DEBUG:
			level_string = " Debug"
		Log.TRACE:
			level_string = " Trace"
		Log.ALL:
			level_string = "   All"

	get_node('Text').add_text(level_string + " [ " + script + " ] " + message + '\n')

func _on_scene_loaded(scene):
	if scene == splash:
		queue_free()

#func example_save():
#	var character = {}
#	character.name = "Legondary Dragon"
#	character.info = "Breathes fire"
#	character.picture = "Tex_AnimeAva_01.png"
#	SaveGame.save_character(character)
