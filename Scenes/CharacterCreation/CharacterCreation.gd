extends Control
const script_name := "character_creation"

var battle_scene = load("res://Scenes/BattleScenes/Battle.tscn").instance()


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var selectedCharacter = -1
onready var selectedEquip = -1
onready var Profiles = ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_17.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_51.png"]

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
		profilePanel.get_node("Pic").flip_h = Core.flipProfile[profile][0]
		profilePanel.get_node("Pic").flip_v = Core.flipProfile[profile][1]
	var spec = get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children()
	spec[0].get_node("Labels/Label").text = "Strength"
	spec[1].get_node("Labels/Label").text = "Perception"
	spec[2].get_node("Labels/Label").text = "Endurace"
	spec[3].get_node("Labels/Label").text = "Charisma"
	
	var ial = get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children()
	ial[0].get_node("Labels/Label").text = "Intelligence"
	ial[1].get_node("Labels/Label").text = "Agility"
	ial[2].get_node("Labels/Label").text = "Luck"
#	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[selectedCharacter].get_node("Border").show()
#	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[selectedCharacter].chosen = true
	var knight = get_node("MainMenu/Choices/Equipment/Classes/Knight")
	knight.get_node("ClassName").text = "Knight"
	knight.get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_warrior.png")
	
	var berserker = get_node("MainMenu/Choices/Equipment/Classes/Berserker")
	berserker.get_node("ClassName").text = "Berserker"
	berserker.get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_barbarian.png")
	
	var battle_mage = get_node("MainMenu/Choices/Equipment/Classes/BattleMage")
	battle_mage.get_node("ClassName").text = "Battle Mage"
	battle_mage.get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_mage.png")
	
	var quick_shooter = get_node("MainMenu/Choices/Equipment/Classes/QuickShooter")
	quick_shooter.get_node("ClassName").text = "Quick Shooter"
	quick_shooter.get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_hunter.PNG")
	
	Core.emit_signal("scene_loaded", self)
	
func updateChosenEquip(chosenEquip):
	var equips = get_node("MainMenu/Choices/Equipment/Classes").get_children()
	selectedEquip = equips.find(chosenEquip)
	for equip in equips:
		if equip != chosenEquip:
			equip.get_node("ImgCenter/Border").hide()
			equip.chosen = false
	checkIfCompleted()

func updateChosenProfile(chosenProfile):
	var profiles = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()
	selectedCharacter = profiles.find(chosenProfile)
	for profile in profiles:
		if profile != chosenProfile:
			profile.get_node("Border").hide()
			profile.chosen = false
	checkIfCompleted()

func checkIfCompleted():
	if selectedCharacter != -1 && selectedEquip != -1 && get_node("MainMenu/Choices/CharacterName/Name").text.length() > 0 &&  get_node("MainMenu/Choices/Stats/Display/Remaining/Total").text == "0":
		get_node("MainMenu/Choices/Complete").disabled = false
	else:
		get_node("MainMenu/Choices/Complete").disabled = true


func _on_Name_text_changed():
	checkIfCompleted()

func _on_Complete_pressed():
#	Player.stats = Core.statsProfiles[selectedCharacter]
#	Player.something = [true, "res://Assets/Images/Profiles/ImageBorder.png"]
#	Player.something = [[1], [], []]
#	Player.something = 1
#	Player.something = [0]
#	Player.something = 1
#	Player.something = 0.5
#	Player.something = 100
#	Player.something = 100
	
#	var chosenEquip = get_node("MainMenu/Choices/Equipment/Classes").get_children()[selectedEquip].get_node("ClassName").text
#	if chosenEquip == "Knight":
#		var sword = Item.new()
#		#sword.something = ("weapons", "melee", "one-handed sword", "Sword", [2,0,0,0,0,0,0,10,0,0], 1)
#		Player.inventory.add(sword, 1)
#		Player.equip(sword)
#		print (Player.equipBuffs)
#		Player.attacks["melee"].append(4)
#	if chosenEquip == "Battle Mage":
#		var staff = Item.new()
#		#staff.something = ("weapons", "magic", "staff", "Staff", [0,0,0,0,2,0,0,0,10,0], 1)
#		Player.inventory.add(staff, 1)
#		Player.equip(staff)
#		Player.attacks["mana"].append(1)
#	if chosenEquip == "Berserker":
#		var axe = Item.new()
#		#axe.something = ("weapons", "melee", "two-handed axe", "Two-handed Battle Axe", [3,0,0,0,0,-1,0,20,0,0], 1)
#		Player.inventory.add(axe, 1)
#		Player.equip(axe)
#		Player.attacks["melee"].append(4)
#	if chosenEquip == "Quick Shooter":
#		var bow = Item.new()
#		#bow.something = Classes.CreateItem("weapons", "ranged", "hunting bow", "Bow", [0,0,0,0,0,2,0,0,0,0], 1)
#		var arrow = Item.new()
#		#arrow.somethingClasses.CreateItem("weapons", "consumables", "arrow", "Arrow", [0,0,0,0,0,0,1,5,0,0], 1)
#		var dagger = Item.new()
#		#dagger.something = ("weapons", "melee", "dagger", "Dagger", [1,0,0,0,0,0,0,5,0,0], 1)
#		Player.inventory.add(bow, 1)
#		Player.equip(bow)
#		Player.inventory.add(arrow, 10)
#		Player.equip(arrow)
#		Player.inventory.add(dagger, 1)
#		Player.equip(arrow)
#		Player.attacks["ranged"].append(1)
#		Player.attacks["melee"].append(4)
	
	Core.emit_signal("request_scene_load", battle_scene)
	var error = Core.connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		Core.emit_signal("msg", "Event scene_loaded failed to bind", Core.WARN, self)
	
	Core.emit_signal("request_scene_load", battle_scene)

func _on_scene_loaded(scene):
	var stats = []
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children():
		stats.append(int(stat.get_node("Numbers/Number").text))
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children():
		stats.append(int(stat.get_node("Numbers/Number").text))
	
	var Player = Character.new()
	Player.character_name = get_node("MainMenu/Choices/CharacterName/Name").text
	
	# load default save data and override player with chosen data then save the file and start the game
	var data = {
		name = Player.character_name,
		info = "Breathes fire",
		picture = Player.pic[0],
		saveFile = Player.character_name + " - "+ str(OS.get_unix_time()),
		player = Player
	}
	SaveGame.save_character(data)
	
	var Player2 = Character.new()
	Player2.character_name = "Alrune"
#	Player2.something = [8,8,8,8,8,8,8]
#	Player2.something = "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png"
#	Player2.something = [true, "res://Assets/Images/Profiles/ImageBorder.png"]
#	Player2.something = [[1, 2, 3, 4] [1], [1]]
#	Player2.something = 1
#	Player2.something = [0]
#	Player2.something = 5
#	Player2.something = 2
#	Player2.something = 200
#	Player2.something = 200

	var Enemy = DeathHound.new()
	#Enemy.something = [[], [], []], 14, [0], 1, 0.5, 100)
	var Enemy2 = DeathHound.new()
	#Enemy2.something = [[], [], []], 15, [0], 1, 0.5, 100)
	var Enemy3 = DeathHound.new()
	#Enemy3.something = [[], [], []], 16, [0], 1, 0.5, 100)
	Enemy3.health = 0
	Enemy3.character_name = "Dead Hound"
	
	Core.get_parent().get_node("Battle").load_battle("Wolf Den", "res://Assets/Images/Backgrounds/Forest.jpg", [Player, Player2], [Enemy, Enemy2, Enemy3])
	if scene == battle_scene:
		queue_free()
