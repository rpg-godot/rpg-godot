extends Control

const script_name := "profile"
const profilePath: = ""
var chosen = false

func _on_SelectButton_pressed():
	if !chosen:
		chosen = true
		get_node("Border").show()
		get_node("Pic").rect_position=Vector2(10,10)
		get_node("Pic").rect_min_size=Vector2(180,180)
		get_node("Pic").rect_size=Vector2(180,180)
		Core.get_parent().get_node("CharacterCreation").updateChosenProfile(self)
