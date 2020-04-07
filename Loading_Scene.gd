extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("/root/Variables").add_child(load("res://Test.tscn").instance())
	var Classes = preload("Classes.gd")
	var Player = Classes.CreateClass("Ally", [8,8,8,8,8,8,8], ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png", true, false], [true, "res://Assets/Images/Profiles/Image Border.png"], [[1, 4], [1], []], 1, [0], 1, 0.5, 100, 100)
	var Enemy = Classes.DeathHound([[], [], []], 14, [0], 1, 0.5, 100)
	var Enemy2 = Classes.DeathHound([[], [], []], 15, [0], 1, 0.5, 100)
	var Enemy3 = Classes.DeathHound([[], [], []], 16, [0], 1, 0.5, 100)
	Enemy3.health = 0
	Enemy3.name = "Dead Hound"
	#print (str(Enemy.stats))
	#print (str(Enemy2.stats))
	#print (str(Enemy3.stats))
	
	var BattleSceneMaker = preload("Create_Battle.gd")
	BattleSceneMaker.switchScene(get_node("/root/Variables"), "Wolf Den", "res://Assets/Images/Backgrounds/Forest.jpg", [Player], [Enemy, Enemy2, Enemy3])



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

