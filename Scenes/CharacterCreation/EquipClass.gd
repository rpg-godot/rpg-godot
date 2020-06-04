extends VBoxContainer
const script_name := "equip_class"

var chosen = false

func _ready():
	pass

func _on_SelectButton_pressed():
	if !chosen:
		chosen = true
		get_node("ImgCenter/Border").show()
		Core.get_node("CreationMenu").updateChosenEquip(get_node("."))
