extends Node
class_name Battle
const script_name := "battle"

onready var BattleBoard := $"TopScreen/DisplayArea/BattleBoard/"
onready var AttackList := $"TopScreen/DisplayArea/AttackBoard/"
onready var friendlies := []
onready var activeCharacterIndex := 0
onready var enemies := []

var battle_name setget set_battle_name, get_battle_name
var background setget set_background, get_background

func set_battle_name(value):
	get_node("TopScreen/AreaTitle/Name").text = value

func get_battle_name():
	return get_node("TopScreen/AreaTitle/Name").text

func set_background(value):
	get_node("TopScreen/Background").texture = load(value)

func get_background():
	return get_node("TopScreen/Background").texture

# ==== Prototype text ===========================
# Alrune Hit Grand Wolf for 25 damage with Strike
# Grand Wolf Bit Alrune for 15 Damage
# Alrune heals for 20 HP
# Grand Hound Has Died




func load_battle(new_battle_name: String, new_background: String, new_friendlies: Array, new_enemies: Array):
	# Switch Scene
	friendlies = new_friendlies
	enemies = new_enemies
	
	# Create Setting
	battle_name = new_battle_name
	background = new_background
	
	# Initiate and unhide needed tiles
	for character in friendlies:
		setup_friendly(character)
	for character in enemies:
		setup_enemy(character)
	
	# Update stats
	update_characters()
	update_attacks(0)




func _ready():
	BattleBoard.show()
	AttackList.hide()
	#Hide all tiles until needed
	var allFriendlies = get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").get_children()
	var allEnemies = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()
	for friendPanel in allFriendlies:
		friendPanel.free()
	for enemyPanel in allEnemies:
		enemyPanel.free()
	
	var error = Core.connect("msg", self, "_on_msg")
	if error:
		Core.emit_signal("msg", "Event msg failed to bind", Core.WARN, self)
		print("Warn: Event msg failed to bind")
	
	Core.emit_signal("scene_loaded", self)




func _on_msg(message, level, obj):
	get_node('BattleText').add_text(message + '\n')




func setup_friendly(character):
	## Looks
	var character_panel = load("res://Scenes/BattleScenes/CharacterPanel.tscn").instance()
	get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").add_child(character_panel)
	
	var picture = character_panel.get_node("VBox/Picture/Pic")
	picture.texture = load("res://Assets/Images/Profiles/" + character.picture.path)
	picture.flip_h = CharacterDefaults.flip_profile[character.picture.path][0]
	picture.flip_v = CharacterDefaults.flip_profile[character.picture.path][1]
	
	character_panel.get_node("VBox/Name").text = character.meta.name
	character_panel.show()
	
	if character.picture.border.shown:
		var picture_border = load("res://Assets/Images/Profiles/" + character.picture.border.path)
		character_panel.get_node("VBox/Picture/PicBorder").texture = picture_border
		character_panel.get_node("VBox/Picture/PicBorder").show()
	else:
		character_panel.get_node("VBox/Picture/PicBorder").hide()




func setup_enemy(character):
	##looks
	var enemy_panel = load("res://Scenes/BattleScenes/EnemyPanel.tscn").instance()
	get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").add_child(enemy_panel)
	var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()[enemies.find(character)]
	
	var picture = enemyPanel.get_node("VBox/Control/Pic")
	picture.texture = load("res://Assets/Images/Profiles/" + character.picture.path)
	picture.flip_h = CharacterDefaults.flip_profile[character.picture.path][0]
	picture.flip_v = CharacterDefaults.flip_profile[character.picture.path][1]
	
	enemyPanel.get_node("VBox/Name").text = character.meta.name
	enemyPanel.show()
	
	var border = enemyPanel.get_node("VBox/Control/PicBorder")
	if character.picture.border.shown:
		border.texture = load("res://Assets/Images/Profiles/" + character.picture.border.path)
		border.show()
	else:
		border.hide()



