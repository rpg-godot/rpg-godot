extends Node
const script_name := "create_battle"

static func switchScene(object, sceneName:String, background:String, friendlies:Array, enemies:Array):
	##Switch Scene
	object.add_child(load("res://Scenes/BattleScenes/Battle.tscn").instance())
	object.get_node("Battle").enemies = enemies
	object.get_node("Battle").friendlies = friendlies
	##Create Setting
	object.get_node("Battle").update_Setting(sceneName, background)
	##Update stats
	object.get_node("Battle").update_Characters()
	object.get_node("Battle").update_Attacks(0)
