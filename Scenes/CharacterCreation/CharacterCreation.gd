extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var selectedCharacter = -1
onready var selectedEquip = -1
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
	get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children()[0].get_node("Labels/Label").text = "Strength"
	get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children()[1].get_node("Labels/Label").text = "Perception"
	get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children()[2].get_node("Labels/Label").text = "Endurace"
	get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children()[3].get_node("Labels/Label").text = "Charisma"
	get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children()[0].get_node("Labels/Label").text = "Intelligence"
	get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children()[1].get_node("Labels/Label").text = "Agility"
	get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children()[2].get_node("Labels/Label").text = "Luck"
#	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[selectedCharacter].get_node("Border").show()
#	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[selectedCharacter].chosen = true
	get_node("MainMenu/Choices/Equipment/Classes/Knight").get_node("ClassName").text = "Knight"
	get_node("MainMenu/Choices/Equipment/Classes/Knight").get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_warrior.png")
	get_node("MainMenu/Choices/Equipment/Classes/Berserker").get_node("ClassName").text = "Berserker"
	get_node("MainMenu/Choices/Equipment/Classes/Berserker").get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_barbarian.png")
	get_node("MainMenu/Choices/Equipment/Classes/BattleMage").get_node("ClassName").text = "Battle Mage"
	get_node("MainMenu/Choices/Equipment/Classes/BattleMage").get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_mage.png")
	get_node("MainMenu/Choices/Equipment/Classes/QuickShooter").get_node("ClassName").text = "Quick Shooter"
	get_node("MainMenu/Choices/Equipment/Classes/QuickShooter").get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_hunter.PNG")

func updateChosenProfile(chosenProfile):
	var profiles = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()
	selectedCharacter = profiles.find(chosenProfile)
	for profile in profiles:
		if profile != chosenProfile:
			profile.get_node("Border").hide()
			profile.chosen = false
	checkIfCompleted()
	
func updateChosenEquip(chosenEquip):
	var equips = get_node("MainMenu/Choices/Equipment/Classes").get_children()
	selectedEquip = equips.find(chosenEquip)
	for equip in equips:
		if equip != chosenEquip:
			equip.get_node("ImgCenter/Border").hide()
			equip.chosen = false
	checkIfCompleted()

func checkIfCompleted():
	if selectedCharacter != -1 && selectedEquip != -1 && get_node("MainMenu/Choices/CharacterName/Name").text.length() > 0 &&  get_node("MainMenu/Choices/Stats/Display/Remaining/Total").text == "0":
		get_node("MainMenu/Choices/Complete").disabled = false
	else:
		get_node("MainMenu/Choices/Complete").disabled = true


func _on_Name_text_changed():
	checkIfCompleted()

func _on_Complete_pressed():
	var stats = []
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children():
		stats.append(int(stat.get_node("Numbers/Number").text))
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children():
		stats.append(int(stat.get_node("Numbers/Number").text))
	var Player = Classes.CreateCharacter(get_node("MainMenu/Choices/CharacterName/Name").text, stats, [Profiles[selectedCharacter], true, false], [true, "res://Assets/Images/Profiles/ImageBorder.png"], [[1], [], []], 1, [0], 1, 0.5, 100, 100)
	var chosenEquip = get_node("MainMenu/Choices/Equipment/Classes").get_children()[selectedEquip].get_node("ClassName").text
	if chosenEquip == "Knight":
		var sword = Classes.CreateItem("weapons", "melee", "one-handed sword", "Sword", [2,0,0,0,0,0,0,10,0,0], 1)
		Player.inventory.add(sword, 1)
		Player.equip(sword)
		print (Player.equipBuffs)
		Player.attacks["melee"].append(4)
	if chosenEquip == "Battle Mage":
		var staff = Classes.CreateItem("weapons", "magic", "staff", "Staff", [0,0,0,0,2,0,0,0,10,0], 1)
		Player.inventory.add(staff, 1)
		Player.equip(staff)
		Player.attacks["mana"].append(1)
	if chosenEquip == "Berserker":
		var axe = Classes.CreateItem("weapons", "melee", "two-handed axe", "Two-handed Battle Axe", [3,0,0,0,0,-1,0,20,0,0], 1)
		Player.inventory.add(axe, 1)
		Player.equip(axe)
		Player.attacks["melee"].append(4)
	if chosenEquip == "Quick Shooter":
		var bow = Classes.CreateItem("weapons", "ranged", "hunting bow", "Bow", [0,0,0,0,0,2,0,0,0,0], 1)
		var arrow = Classes.CreateItem("weapons", "consumables", "arrow", "Arrow", [0,0,0,0,0,0,1,5,0,0], 1)
		var dagger = Classes.CreateItem("weapons", "melee", "dagger", "Dagger", [1,0,0,0,0,0,0,5,0,0], 1)
		Player.inventory.add(bow, 1)
		Player.equip(bow)
		Player.inventory.add(arrow, 10)
		Player.equip(arrow)
		Player.inventory.add(dagger, 1)
		Player.equip(arrow)
		Player.attacks["ranged"].append(1)
		Player.attacks["melee"].append(4)
	var Player2 = Classes.CreateCharacter("Alrune", [8,8,8,8,8,8,8], ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", false, false], [true, "res://Assets/Images/Profiles/ImageBorder.png"], [[1, 2, 3, 4], [1], [1]], 1, [0], 5, 2, 200, 200)
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