var attack_count = 0
func update_attacks(CharacterIndex):
	var attacksList = get_node("TopScreen/DisplayArea/AttackBoard/AttackScrollBar/AttacksList")
	for attack in attacksList.get_children():
		attack.free()
	# Add character attacks
	var attacks = friendlies[CharacterIndex].attacks
	
	var attack_scene = load("res://Scenes/BattleScenes/AttackItem.tscn")
	
	Core.emit_signal("msg", "Rendering attacks...", Core.DEBUG, self)
	Core.emit_signal("msg", str(attacks), Core.DEBUG, self)
	for attack in attacks.melee:
		var attack_item = attack_scene.instance()
		attacksList.add_child(attack_item)
		create_melee_button(attack, attack_item, CharacterIndex)
		
	for attack in attacks.ranged:
		var attack_item = attack_scene.instance()
		attacksList.add_child(attack_item)
		create_ranged_button(attack, attack_item, CharacterIndex)
		
	for attack in attacks.mana:
		var attack_item = attack_scene.instance()
		attacksList.add_child(attack_item)
		create_mana_button(attack, attack_item, CharacterIndex)

func create_melee_button(attack, attack_item, CharacterIndex):
	var disabled = true

	var attack_data = Attacks.melee[attack]
	var attackName = attack_data.name
	var attackDamage = attack_data.hp_damage
	var attackCost = attack_data.ap_cost
	var pictureLocation = attack_data.image
	attack_item.get_node("Description").text = """Attack Name: %s
HP Damage: %s
AP Cost: %s""" % [attackName, attackDamage, attackCost]
	
	#disabled = check_melee_cost(attackCost, CharacterIndex, attack, attack_data)
	
	attack_item.get_node("Picture").texture = load(pictureLocation)
	attack_item.get_node("Use").disabled = disabled
	attack_count+=1

func create_ranged_button(attack, attack_item, CharacterIndex):
	var disabled = true

	var attack_data = Attacks.ranged[attack]
	var attackName = attack_data.name
	var attackDamage = attack_data.hpDamage
	var attackCost = attack_data.APcost
	var ammoCost = attack_data.ammoCost
	var pictureLocation = attack_data.image
	attack_item.get_node("Description").text = """Attack Name: %s
HP Damage: %s
AP Cost: %s
Ammo Cost: %s""" % [attackName, attackDamage, attackCost, ammoCost]
	
	#disabled = check_ranged_cost(attackCost, CharacterIndex, attack, attack_data)
	
	attack_item.get_node("Picture").texture = load(pictureLocation)
	attack_item.get_node("Use").disabled = disabled
	attack_count+=1

func create_mana_button(attack, attack_item, CharacterIndex):
	var disabled = true
	
	var attack_data = Attacks.mana[attack]
	var attackName = attack_data.name
	var attackDamage = attack_data.hpDamage
	var manaDamage = attack_data.manaDamage
	var attackCost = attack_data.APcost
	var manaCost = attack_data.manaCost
	var pictureLocation = attack_data.image
	
	#disabled = check_mana_cost(attackCost, CharacterIndex, attack, attack_data, manaCost)
	
	attack_item.get_node("Description").text = """Attack Name: %s
HP Damage: %s
Mana Damage: %s
AP Cost: %s
Mana Cost: %s""" % [attackName, attackDamage, manaDamage, attackCost, manaCost]
	attack_item.get_node("Picture").texture = load(pictureLocation)
	attack_item.get_node("Use").disabled = disabled
	attack_count+=1


func check_melee_cost(attack_cost, CharacterIndex, attack, attack_data):
	var equipment = friendlies[CharacterIndex].items.equipment
	
	if attack_cost <= friendlies[CharacterIndex].ap:
		if equipment.melee.size() > 0:
			if equipment.melee[0].name in attack_data.weapon:
				if equipment.melee[0].level_requirement >= attack_data.item_level:
					return false
		if "none" in attack_data.weapon:
			if friendlies[CharacterIndex].level >= attack_data.level_requirements:
				return false


func check_ranged_cost(attack_cost, CharacterIndex, attack, attack_data):
	var equipment = friendlies[CharacterIndex].items.equipment
	
	if attack_cost <= friendlies[CharacterIndex].AP:
		if equipment.ranged.size() > 0:
			if equipment.ranged[0].name in attack_data.weapon:
				if equipment.ranged[0].level_requirement >= attack_data.item_level:
					for ammo in equipment.consumables:
						return false
						#if ammo[1] >= attack_data.ammo_cost:
							#if ammo[0].subType in attack_data.weaponNeeded[1] && ammo[0].levelRequirement >=  rangedAttackList[attack]["itemLevelRequirements"]:
								#return false
		if "none" in attack_data.weapon:
			if friendlies[CharacterIndex].level >= attack_data.level_requirement:
				for ammo in friendlies[CharacterIndex].inventory.items["weapons"]["consumables"]:
					if ammo[0].subType in attack_data.weapon[1]:
						if ammo[1] >= attack_data.ammo_cost && ammo[0].level_requirement >=  attack_data.level_requirements:
							return false
					else:
						return false


