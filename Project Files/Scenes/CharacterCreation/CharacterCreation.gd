extends Control
const script_name := "character_creation"


onready var selected_profile := ""
onready var selected_equip := -1
const profiles := [
		["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png", "Female", "Human"],
		["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_17.png", "Male", "Human"],
		["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", "Male", "Human"],
		["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_51.png", "Female", "Vampire"]
	]
onready var gender := ""
onready var race := ""
onready var genderBackup := ""
onready var raceBackup := ""
onready var cheat := false
# Called when the node enters the scene tree for the first time.
func _ready():
	# Set button text to disabled state
	get_node("MainMenu/Choices/Complete/FlashingText").color = Color(0.7, 0.7, 0.7)
	get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.DISABLED
	
	for profile in get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children():
		profile.free()
#	for profile in profiles:
#		get_node("MainMenu/Choices/ProfileSelection/Profiles").add_child(load("res://Scenes/CharacterCreation/Profile.tscn").instance())
#		var profilePanel = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[profiles.find(profile)]
#		profilePanel.get_node("Pic").texture = load(profile)
#		profilePanel.get_node("Pic").flip_h = Characters.flip_profile[profile][0]
#		profilePanel.get_node("Pic").flip_v = Characters.flip_profile[profile][1]
	var spec = get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children()
	spec[0].get_node("Labels/Label").text = "Strength"
	spec[1].get_node("Labels/Label").text = "Perception"
	spec[2].get_node("Labels/Label").text = "Endurace"
	spec[3].get_node("Labels/Label").text = "Charisma"

	var ial = get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children()
	ial[0].get_node("Labels/Label").text = "Intelligence"
	ial[1].get_node("Labels/Label").text = "Agility"
	ial[2].get_node("Labels/Label").text = "Luck"
	var knight = get_node("MainMenu/Choices/Class/Classes/Knight")
	knight.get_node("ClassName").text = "Knight"
	knight.get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_warrior.png")

	var berserker = get_node("MainMenu/Choices/Class/Classes/Berserker")
	berserker.get_node("ClassName").text = "Berserker"
	berserker.get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_barbarian.png")

	var battle_mage = get_node("MainMenu/Choices/Class/Classes/BattleMage")
	battle_mage.get_node("ClassName").text = "Battle Mage"
	battle_mage.get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_mage.png")

	var quick_shooter = get_node("MainMenu/Choices/Class/Classes/QuickShooter")
	quick_shooter.get_node("ClassName").text = "Quick Shooter"
	quick_shooter.get_node("ImgCenter/ClassImg").texture = load("res://Assets/Images/Icons/Classes/Badge_hunter.PNG")

	Core.emit_signal("scene_loaded", self)

func updateChosenEquip(chosenEquip):
	var equips = get_node("MainMenu/Choices/Class/Classes").get_children()
	selected_equip = equips.find(chosenEquip)
	for equip in equips:
		if equip != chosenEquip:
			equip.get_node("ImgCenter/Border").hide()
			equip.chosen = false
	checkIfCompleted()

func updateChosenProfile(chosenProfile):
	var profiles = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()
	selected_profile = chosenProfile.get_node("Path").text
	for profile in profiles:
		if profile != chosenProfile:
			profile.get_node("Border").hide()
			profile.get_node("Pic").rect_position=Vector2(0,0)
			profile.get_node("Pic").rect_size=Vector2(400,400)
			profile.chosen = false
	checkIfCompleted()

