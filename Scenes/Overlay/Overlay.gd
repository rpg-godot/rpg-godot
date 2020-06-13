extends Node2D
const script_name := "overlay"

var lightning_disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("move_background")
	
	Core.connect("scene_loaded", self, "_on_scene_loaded")

func start_storm():
	AudioManager.load_music_player("BuildUp", "Effects/Lightning/Buildup/394921__parasonya__022-single-strike.ogg", "Effect")
	lightning()

func lightning():
	if lightning_disabled:
		return
	
	var audio = Core.get_parent().get_node("BackgroundMusicPlayer")
	var bus_layouts = ["Back", "BackCompress"]
	
	var light = get_node("Lightning")
	var energy = rand_range(0, 4)
	
	if energy >=2:
		if rand_range(0, 7) > 1:
			AudioManager.load_music_player("PowerMove", "Effects/Lightning/PowerMove/186907__rowy101__lightning-direct-hit-rowy101.ogg", "EffectLightning", false)
			yield(get_tree().create_timer(rand_range(2, 5)), "timeout")
	
	light.enabled = true
	light.energy = energy
#	if energy >=2 and Core.get_parent().has_node("BackgroundMusicPlayer"):
#		if audio.bus == "Back":
#			audio.bus = "BackCompress"
#		else:
#			audio.bus = "Back"
#		print(audio.bus)
	yield(get_tree().create_timer(rand_range(0, 0.2)), "timeout")
	light.enabled = false
	
	
	#get_node("Lightning/AnimationPlayer").play("lightning")
	#yield(get_tree().create_timer(3), "timeout")
	#get_node("Lightning/AnimationPlayer").play("lightning2")
	
	var timer = get_tree().create_timer(rand_range(1, 4))
	timer.connect("timeout", self, "lightning")

func _on_scene_loaded(scene):
	if scene.script_name == "character_selection":
		var audio = Core.get_parent().get_node("BackgroundMusicPlayer/BackgroundMusicPlayer")
		audio.bus = "BackAway"
		lightning_disabled = true
		Core.disconnect("scene_loaded", self, "_on_scene_loaded")
		Core.get_parent().get_node("BuildUpMusicPlayer").queue_free()
		Core.get_parent().get_node("PowerMoveMusicPlayer").queue_free()
