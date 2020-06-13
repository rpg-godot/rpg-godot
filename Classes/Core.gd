extends Node
const script_name := "core"

#onready var Client = get_node("/root/World/Systems/Client")
#onready var Server = get_node("/root/World/Systems/Server")

#warning-ignore:unused_signal
signal request_scene_load(scene)
#warning-ignore:unused_signal
signal scene_loaded(scene)
#warning-ignore:unused_signal
signal entity_used(entity, amount)
#warning-ignore:unused_signal
signal msg(message, level, obj)
#warning-ignore:unused_signal
signal damage_dealt(target, shooter, weapon_data)
#warning-ignore:unused_signal
signal damage_taken(target, shooter)
#warning-ignore:unused_signal
signal entity_picked_up(picker, entity)

#warning-ignore:unused_signal
signal gui_loaded(name, entity)
#warning-ignore:unused_signal
signal gui_pushed(name, data)

var current_scene = load("res://Scenes/Loading/Loading.tscn").instance()
var character_data = {}
var player

func _ready():
	Log.new()
	var error = Core.connect("request_scene_load", self, "_on_request_scene_load")
	if error:
		Core.emit_signal("msg", "Event request_scene_load failed to bind", Log.WARN, self)
	
	error = Core.connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		Core.emit_signal("msg", "Event scene_loaded failed to bind", Log.WARN, self)

func _on_request_scene_load(scene):
	Core.get_parent().call_deferred("add_child", scene)
	Core.emit_signal("msg", "Loading " + scene.name + " scene...", Log.INFO, self)

func _on_scene_loaded(scene):
	current_scene = scene.name