func checkIfCompleted():
	if race != "" && gender != "" && (race != raceBackup or gender != genderBackup):
		genderBackup = gender
		raceBackup = race
		selected_profile = ""
		for profile in get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children():
			profile.free()
		var profileCount = 0
		for profile in profiles:
			if profile[1] == gender && profile[2] == race:
				get_node("MainMenu/Choices/ProfileSelection/Profiles").add_child(load("res://Scenes/CharacterCreation/Profile.tscn").instance())
				var profilePanel = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[profileCount]
				profilePanel.get_node("Path").text = profile[0]
				profilePanel.get_node("Pic").texture = load(profile[0])
				profilePanel.get_node("Pic").flip_h = Characters.flip_profile[profile[0]][0]
				profilePanel.get_node("Pic").flip_v = Characters.flip_profile[profile[0]][1]
				profileCount +=1
		if profileCount > 0:
			get_node("MainMenu/Choices/ProfileSelection/Warning").visible = false
			get_node("MainMenu/Choices/ProfileSelection/Warning").text = ""
		else:
			get_node("MainMenu/Choices/ProfileSelection/Warning").visible = true
			get_node("MainMenu/Choices/ProfileSelection/Warning").text = "THERE ARE NO PROFILE IMAGES TO DISPLAY"
	if selected_profile != "" && selected_equip != -1 && get_node("MainMenu/Choices/CharacterName/Name").text.length() > 0 &&  get_node("MainMenu/Choices/Stats/Display/Remaining/Total").text == "0":
		get_node("MainMenu/Choices/Complete").disabled = false
		get_node("MainMenu/Choices/Complete/FlashingText").color = Color(1, 1, 1)
		get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.ENABLED
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
	player.info = gender + " " + get_node("MainMenu/Choices/Class/Classes").get_children()[selected_equip].get_node("ClassName").text
	player.gender = gender
	player.race = race
	player.racialModifier = Characters.racialModifiers[race]
	
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children():
		player.stats[stat.name] = int(stat.get_node("Numbers/Number").text)
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children():
		player.stats[stat.name] = int(stat.get_node("Numbers/Number").text)
	
	player.picture.path = selected_profile
	player.picture.flip_profile = Characters.flip_profile[player.picture.path]
	
	CharacterManager.learn_attack(player, "attacks", "melee", "punch")
	
	if cheat:
		var classes = []
		for className in Characters.starting_attacks.keys():
			if not classes.has(className):
				CharacterManager.load_class(player, className)
			classes.append(className)
		for className in Characters.starting_attacks.keys():
			if not classes.has(className):
				CharacterManager.load_class(player, className)
			classes.append(className)
		player.health.max = 1000
		player.health.current = 1000
		for mode in ["attacks", "abilities"]:
			var attackList
			if mode == "attacks":
				attackList = Attacks
			elif mode == "abilities":
				attackList = Abilities
			for attackType in ["melee", "mana", "ranged"]:
				for attackName in attackList[attackType].keys():
					CharacterManager.learn_attack(player, mode, attackType, attackName)
		for item in Items.items.keys():
			CharacterManager.add(player, Items.items[item], 5)
	else:
		var chosen_equip = get_node("MainMenu/Choices/Class/Classes").get_children()[selected_equip].get_node("ClassName").text
		if chosen_equip == "Knight":
			chosen_equip = "knight"
		if chosen_equip == "Battle Mage":
			chosen_equip = "battle_mage"
			chosen_equip = "battle_mage"
		if chosen_equip == "Berserker":
			chosen_equip = "berserker"
		if chosen_equip == "Quick Shooter":
			chosen_equip = "quick_shooter"
		CharacterManager.load_class(player, chosen_equip)
	#print(CharacterManager.calcuate_stats(player))
	Core.player = player
	SaveManager.save()
	#####not final
	_load_battle()

func _load_battle():
	#####not final
	var CharacterSelection = load("res://Scenes/CharacterSelection/CharacterSelection.tscn").instance()
	CharacterSelection._on_play_pressed()
	queue_free()
	
func _on_Cancel_pressed():
	Core.get_parent().add_child(load("res://Scenes/CharacterSelection/CharacterSelection.tscn").instance())
	queue_free()

func _on_Male_mouse_entered():
	if gender != "Male":
		get_node("MainMenu/Choices/Gender/Male/Text").state = FlashingText.States.FLASHING

func _on_Male_mouse_exited():
	if gender != "Male":
		get_node("MainMenu/Choices/Gender/Male/Text").state = FlashingText.States.DISABLED

func _on_Male_pressed():
	gender = "Male"
	get_node("MainMenu/Choices/Gender/Male/Text").state = FlashingText.States.ENABLED
	get_node("MainMenu/Choices/Gender/Female/Text").state = FlashingText.States.DISABLED
	checkIfCompleted()

func _on_Female_mouse_entered():
	if gender != "Female":
		get_node("MainMenu/Choices/Gender/Female/Text").state = FlashingText.States.FLASHING

func _on_Female_mouse_exited():
	if gender != "Female":
		get_node("MainMenu/Choices/Gender/Female/Text").state = FlashingText.States.DISABLED

func _on_Female_pressed():
	gender = "Female"
	get_node("MainMenu/Choices/Gender/Female/Text").state = FlashingText.States.ENABLED
	get_node("MainMenu/Choices/Gender/Male/Text").state = FlashingText.States.DISABLED
	checkIfCompleted()

