extends Control

var chosen = false

func _on_SelectButton_pressed():
	if !chosen:
		chosen = true
		get_node("Border").show()
		if Core.get_parent().has_node("Variables/CharacterCreation"):
			Core.get_node("Variables/CharacterCreation/").updateChosenProfile(self)
