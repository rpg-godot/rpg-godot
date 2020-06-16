extends Control
const script_name := "character_creation"

var battle_scene = load("res://Scenes/Battle/Battle.tscn").instance()

onready var selected_character := -1
onready var selected_equip := -1
const profiles := ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_17.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_51.png"]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set button text to disabled state
	get_node("MainMenu/Choices/Complete/FlashingText").color = Color(0.7, 0.7, 0.7)
	get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.DISABLED
	
	for profile in get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children():
		profile.free()
	for profile in profiles:
		get_node("MainMenu/Choices/ProfileSelection/Profiles").add_child(load("res://Scenes/CharacterCreation/Profile.tscn").instance())
		var profilePanel = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[profiles.find(profile)]
		profilePanel.get_node("Pic").texture = load(profile)
		profilePanel.get_node("Pic").flip_h = Characters.flip_profile[profile][0]
		profilePanel.get_node("Pic").flip_v = Characters.flip_profile[profile][1]
	var spec = get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children()
	spec[0].get_node("Labels/Label").text = "Strength"
	spec[1].get_node("Labels/Label").text = "Perception"
	spec[2].get_node("Labels/Label").text = "Endurace"
	spec[3].get_node("Labels/Label").text = "Charisma"

	var ial = get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children()
	ial[0].get_node("Labels/Label").text = "Intelligence"
	ial[1].get_node("Labels/Label").text = "Agility"
	ial[2].get_node("Labels/Label").text = "Luck"
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
	selected_equip = equips.find(chosenEquip)
	for equip in equips:
		if equip != chosenEquip:
			equip.get_node("ImgCenter/Border").hide()
			equip.chosen = false
	checkIfCompleted()

func updateChosenProfile(chosenProfile):
	var profiles = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()
	selected_character = profiles.find(chosenProfile)
	for profile in profiles:
		if profile != chosenProfile:
			profile.get_node("Border").hide()
			profile.get_node("Pic").rect_position=Vector2(0,0)
			profile.get_node("Pic").rect_size=Vector2(200,200)
			profile.chosen = false
	checkIfCompleted()

func checkIfCompleted():
	if selected_character != -1 && selected_equip != -1 && get_node("MainMenu/Choices/CharacterName/Name").text.length() > 0 &&  get_node("MainMenu/Choices/Stats/Display/Remaining/Total").text == "0":
		get_node("MainMenu/Choices/Complete").disabled = false
		get_node("MainMenu/Choices/Complete/FlashingText").color = Color(1, 1, 1)
		get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.FLASHING
	else:
		get_node("MainMenu/Choices/Complete").disabled = true
		get_node("MainMenu/Choices/Complete/FlashingText").color = Color(0.7, 0.7, 0.7)
		get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.DISABLED


func _on_Name_text_changed():
	checkIfCompleted()

func _on_Complete_pressed():
	var player = CharacterManager.create("blank")
	player.name = get_node("MainMenu/Choices/CharacterName/Name").text
	player.timeCreated = str(OS.get_unix_time())
	player.classType = "PLAYER"
	player.info = "New Character"
	
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children():
		player.stats[stat.name] = int(stat.get_node("Numbers/Number").text)
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children():
		player.stats[stat.name] = int(stat.get_node("Numbers/Number").text)
	
	player.picture.path = profiles[selected_character]
	player.picture.flip_profile = Characters.flip_profile[player.picture.path]
	
	CharacterManager.learn_attack(player, "melee", "punch")
	var chosen_equip = get_node("MainMenu/Choices/Equipment/Classes").get_children()[selected_equip].get_node("ClassName").text
	if chosen_equip == "Knight":
		chosen_equip = "knight"
	if chosen_equip == "Battle Mage":
		chosen_equip = "battle_mage"
	if chosen_equip == "Berserker":
		chosen_equip = "berserker"
	if chosen_equip == "Quick Shooter":
		chosen_equip = "quick_shooter"
	CharacterManager.load_class(player, chosen_equip)
	Core.player = player
	SaveManager.save()
	_load_battle()

func _load_battle():
	var CharacterSelection = load("res://Scenes/CharacterSelection/CharacterSelection.tscn").instance()
	CharacterSelection._on_play_pressed()
	queue_free()
