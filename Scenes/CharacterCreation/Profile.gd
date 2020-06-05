extends Control

const script_name := "profile"

var chosen = false

func _on_SelectButton_pressed():
	if !chosen:
		chosen = true
		get_node("Border").show()
		Core.get_parent().get_node("CharacterCreation").updateChosenProfile(self)
