extends VBoxContainer


func _on_ButtonUp_pressed():
	##Puts the text up, total down and checks if completed
	if int(get_node("../../../Remaining/Total").text) > 0:
		get_node("Numbers/Number").text = str(int(get_node("Numbers/Number").text)+1)
		get_node("../../../Remaining/Total").text = str(int(get_node("../../../Remaining/Total").text)-1)
		get_node("../../../../../../..").checkIfCompleted()


func _on_NumberDown_pressed():
	##Puts the text down, total up and checks if completed
	if int(get_node("Numbers/Number").text) > 0:
		get_node("Numbers/Number").text = str(int(get_node("Numbers/Number").text)-1)
		get_node("../../../Remaining/Total").text = str(int(get_node("../../../Remaining/Total").text)+1)
		get_node("../../../../../../..").checkIfCompleted()
