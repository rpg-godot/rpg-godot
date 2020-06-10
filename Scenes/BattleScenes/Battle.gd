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
	picture.texture = load(character.picture.path)
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
	picture.texture = load(character.picture.path)
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




func update_attacks(CharacterIndex):
	pass
#	var attacksList = get_node("TopScreen/DisplayArea/AttackBoard/AttackScrollBar/AttacksList")
#	for attack in attacksList.get_children():
#		attack.free()
#	##Add character attacks
#	var attackCount = 0
#	print (friendlies[CharacterIndex].attacks)
#	for attack in friendlies[CharacterIndex].attacks["melee"]:
#		attacksList.add_child(load("res://Scenes/BattleScenes/AttackItem.tscn").instance())
#		var attackItem = attacksList.get_children()[attackCount]
#		var pictureLocation
#		var disabled = true
#
#		var attack_data = CharacterDefaults.meleeAttackList[attack]
#		var attackName = attack_data.name
#		var attackDamage = attack_data.hpDamage
#		var attackCost = attack_data.APcost
#		pictureLocation = attack_data.image
#		attackItem.get_node("Description").text = """Attack Name: %s
#HP Damage: %s
#AP Cost: %s""" % [attackName, attackDamage, attackCost]
#		if attackCost <= friendlies[CharacterIndex].AP:
#			if friendlies[CharacterIndex].equipment.items["weapons"]["melee"].size() > 0:
#				if friendlies[CharacterIndex].equipment.items["weapons"]["melee"][0][0].subType in attack_data.weapon:
#					if friendlies[CharacterIndex].equipment.items["weapons"]["melee"][0][0].levelRequirement >= attack_data.item_level:
#						disabled = false
#			if "none" in CharacterDefaults.meleeAttackList[attack].weaponNeeded:
#				if friendlies[CharacterIndex].level >= CharacterDefaults.meleeAttackList[attack]["itemLevelRequirements"]:
#					disabled = false
#		attackItem.get_node("Picture").texture = load(pictureLocation)
#		attackItem.get_node("Use").disabled = disabled
#		attackCount+=1
#	for attack in friendlies[CharacterIndex].attacks["ranged"]:
#		attacksList.add_child(load("res://Scenes/BattleScenes/AttackItem.tscn").instance())
#		var attackItem = attacksList.get_children()[attackCount]
#		var pictureLocation
#		var disabled = true
#
#		var attack_data = CharacterDefaults.rangedAttackList[attack]
#		var attackName = attack_data.name
#		var attackDamage = attack_data.hpDamage
#		var attackCost = attack_data.APcost
#		var ammoCost = attack_data.ammoCost
#		pictureLocation = attack_data.image
#		attackItem.get_node("Description").text = """Attack Name: %s
#HP Damage: %s
#AP Cost: %s
#Ammo Cost: %s""" % [attackName, attackDamage, attackCost, ammoCost]
#		if attackCost <= friendlies[CharacterIndex].AP:
#			if friendlies[CharacterIndex].equipment.items["weapons"]["ranged"].size() > 0:
#				if friendlies[CharacterIndex].equipment.items["weapons"]["ranged"][0][0].subType in rangedAttackList[attack].weaponNeeded[0]:
#					if friendlies[CharacterIndex].equipment.items["weapons"]["ranged"][0][0].levelRequirement >= rangedAttackList[attack]["itemLevelRequirements"]:
#						for ammo in friendlies[CharacterIndex].inventory.items["weapons"]["consumables"]:
#							if ammo[1] >= rangedAttackList[attack].ammoCost:
#								if ammo[0].subType in rangedAttackList[attack].weaponNeeded[1] && ammo[0].levelRequirement >=  rangedAttackList[attack]["itemLevelRequirements"]:
#									disabled = false
#			if "none" == rangedAttackList[attack].weaponNeeded[0][0]:
#				if friendlies[CharacterIndex].level >= rangedAttackList[attack]["itemLevelRequirements"]:
#					for ammo in friendlies[CharacterIndex].inventory.items["weapons"]["consumables"]:
#						if ammo[0].subType in rangedAttackList[attack].weaponNeeded[1]:
#							if ammo[1] >= rangedAttackList[attack].ammoCost && ammo[0].levelRequirement >=  rangedAttackList[attack]["itemLevelRequirements"]:
#								disabled = false
#						else:
#							disabled = false
#		attackItem.get_node("Picture").texture = load(pictureLocation)
#		attackItem.get_node("Use").disabled = disabled
#		attackCount+=1
#	for attack in friendlies[CharacterIndex].attacks["mana"]:
#		attacksList.add_child(load("res://Scenes/BattleScenes/AttackItem.tscn").instance())
#		var attackItem = attacksList.get_children()[attackCount]
#		var pictureLocation
#		var disabled = true
#		var attackName = manaAttackList[attack].name
#		var attackDamage = manaAttackList[attack].hpDamage
#		var manaDamage = manaAttackList[attack].manaDamage
#		var attackCost = manaAttackList[attack].APcost
#		var manaCost = manaAttackList[attack].manaCost
#		if attackCost <= friendlies[CharacterIndex].AP && manaCost <= friendlies[CharacterIndex].mana:
#			if friendlies[CharacterIndex].equipment.items["weapons"]["magic"].size() > 0:
#				if friendlies[CharacterIndex].equipment.items["weapons"]["magic"][0][0].subType in manaAttackList[attack].weaponNeeded || "none" in manaAttackList[attack].weaponNeeded:
#					if friendlies[CharacterIndex].equipment.items["weapons"]["magic"][0][0].levelRequirement >= manaAttackList[attack].itemLevelRequirements:
#						disabled = false
#			if "none" in manaAttackList[attack].weaponNeeded:
#				if friendlies[CharacterIndex].level >= manaAttackList[attack].itemLevelRequirements:
#					disabled = false
#		pictureLocation = attackImages[manaAttackList[attack].image]
#		attackItem.get_node("Description").text = """Attack Name: %s
#HP Damage: %s
#Mana Damage: %s
#AP Cost: %s
#Mana Cost: %s""" % [attackName, attackDamage, manaDamage, attackCost, manaCost]
#		attackItem.get_node("Picture").texture = load(pictureLocation)
#		attackItem.get_node("Use").disabled = disabled
#		attackCount+=1




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
