extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Classes = preload("Classes.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("/root/Variables").add_child(load("res://Test.tscn").instance())
	
	var Player = Classes.CreateCharacter("Ally", [3,3,3,3,3,3,3], ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png", true, false], [true, "res://Assets/Images/Profiles/ImageBorder.png"], [[1, 4], [1], []], 1, [0], 1, 0.5, 100, 100)
	var sword = Classes.CreateItem("weapons", "melee", "Sword", 10, [2,0,0,0,0,0,0], 1)
	var staff = Classes.CreateItem("weapons", "magic", "Staff", 10, [2,0,0,0,0,0,0], 1)
	var bow = Classes.CreateItem("weapons", "ranged", "Bow", 10, [2,0,0,0,0,0,0], 1)
	var arrow = Classes.CreateItem("weapons", "consumables", "Arrow", 5, [0,0,0,0,0,0,0], 1)
	Player.inventory.add(sword, 1)
	Player.equip(sword)
	Player.inventory.add(staff, 1)
	Player.equip(staff)
	Player.inventory.add(bow, 1)
	Player.equip(bow)
	Player.inventory.add(arrow, 10)
	Player.equip(arrow)
	
	var Player2 = Classes.CreateCharacter("Alrune", [3,3,3,3,3,3,3], ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", false, false], [true, "res://Assets/Images/Profiles/ImageBorder.png"], [[1, 2, 3, 4], [1], [1]], 1, [0], 5, 2, 200, 200)
	var Enemy = Classes.DeathHound([[], [], []], 14, [0], 1, 0.5, 100)
	var Enemy2 = Classes.DeathHound([[], [], []], 15, [0], 1, 0.5, 100)
	var Enemy3 = Classes.DeathHound([[], [], []], 16, [0], 1, 0.5, 100)
	Enemy3.health = 0
	Enemy3.name = "Dead Hound"
	#print (str(Enemy.stats))
	#print (str(Enemy2.stats))
	#print (str(Enemy3.stats))
	var BattleSceneMaker = preload("res://Scenes/BattleScenes/Create_Battle.gd")
	BattleSceneMaker.switchScene(get_node("/root/Variables"), "Wolf Den", "res://Assets/Images/Backgrounds/Forest.jpg", [Player, Player2], [Enemy, Enemy2, Enemy3])

	#get_node("/root/Variables").add_child(load("res://Scenes/CharacterCreation/CharacterCreation.tscn").instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

