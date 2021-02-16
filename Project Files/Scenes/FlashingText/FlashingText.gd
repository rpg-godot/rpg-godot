tool
extends Label
class_name FlashingText
const script_name := "flashing_text"
onready var instance_name := get_parent().name
onready var mode = "dumb"
onready var modeDefault = States.ENABLED
onready var disableFlash = false

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
	if get_parent() is Button or get_parent() is TextureButton:
		mode = "button"
		if get_parent().disabled:
			set_state(States.DISABLED)
		else:
			set_state(modeDefault)
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
	
func _process(delta):
	if mode == "button" and state != States.FLASHING and state != States.HIDDEN:
		if get_parent().disabled:
			set_state(States.DISABLED)
		else:
			set_state(modeDefault)

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

func _on_FlashingText_mouse_entered():
	if mode == "button":
		if !get_parent().disabled and !disableFlash:
			set_state(States.FLASHING)

func _on_FlashingText_mouse_exited():
	if mode == "button":
		if !get_parent().disabled:
			set_state(modeDefault)

func _on_FlashingText_visibility_changed():
	if mode == "button":
		if get_parent().disabled:
			set_state(States.DISABLED)
