extends Control
const script_name := "character_creation"

var battle_scene = load("res://Scenes/BattleScenes/Battle.tscn").instance()

onready var selected_character := -1
onready var selected_equip := -1
const profiles := ["Friendlies/Tex_AnimeAva_01.png", "Friendlies/Tex_AnimeAva_17.png", "Friendlies/Tex_AnimeAva_28.png", "Friendlies/Tex_AnimeAva_51.png"]
const character_names := ["alrune", "alrune", "alrune", "alrune"]

# Called when the node enters the scene tree for the first time.
func _ready():
	##For profile pic in profiles add a new profile to choose from
	
	##This line should dyncamically update the contents of Profiles based off the files in "res://Assets/Images/Profiles/Friendlies/"
	
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
	else:
		get_node("MainMenu/Choices/Complete").disabled = true


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
	Core.emit_signal("msg", "Chosen equipment: " + chosen_equip, Core.INFO, self)
	#player.equipment = CharacterDefaults.starting_equipment[chosen_equip]
	
	match chosen_equip:
		"knight":
			var buffs = Dictionary()
			buffs.strength = 2
			buffs.melee_attack = 10
			var sword = Item.new("weapons", "melee", "one-handed sword", "Sword", buffs, 1)
			player.items.inventory.add(sword, 1)
			CharacterManager.equip(player, sword)
			print (player.equip_buffs)
			player.attacks.melee.append("strike")
		"battle_mage":
			var buffs = Dictionary()
			buffs.intelligence = 2
			buffs.mana_attack = 10
			var staff = Item.new("weapons", "magic", "staff", "Staff", buffs, 1)
			player.items.inventory.add(staff, 1)
			CharacterManager.equip(player, staff)
			player.attacks.mana.append("flame")
		"berserker":
			var buffs = Dictionary()
			buffs.strength = 3
			buffs.agility = -1
			buffs.melee_attack = 20
			var axe = Item.new("weapons", "melee", "two-handed axe", "Two-handed Battle Axe", buffs, 1)
			player.items.inventory.add(axe, 1)
			CharacterManager.equip(player, axe)
			player.attacks.melee.append("strike")
		"quick_shooter":
			var buffs = Dictionary()
			buffs.agility = 2
			var bow = Item.new("weapons", "ranged", "hunting bow", "Bow", buffs, 1)
			var buffs2 = Dictionary()
			buffs2.luck = 1
			buffs2.melee_attack = 5
			var arrow = Item.new("weapons", "consumables", "arrow", "Arrow", buffs2, 1)
			var buffs3 = Dictionary()
			buffs3.strength = 1
			buffs3.melee_attack = 5
			var dagger = Item.new("weapons", "melee", "dagger", "Dagger", buffs3, 1)
			player.items.inventory.add(bow, 1)
			CharacterManager.equip(player, bow)
			player.items.inventory.add(arrow, 10)
			CharacterManager.equip(player, arrow)
			player.items.inventory.add(dagger, 1)
			CharacterManager.equip(player, arrow)
			player.items.attacks.ranged.append("quick_shot")
			player.items.attacks.melee.append("strike")
	
	player.file = player.meta.name + " - "+ str(OS.get_unix_time())
	Core.player = player
	
	Core.emit_signal("request_scene_load", battle_scene)
	var error = Core.connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		Core.emit_signal("msg", "Event scene_loaded failed to bind", Core.WARN, self)
	
	Core.emit_signal("request_scene_load", battle_scene)

func _on_scene_loaded(scene):
	if scene != battle_scene:
		return
	
	SaveGame.save_character(Core.player)
	
	var player2 = CharacterManager.create(character_names[selected_character])

	var enemy = CharacterManager.create("death_hound")
	var enemy2 = CharacterManager.create("death_hound")
	var enemy3 = CharacterManager.create("death_hound")
	
	Core.get_parent().get_node("Battle").load_battle("Wolf Den", "res://Assets/Images/Backgrounds/Forest.jpg", [Core.player, player2], [enemy, enemy2, enemy3])
	if scene == battle_scene:
		queue_free()
