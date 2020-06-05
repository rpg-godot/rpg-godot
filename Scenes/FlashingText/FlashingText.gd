extends Label

func start():
	get_node("AnimationPlayer").play("Flashing")

func stop():
	get_node("AnimationPlayer").stop()
