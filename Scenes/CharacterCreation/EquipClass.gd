extends VBoxContainer

var chosen = false

func _ready():
	pass

func _on_SelectButton_pressed():
	if !chosen:
		chosen = true
		get_node("ImgCenter/Border").show()
		get_node("../../../../..").updateChosenEquip(get_node("."))
