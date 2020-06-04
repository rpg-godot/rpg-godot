extends Node
const script_name := "core"

#onready var Client = get_node("/root/World/Systems/Client")
#onready var Server = get_node("/root/World/Systems/Server")

signal request_scene_load(scene)
signal scene_loaded(scene)
signal entity_used(entity, amount)
signal msg(message, level, obj)
signal damage_dealt(target, shooter, weapon_data)
signal damage_taken(target, shooter)
signal entity_picked_up(picker, entity)

signal gui_loaded(name, entity)
signal gui_pushed(name, data)

var character_data = {}
var log_loc = "user://logs/"

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

func _on_msg(message, level, obj):
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
		print(level_string + " [ " + obj.script_name + " ] " + message)
	
	var file = File.new()
	file.open(log_loc + "latest.txt", File.READ_WRITE)
	file.seek_end()
	file.store_string(level_string + ": " + message + '\n')
	file.close()
	
	if level == FATAL:
		breakpoint