func set_race_state():
	var topRaces = ["Human", "Half-Elf", "Elf"]
	var botRaces = ["Dwarf", "Fairy", "Demon"]
	if race in topRaces:
		topRaces.remove(topRaces.find(race))
		get_node("MainMenu/Choices/Race/Top/" + race + "/Text").state = FlashingText.States.ENABLED
	else:
		botRaces.remove(botRaces.find(race))
		get_node("MainMenu/Choices/Race/Bot/" + race + "/Text").state = FlashingText.States.ENABLED
	for raceTemp in topRaces:
		get_node("MainMenu/Choices/Race/Top/" + raceTemp + "/Text").state = FlashingText.States.DISABLED
	for raceTemp in botRaces:
		get_node("MainMenu/Choices/Race/Bot/" + raceTemp + "/Text").state = FlashingText.States.DISABLED
	selected_profile = ""
	checkIfCompleted()

func _on_Human_pressed():
	race = "Human"
	set_race_state()

func _on_HalfElf_pressed():
	race = "Half-Elf"
	set_race_state()

func _on_Elf_pressed():
	race = "Elf"
	set_race_state()

func _on_Dwarf_pressed():
	race = "Dwarf"
	set_race_state()

func _on_Fairy_pressed():
	race = "Fairy"
	set_race_state()

func _on_Demon_pressed():
	race = "Demon"
	set_race_state()

func _on_Human_mouse_entered():
	if race != "Human":
		get_node("MainMenu/Choices/Race/Top/Human/Text").state = FlashingText.States.FLASHING

func _on_HalfElf_mouse_entered():
	if race != "Half-Elf":
		get_node("MainMenu/Choices/Race/Top/Half-Elf/Text").state = FlashingText.States.FLASHING

func _on_Elf_mouse_entered():
	if race != "Elf":
		get_node("MainMenu/Choices/Race/Top/Elf/Text").state = FlashingText.States.FLASHING

func _on_Dwarf_mouse_entered():
	if race != "Dwarf":
		get_node("MainMenu/Choices/Race/Bot/Dwarf/Text").state = FlashingText.States.FLASHING

func _on_Fairy_mouse_entered():
	if race != "Fairy":
		get_node("MainMenu/Choices/Race/Bot/Fairy/Text").state = FlashingText.States.FLASHING

func _on_Demon_mouse_entered():
	if race != "Demon":
		get_node("MainMenu/Choices/Race/Bot/Demon/Text").state = FlashingText.States.FLASHING

func _on_Human_mouse_exited():
	if race != "Human":
		get_node("MainMenu/Choices/Race/Top/Human/Text").state = FlashingText.States.DISABLED

func _on_HalfElf_mouse_exited():
	if race != "Half-Elf":
		get_node("MainMenu/Choices/Race/Top/Half-Elf/Text").state = FlashingText.States.DISABLED

func _on_Elf_mouse_exited():
	if race != "Elf":
		get_node("MainMenu/Choices/Race/Top/Elf/Text").state = FlashingText.States.DISABLED

func _on_Dwarf_mouse_exited():
	if race != "Dwarf":
		get_node("MainMenu/Choices/Race/Bot/Dwarf/Text").state = FlashingText.States.DISABLED

func _on_Fairy_mouse_exited():
	if race != "Fairy":
		get_node("MainMenu/Choices/Race/Bot/Fairy/Text").state = FlashingText.States.DISABLED

func _on_Demon_mouse_exited():
	if race != "Demon":
		get_node("MainMenu/Choices/Race/Bot/Demon/Text").state = FlashingText.States.DISABLED

func _on_Cancel_mouse_entered():
	get_node("MainMenu/Choices/Cancel/FlashingText").state = FlashingText.States.FLASHING

func _on_Cancel_mouse_exited():
	get_node("MainMenu/Choices/Cancel/FlashingText").state = FlashingText.States.ENABLED

func _on_Complete_mouse_entered():
	if !get_node("MainMenu/Choices/Complete").disabled:
		get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.FLASHING

func _on_Complete_mouse_exited():
	if !get_node("MainMenu/Choices/Complete").disabled:
		get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.ENABLED

func _on_cheat_pressed():
	_on_Male_pressed()
	_on_Human_pressed()
	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[1]._on_SelectButton_pressed()
	get_node("MainMenu/Choices/CharacterName/Name").text = "Cheater"
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children():
		stat.get_node("Numbers/Number").text = "9999"
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children():
		stat.get_node("Numbers/Number").text = "9999"
		get_node("MainMenu/Choices/Class/Classes/Knight")._on_SelectButton_pressed()
	cheat = true
	_on_Complete_pressed()
	
