tool
extends Label
class_name FlashingText
const script_name := "flashing_text"
onready var instance_name := get_parent().name

enum States {
	FLASHING,
	ENABLED,
	DISABLED,
	HIDDEN
}

export(States) var state = States.FLASHING setget set_state

export var color := Color(1.0, 1.0, 1.0) setget set_color

func set_state(value):
	state = value
	run_state()

func set_color(value):
	set("custom_colors/font_color", value)

func _ready():
	run_state()

func run_state():
	match state:
		States.FLASHING:
			start_flashing()
		States.ENABLED:
			enable()
		States.DISABLED:
			disable()
		States.HIDDEN:
			hidden()

func start_flashing():
	get_node("AnimationPlayer").play("Flashing")

func enable():
	get_node("AnimationPlayer").stop()
	self.color = Color(1.0, 1.0, 1.0)

func disable():
	get_node("AnimationPlayer").stop()
	self.color = Color(1.0, 1.0, 1.0, 0.4)
	
func hidden():
	get_node("AnimationPlayer").stop()
	self.color = Color(1.0, 1.0, 1.0, 0.0)
