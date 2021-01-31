extends GridContainer
const script_name := "character_panel"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var index

# Called when the node enters the scene tree for the first time.
func _ready():
	disable("Minus")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AttackMinus_pressed():
	if get_node("VBox/Picture/AttackCount").text == "1":
		get_node("VBox/Picture/AttackCount").text = ""
		disable("Minus")
	else:
		get_node("VBox/Picture/AttackCount").text = str(int(get_node("VBox/Picture/AttackCount").text)-1)
	updateAttackList(1)


func _on_AttackPlus_pressed():
	if get_node("VBox/Picture/AttackCount").text == "":
		get_node("VBox/Picture/AttackCount").text = "1"
		enable("Minus")
	else:
		get_node("VBox/Picture/AttackCount").text = str(int(get_node("VBox/Picture/AttackCount").text)+1)
	updateAttackList(-1)
	

func disable(target:String):
	get_node("VBox/Picture/AttackControls/Attack" + target).disabled = true
	get_node("VBox/Picture/AttackControls/Attack" + target).hide()
	#get_node("VBox/Picture/AttackControls/AttackMinus").set_text_align(1)
	#get_node("VBox/Picture/AttackControls/AttackPlus").set_text_align(1)
	
func enable(target:String):
	get_node("VBox/Picture/AttackControls/Attack" + target).disabled = false
	get_node("VBox/Picture/AttackControls/Attack" + target).show()
	#get_node("VBox/Picture/AttackControls/AttackPlus").set_text_align(2)
	#get_node("VBox/Picture/AttackControls/AttackMinus").set_text_align(0)

func updateAttackList(modifier:int):
	Core.get_parent().get_node("Battle").updateAttackList(modifier, index)