func check_mana_cost(attack_cost, CharacterIndex, attack, attack_data, mana_cost):
	var equipment = friendlies[CharacterIndex].items.equipment
	
	if attack_cost <= friendlies[CharacterIndex].AP && mana_cost <= friendlies[CharacterIndex].mana:
		if equipment.magic.size() > 0:
			if equipment.magic[0].subType in attack_data.weapon || "none" in attack_data.weapon:
				if equipment.magic[0].level_requirement >= attack_data.level:
					return false
		if "none" in attack_data.weapon_needed:
			if friendlies[CharacterIndex].level >= attack_data.level_requirements:
				return false


func _on_Attack_pressed():
	BattleBoard.hide()
	AttackList.show()
	enemies[0].health.current-=10
	update_attacks(activeCharacterIndex)
	Core.emit_signal('msg', 'You dealt ' + str(10) + ' damage!', Core.INFO, self)

func _on_Items_pressed():
	BattleBoard.hide()
	AttackList.hide()

func _on_Abilities_pressed():
	BattleBoard.hide()
	AttackList.hide()

func _on_Retreat_pressed():
	pass # Replace with function body.

func _on_BackButton_pressed():
	BattleBoard.show()
	AttackList.hide()
	update_characters()




func update_characters():
	# update stats
	for character in friendlies:
		# looks
		var friendPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").get_children()[friendlies.find(character)]
		# stats
		friendPanel.get_node("VBox/Health/HealthBar").value = character.health.current*100/character.health.max
		friendPanel.get_node("VBox/Health/HealthText").text = "Health: %d/%d" % [character.health.current, character.health.max]
		if character.mana.max > 0:
			friendPanel.get_node("VBox/Mana/ManaBar").value = character.mana.current*100/character.mana.max
			friendPanel.get_node("VBox/Mana/ManaText").text = "Mana: %d/%d" % [character.mana.current, character.mana.max]
		else:
			friendPanel.get_node("VBox/Mana/ManaBar").value = 0
			friendPanel.get_node("VBox/Mana/ManaText").text = "Mana: 0/0"
		if character.health.current > 0:
			friendPanel.get_node("VBox/Picture/Blood").hide()
		else:
			# friendly die
			Core.emit_signal('msg', 'An friend has died!', Core.INFO, self)
			friendPanel.get_node("VBox/Picture/Blood").show()
	for character in enemies:
		# looks
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()[enemies.find(character)]
		# stats
		enemyPanel.get_node("VBox/Health/HealthBar").value = character.health.current*100/character.health.max
		enemyPanel.get_node("VBox/Health/HealthText").text = "Health: %d/%d" % [character.health.current, character.health.max]
		enemyPanel.get_node("VBox/HealthAndMana/Health/HealthBar").value = character.mana.current*100/character.mana.max
		enemyPanel.get_node("VBox/HealthAndMana/Health/HealthText").text = "Health: %d/%d" % [character.health.current, character.health.max]
		if character.mana.max > 0:
			enemyPanel.get_node("VBox/HealthAndMana/Mana/ManaBar").value = character.mana.current*100/character.mana.max
			enemyPanel.get_node("VBox/HealthAndMana/Mana/ManaText").text = "Mana: %d/%d" % [character.mana.current, character.mana.max]
		else:
			enemyPanel.get_node("VBox/HealthAndMana/Mana/ManaBar").value = 0
			enemyPanel.get_node("VBox/HealthAndMana/Mana/ManaText").text = "Mana: 0/0"
		enemyPanel.get_node("VBox/Health").show()
		enemyPanel.get_node("VBox/HealthAndMana").hide()
		if character.health.current > 0:
			enemyPanel.get_node("VBox/Control/Blood").hide()
		else:
			# enemy die
			Core.emit_signal('msg', 'An enemy has died!', Core.INFO, self)
			enemyPanel.get_node("VBox/Control/Blood").show()
