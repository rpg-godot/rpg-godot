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
	run_state(value)

func set_color(value):
	set("custom_colors/font_color", value)

func _ready():
	run_state(state)

func run_state(newState):
	match newState:
		States.FLASHING:
			if state == States.ENABLED:
				start_flashing1()
			elif state == States.DISABLED:
				start_flashing()
			elif state == States.HIDDEN:
				start_flashing2()
		States.ENABLED:
			enable()
		States.DISABLED:
			disable()
		States.HIDDEN:
			hidden()
	state = newState

func start_flashing():
	get_node("AnimationPlayer").play("Flashing")

func start_flashing1():
	get_node("AnimationPlayer").play("Flashing1")

func start_flashing2():
	get_node("AnimationPlayer").play("Flashing2")

func enable():
	get_node("AnimationPlayer").stop()
	self.color = Color(1.0, 1.0, 1.0)

func disable():
	get_node("AnimationPlayer").stop()
	self.color = Color(1.0, 1.0, 1.0, 0.4)
	
func hidden():
	get_node("AnimationPlayer").stop()
	self.color = Color(1.0, 1.0, 1.0, 0.0)
