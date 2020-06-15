extends Node
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

func load_battle(new_battle_name: String, new_background: String, new_friendlies: Array, new_enemies: Array):
	# Switch Scene
	friendlies = new_friendlies
	enemies = new_enemies
	
	# Create Setting
	battle_name = new_battle_name
	background = new_background
	
#	# Initiate the UI
	create_Characters()
	update_attacks(activeCharacterIndex)

func _ready():
	var error = Core.connect("msg", self, "_on_msg")
	if error:
		Core.emit_signal("msg", "Event msg failed to bind", Log.WARN, self)
		print("Warn: Event msg failed to bind")
	
	Core.emit_signal("scene_loaded", self)

func _on_msg(message, level, obj):
	get_node('BattleText').add_text(message + '\n')
	
func create_Characters():
	BattleBoard.show()
	AttackList.hide()
	#Hide all tiles until needed
	for friendPanel in get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").get_children():
		friendPanel.free()
	for enemyPanel in get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children():
		enemyPanel.free()
	## Initiate and unhide needed tiles
	for character in friendlies:
		## Looks
		get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").add_child(load("res://Scenes/Battle/CharacterPanel.tscn").instance())
		var friendPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").get_children()[friendlies.find(character)]
		friendPanel.get_node("VBox/Picture/Pic").texture = load(character.picture.path)
		friendPanel.get_node("VBox/Picture/Pic").flip_h = character.picture.flip_profile[0]
		friendPanel.get_node("VBox/Picture/Pic").flip_v = character.picture.flip_profile[1]
		friendPanel.get_node("VBox/Name").text = character.name
		friendPanel.show()
		if character.picture.border.shown:
			friendPanel.get_node("VBox/Picture/PicBorder").texture = load(character.picture.border.path)
			friendPanel.get_node("VBox/Picture/PicBorder").show()
		else:
			friendPanel.get_node("VBox/Picture/PicBorder").hide()
	for character in enemies:
		##looks
		get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").add_child(load("res://Scenes/Battle/EnemyPanel.tscn").instance())
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()[enemies.find(character)]
		enemyPanel.get_node("VBox/Control/Pic").texture = load(character.picture.path)
		enemyPanel.get_node("VBox/Control/Pic").flip_h = character.picture.flip_profile[0]
		enemyPanel.get_node("VBox/Control/Pic").flip_v = character.picture.flip_profile[1]
		enemyPanel.get_node("VBox/Name").text = character.name
		enemyPanel.show()
		if character.picture.border.shown:
			enemyPanel.get_node("VBox/Control/PicBorder").texture = load(character.picture.border.path)
			enemyPanel.get_node("VBox/Control/PicBorder").show()
		else:
			enemyPanel.get_node("VBox/Control/PicBorder").hide()
	update_Characters()
func update_Characters():
	##update stats
	for character in friendlies:
		##looks
		var friendPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").get_children()[friendlies.find(character)]
		##stats
		friendPanel.get_node("VBox/Health/HealthBar").value = character.health.current*100/(character.health.max)
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
			friendPanel.get_node("VBox/Picture/Blood").show()
	for character in enemies:
		##looks
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()[enemies.find(character)]
		##stats
		enemyPanel.get_node("VBox/Health/HealthBar").value = character.health.current*100/character.health.max
		enemyPanel.get_node("VBox/Health/HealthText").text = "Health: %d/%d" % [character.health.current, character.health.max]
		enemyPanel.get_node("VBox/HealthAndMana/Health/HealthBar").value = character.health.current*100/character.health.max
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
			enemyPanel.get_node("VBox/Control/Blood").show()

