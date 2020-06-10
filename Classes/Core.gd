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

var character_data = {}
var player
var log_loc = "user://logs/"
var current_scene = load("res://Scenes/Loading/Loading.tscn").instance()

const FATAL = 0
const ERROR = 1
const WARN = 2
const INFO = 3
const DEBUG = 4
const TRACE = 5
const ALL = 6

func _ready():
	var file = File.new()
	var dir = Directory.new()
	dir.make_dir(log_loc)
	file.open(log_loc + "latest.txt", File.WRITE)
	file.close()
	Core.emit_signal("msg", "Logs stored at " + log_loc, INFO, self)
	var error = Core.connect("msg", self, "_on_msg")
	if error:
		Core.emit_signal("msg", "Event msg failed to bind", WARN, self)
		print("Warn: Event msg failed to bind")
	
	error = Core.connect("request_scene_load", self, "_on_request_scene_load")
	if error:
		Core.emit_signal("msg", "Event request_scene_load failed to bind", WARN, self)
	
	error = Core.connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		Core.emit_signal("msg", "Event scene_loaded failed to bind", WARN, self)

func _on_msg(message, level, obj):
	var script = obj
	if typeof(obj) != TYPE_STRING:
		script = obj.script_name
	
	var level_string = "All"
	match level:
		FATAL:
			level_string = "Fatal"
		ERROR:
			level_string = "Error"
		WARN:
			level_string = " Warn"
		INFO:
			level_string = " Info"
		DEBUG:
			level_string = "Debug"
		TRACE:
			level_string = "Trace"
		ALL:
			level_string = "  All"
	
	if level < 4:
		print(level_string + " [ " + script + " ] " + message)
	
	var file = File.new()
	file.open(log_loc + "latest.txt", File.READ_WRITE)
	file.seek_end()
	file.store_string(level_string + ": " + message + '\n')
	file.close()
	
	if level == FATAL:
		breakpoint

func _on_request_scene_load(scene):
	Core.get_parent().call_deferred("add_child", scene)
	Core.emit_signal("msg", "Loading " + scene.name + " scene...", Core.INFO, self)

func _on_scene_loaded(scene):
	current_scene = scene.name
