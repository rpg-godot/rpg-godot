extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var selectedCharacter = -1
onready var Profiles = ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_17.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_51.png"]
onready var Classes = get_node("/root/Variables").Classes

# Called when the node enters the scene tree for the first time.
func _ready():
	##For profile pic in profiles add a new profile to choose from
	
	##This line should dyncamically update the contents of Profiles based off the files in "res://Assets/Images/Profiles/Friendlies/"
	
	for profile in get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children():
		profile.free()
	for profile in Profiles:
		get_node("MainMenu/Choices/ProfileSelection/Profiles").add_child(load("res://Scenes/CharacterCreation/Profile.tscn").instance())
		var profilePanel = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[Profiles.find(profile)]
		profilePanel.get_node("Pic").texture = load(profile)
#	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[selectedCharacter].get_node("Border").show()
#	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[selectedCharacter].chosen = true

func update_chosen(chosenProfile):
	var profiles = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()
	selectedCharacter = profiles.find(chosenProfile)
	for profile in profiles:
		if profile != chosenProfile:
			profile.get_node("Border").hide()
			profile.chosen = false
	checkIfCompleted()

func checkIfCompleted():
	if selectedCharacter != -1 && get_node("MainMenu/Choices/CharacterName/Name").text.length() > 0:
		get_node("MainMenu/Choices/Complete").disabled = false
	else:
		get_node("MainMenu/Choices/Complete").disabled = true


func _on_Name_text_changed():
	checkIfCompleted()

func _on_Complete_pressed():
	var Player = Classes.CreateClass(get_node("MainMenu/Choices/CharacterName/Name").text, [8,8,8,8,8,8,8], [Profiles[selectedCharacter], true, false], [true, "res://Assets/Images/Profiles/Image Border.png"], [[1, 4], [1], []], 1, [0], 1, 0.5, 100, 100)
	var Player2 = Classes.CreateClass("Alrune", [8,8,8,8,8,8,8], ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", false, false], [true, "res://Assets/Images/Profiles/Image Border.png"], [[1, 2, 3, 4], [1], [1]], 1, [0], 5, 2, 200, 200)
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
