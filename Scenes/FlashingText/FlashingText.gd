tool
extends Label
class_name FlashingText

enum States {
	FLASHING,
	ENABLED,
	DISABLED
}

export(States) var state = States.FLASHING setget set_state

var color := Color(1.0, 1.0, 1.0) setget set_color

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

func start_flashing():
	get_node("AnimationPlayer").play("Flashing")

func enable():
	get_node("AnimationPlayer").stop()
	color = Color(1.0, 1.0, 1.0)

func disable():
	get_node("AnimationPlayer").stop()
	color = Color(1.0, 1.0, 1.0, 0)