func update_attacks(CharacterIndex):
	var attacksList = get_node("TopScreen/DisplayArea/AttackBoard/AttackScrollBar/AttacksList")
	for attack in attacksList.get_children():
		attack.free()
	##Add character attacks
	var attackCount = 0
	for attack in friendlies[CharacterIndex].attacks["melee"]:
		attacksList.add_child(load("res://Scenes/Battle/AttackItem.tscn").instance())
		var attackItem = attacksList.get_children()[attackCount]
		var pictureLocation
		var disabled = true
		var attackName = Attacks.melee[attack].name
		var attackDamage = Attacks.melee[attack].hpDamage
		var attackCost = Attacks.melee[attack].APcost
		pictureLocation = Attacks.melee[attack].image
		attackItem.get_node("Description").text = """Attack Name: %s
HP Damage: %s
AP Cost: %s""" % [attackName, attackDamage, attackCost]
		if attackCost <= friendlies[CharacterIndex].AP.current:
			if friendlies[CharacterIndex].equipment["weapons"]["melee"] > 0:
				if friendlies[CharacterIndex].inventory[friendlies[CharacterIndex].equipment["weapons"]["melee"]].subType in Attacks.melee[attack].weaponNeeded:
					if friendlies[CharacterIndex].inventory[friendlies[CharacterIndex].equipment["weapons"]["melee"]].levelRequirement >= Attacks.melee[attack]["itemLevelRequirements"]:
						disabled = false
			if "none" in Attacks.melee[attack].weaponNeeded:
				if friendlies[CharacterIndex].level >= Attacks.melee[attack]["itemLevelRequirements"]:
					disabled = false
		attackItem.get_node("Picture").texture = load(pictureLocation)
		attackItem.get_node("Use").disabled = disabled
		attackCount+=1
	for attack in friendlies[CharacterIndex].attacks["ranged"]:
		attacksList.add_child(load("res://Scenes/Battle/AttackItem.tscn").instance())
		var attackItem = attacksList.get_children()[attackCount]
		var pictureLocation
		var disabled = true
		var attackName = Attacks.ranged[attack].name
		var attackDamage = Attacks.ranged[attack].hpDamage
		var attackCost = Attacks.ranged[attack].APcost
		var ammoCost = Attacks.ranged[attack].ammoCost
		pictureLocation = Attacks.ranged[attack].image
		attackItem.get_node("Description").text = """Attack Name: %s
HP Damage: %s
AP Cost: %s
Ammo Cost: %s""" % [attackName, attackDamage, attackCost, ammoCost]
		if attackCost <= friendlies[CharacterIndex].AP.current:
			if friendlies[CharacterIndex].equipment["weapons"]["ranged"] > 0:
				if friendlies[CharacterIndex].inventory[friendlies[CharacterIndex].equipment["weapons"]["ranged"]].subType in Attacks.ranged[attack].weaponNeeded[0]:
					if friendlies[CharacterIndex].inventory[friendlies[CharacterIndex].equipment["weapons"]["ranged"]].levelRequirement >= Attacks.ranged[attack]["itemLevelRequirements"]:
						for ammo in friendlies[CharacterIndex].inventory["weapons"]["consumables"]:
							if ammo.quantity >= Attacks.ranged[attack].ammoCost:
								if ammo.subType in Attacks.ranged[attack].weaponNeeded[1] && ammo.levelRequirement >=  Attacks.ranged[attack]["itemLevelRequirements"]:
									disabled = false
			if "none" == Attacks.ranged[attack].weaponNeeded[0][0]:
				if friendlies[CharacterIndex].level >= Attacks.ranged[attack]["itemLevelRequirements"]:
					for ammo in friendlies[CharacterIndex].inventory["weapons"]["consumables"]:
						if ammo.subType in Attacks.ranged[attack].weaponNeeded[1]:
							if ammo.quantity >= Attacks.ranged[attack].ammoCost && ammo.levelRequirement >=  Attacks.ranged[attack]["itemLevelRequirements"]:
								disabled = false
						else:
							disabled = false
		attackItem.get_node("Picture").texture = load(pictureLocation)
		attackItem.get_node("Use").disabled = disabled
		attackCount+=1
	for attack in friendlies[CharacterIndex].attacks["mana"]:
		attacksList.add_child(load("res://Scenes/Battle/AttackItem.tscn").instance())
		var attackItem = attacksList.get_children()[attackCount]
		var pictureLocation
		var disabled = true
		var attackName = Attacks.mana[attack].name
		var attackDamage = Attacks.mana[attack].hpDamage
		var manaDamage = Attacks.mana[attack].manaDamage
		var attackCost = Attacks.mana[attack].APcost
		var manaCost = Attacks.mana[attack].manaCost
		if attackCost <= friendlies[CharacterIndex].AP.current && manaCost <= friendlies[CharacterIndex].mana.current:
			if friendlies[CharacterIndex].equipment["weapons"]["magic"] > 0:
				if friendlies[CharacterIndex].inventory[friendlies[CharacterIndex].equipment["weapons"]["magic"]].subType in Attacks.mana[attack].weaponNeeded || "none" in Attacks.mana[attack].weaponNeeded:
					if friendlies[CharacterIndex].inventory[friendlies[CharacterIndex].equipment["weapons"]["magic"]].levelRequirement >= Attacks.mana[attack].itemLevelRequirements:
						disabled = false
			if "none" in Attacks.mana[attack].weaponNeeded:
				if friendlies[CharacterIndex].level >= Attacks.mana[attack].itemLevelRequirements:
					disabled = false
		pictureLocation = Attacks.mana[attack].image
		attackItem.get_node("Description").text = """Attack Name: %s
HP Damage: %s
Mana Damage: %s
AP Cost: %s
Mana Cost: %s""" % [attackName, attackDamage, manaDamage, attackCost, manaCost]
		attackItem.get_node("Picture").texture = load(pictureLocation)
		attackItem.get_node("Use").disabled = disabled
		attackCount+=1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Attack_pressed():
	BattleBoard.hide()
	AttackList.show()
	enemies[0].health.current-=10
	update_attacks(activeCharacterIndex)
	Core.emit_signal('msg', 'You dealt ' + str(10) + ' damage!', Log.INFO, self)

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
			Core.emit_signal('msg', 'An friend has died!', Log.INFO, self)
			friendPanel.get_node("VBox/Picture/Blood").show()
	for character in enemies:
		# looks
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()[enemies.find(character)]
		# stats
		enemyPanel.get_node("VBox/Health/HealthBar").value = character.health.current*100/character.health.max
		enemyPanel.get_node("VBox/Health/HealthText").text = "Health: %d/%d" % [character.health.current, character.health.max]
		enemyPanel.get_node("VBox/HealthAndMana/Health/HealthBar").value = character.health.current*100/character.health.max
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
			Core.emit_signal('msg', 'An enemy has died!', Log.INFO, self)
			enemyPanel.get_node("VBox/Control/Blood").show()
