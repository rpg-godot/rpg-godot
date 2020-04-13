extends Control

var chosen = false

func _ready():
	pass

func _on_SelectButton_pressed():
	if !chosen:
		chosen = true
		get_node("Border").show()
		get_node("../../../../..").updateChosenProfile(get_node("."))
