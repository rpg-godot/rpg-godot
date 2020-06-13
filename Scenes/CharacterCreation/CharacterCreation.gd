extends Control
const script_name := "character_creation"

var battle_scene = load("res://Scenes/Battle/Battle.tscn").instance()

onready var selected_character := -1
onready var selected_equip := -1
const profiles := ["Friendlies/Tex_AnimeAva_01.png", "Friendlies/Tex_AnimeAva_17.png", "Friendlies/Tex_AnimeAva_28.png", "Friendlies/Tex_AnimeAva_51.png"]
const character_names := ["alrune", "alrune", "alrune", "alrune"]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set button text to disabled state
	get_node("MainMenu/Choices/Complete/FlashingText").color = Color(0.7, 0.7, 0.7)
	get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.ENABLED
	
	for profile in get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children():
		profile.free()
	for profile in profiles:
		get_node("MainMenu/Choices/ProfileSelection/Profiles").add_child(load("res://Scenes/CharacterCreation/Profile.tscn").instance())
		var profilePanel = get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[profiles.find(profile)]
		profilePanel.get_node("Pic").texture = load("res://Assets/Images/Profiles/" + profile)
		profilePanel.get_node("Pic").flip_h = CharacterDefaults.flip_profile[profile][0]
		profilePanel.get_node("Pic").flip_v = CharacterDefaults.flip_profile[profile][1]
	var spec = get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children()
	spec[0].get_node("Labels/Label").text = "Strength"
	spec[1].get_node("Labels/Label").text = "Perception"
	spec[2].get_node("Labels/Label").text = "Endurace"
	spec[3].get_node("Labels/Label").text = "Charisma"

	var ial = get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children()
	ial[0].get_node("Labels/Label").text = "Intelligence"
	ial[1].get_node("Labels/Label").text = "Agility"
	ial[2].get_node("Labels/Label").text = "Luck"
	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[selected_character].get_node("Border").show()
	get_node("MainMenu/Choices/ProfileSelection/Profiles").get_children()[selected_character].chosen = true
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
		get_node("MainMenu/Choices/Complete/FlashingText").state = FlashingText.States.ENABLED


func _on_Name_text_changed():
	checkIfCompleted()

func _on_Complete_pressed():
	var character_name = get_node("MainMenu/Choices/CharacterName/Name").text

	var stats = []
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/SPEC").get_children():
		stats.append(int(stat.get_node("Numbers/Number").text))
	for stat in get_node("MainMenu/Choices/Stats/Display/Menu/IAL").get_children():
		stats.append(int(stat.get_node("Numbers/Number").text))

	var player = CharacterManager.create(character_names[selected_character])
	player.nickname = character_name
	player.stats = stats

	var chosen_equip = CharacterDefaults.starting_equipment.keys()[selected_equip]
	Core.emit_signal("msg", "Chosen equipment: " + chosen_equip, Log.INFO, self)
	#player.equipment = CharacterDefaults.starting_equipment[chosen_equip]
	CharacterManager.load_class(player, chosen_equip)

	player.file = player.meta.name + " - "+ str(OS.get_unix_time())
	Core.player = player

	Core.emit_signal("request_scene_load", battle_scene)
	var error = Core.connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		Core.emit_signal("msg", "Event scene_loaded failed to bind", Log.WARN, self)

	Core.emit_signal("request_scene_load", battle_scene)

func _on_scene_loaded(scene):
	if scene != battle_scene:
		return

	SaveGame.save_character(Core.player)

	var player2 = CharacterManager.create(character_names[selected_character])

	var enemy1 = CharacterManager.create("death_hound")
	CharacterManager.set_level(enemy1, int(rand_range(1, 10)))
	var enemy2 = CharacterManager.create("death_hound")
	CharacterManager.set_level(enemy2, int(rand_range(1, 10)))
	var enemy3 = CharacterManager.create("death_hound")
	CharacterManager.set_level(enemy3, int(rand_range(1, 10)))

	Core.get_parent().get_node("Battle").load_battle("Wolf Den", "res://Assets/Images/Backgrounds/Forest.jpg", [Core.player, player2], [enemy1, enemy2, enemy3])
	if scene == battle_scene:
		queue_free()
