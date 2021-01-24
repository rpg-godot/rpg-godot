class_name Log
const script_name := "log"

var log_loc = "user://logs/"
var log_level = DEBUG

const BATTLE = -1
const FATAL = 0
const ERROR = 1
const WARN = 2
const INFO = 3
const DEBUG = 4
const TRACE = 5
const ALL = 6

func init():
	var file = File.new()
	var dir = Directory.new()
	dir.make_dir(log_loc)
	file.open(log_loc + "latest.txt", File.WRITE)
	file.close()
	var error = Core.connect("msg", self, "_on_msg")
	if error:
		Core.emit_signal("msg", "Event msg failed to bind", WARN, self)
		print("Warn: Event msg failed to bind")
	Core.emit_signal("msg", "Logs stored at " + log_loc, INFO, self)

func _on_msg(message, level, obj):
	var script = obj
	if typeof(obj) != TYPE_STRING:
		script = obj.script_name
	
	var level_string = "All"
	match level:
		BATTLE:
			level_string = "Battle"
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
	
	if level <= log_level:
		print(level_string + " [ " + script + " ] " + message)
	
	var file = File.new()
	file.open(log_loc + "latest.txt", File.READ_WRITE)
	file.seek_end()
	file.store_string(level_string + ": " + message + '\n')
	file.close()
	
	if level == FATAL:
		breakpoint
