extends Node

onready var Classes = preload("Classes.gd").new()
onready var SaveGame = preload("res://Scripts/SaveGame.gd").new()

func _ready():
	#get_node("/root/Variables").add_child(load("res://Test.tscn").instance())
	
	#var Player = Classes.CreateCharacter("Ally", [3,3,3,3,3,3,3], "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png", [true, "res://Assets/Images/Profiles/ImageBorder.png"], [[1, 4], [1], []], 1, [0], 1, 0.5, 100, 100)
	#var Player2 = Classes.CreateCharacter("Alrune", [3,3,3,3,3,3,3], "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", [true, "res://Assets/Images/Profiles/ImageBorder.png"], [[1, 2, 3, 4], [1], [1]], 1, [0], 5, 2, 200, 200)
	#var Enemy = Classes.DeathHound([[], [], []], 14, [0], 1, 0.5, 100)
	#var Enemy2 = Classes.DeathHound([[], [], []], 15, [0], 1, 0.5, 100)
	#var Enemy3 = Classes.DeathHound([[], [], []], 16, [0], 1, 0.5, 100)
	#Enemy3.health = 0
	#Enemy3.name = "Dead Hound"
	#print (str(Enemy.stats))
	#print (str(Enemy2.stats))
	#print (str(Enemy3.stats))
	#var BattleSceneMaker = preload("res://Scenes/BattleScenes/Create_Battle.gd")
	#BattleSceneMaker.switchScene(get_node("/root/Variables"), "Wolf Den", "res://Assets/Images/Backgrounds/Forest.jpg", [Player, Player2], [Enemy, Enemy2, Enemy3])
	
	Core.add_child(load("res://Scenes/CharacterCreation/CharacterCreation.tscn").instance())
	

func example_save():
	var character = {}
	character.name = "Legondary Dragon"
	character.info = "Breathes fire"
	character.picture = "Tex_AnimeAva_01.png"
	SaveGame.save_character(0, character)
