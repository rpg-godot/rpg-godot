extends Node

static func switchScene(object, sceneName:String, background:String, friendlies:Array, enemies:Array):
	##Switch Scene
<<<<<<< HEAD:Scenes/BattleScenes/Create_Battle.gd
	object.add_child(load("res://Scenes/BattleScenes/Battle.tscn").instance())
=======
	object.add_child(load("res://BattleScenes/Battle.tscn").instance())
>>>>>>> 5641a220a4098a6df4379299a5285b2070754bdd:BattleScenes/Create_Battle.gd
	object.get_node("Battle").enemies = enemies
	object.get_node("Battle").friendlies = friendlies
	##Create Setting
	object.get_node("Battle").update_Setting(sceneName, background)
	##Update stats
	object.get_node("Battle").update_Characters()
	object.get_node("Battle").update_Attacks(0)
