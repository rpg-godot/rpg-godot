extends Node
const script_name := "battle"

onready var BattleBoard := $"TopScreen/DisplayArea/BattleBoard/"
onready var AttackList := $"TopScreen/DisplayArea/AttackBoard/"
onready var friendlies := []
onready var activeCharacterIndex := -1
onready var nextCharacterIndex := []
onready var enemies := []
onready var gameOver := false
onready var winner := "noone"

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
	#update_attacks(activeCharacterIndex)

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
	# Delete all tiles until needed
	for friendPanel in get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllFriendlies").get_children():
		friendPanel.free()
	for enemyPanel in get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllEnemies").get_children():
		enemyPanel.free()
	## Initiate and unhide needed tiles
	for character in friendlies:
		## Looks
		get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllFriendlies").add_child(load("res://Scenes/Battle/CharacterPanel.tscn").instance())
		var friendPanel = get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllFriendlies").get_children()[friendlies.find(character)]
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
		get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllEnemies").add_child(load("res://Scenes/Battle/EnemyPanel.tscn").instance())
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllEnemies").get_children()[enemies.find(character)]
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
		var friendPanel = get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllFriendlies").get_children()[friendlies.find(character)]
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
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllEnemies").get_children()[enemies.find(character)]
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
	print (enemies.size())
	if enemies.size() > 4:
		get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllEnemies").add_constant_override("hseparation", 42)
	else:
		get_node("TopScreen/DisplayArea/BattleBoard/Combat/Characters/AllEnemies").add_constant_override("hseparation", 57)
	update_turn()

func update_turn():
	# Delete all tiles until needed
	var turns = get_node("TopScreen/DisplayArea/BattleBoard/TurnSystem/ScrollContainer2/NextTurns")
	for turnPanel in turns.get_children():
		turnPanel.free()
	if activeCharacterIndex != -1:
		turns.add_child(load("res://Scenes/Battle/NextProfile.tscn").instance())
		var turnPanel = turns.get_children()[0]
		print (friendlies[activeCharacterIndex].picture.path)
		turnPanel.get_node("VBox/Picture/Pic").texture = load(friendlies[activeCharacterIndex].picture.path)
		turnPanel.get_node("VBox/Picture/Pic").flip_h = friendlies[activeCharacterIndex].picture.flip_profile[0]
		turnPanel.get_node("VBox/Picture/Pic").flip_v = friendlies[activeCharacterIndex].picture.flip_profile[1]
		turnPanel.get_node("VBox/Name").text = friendlies[activeCharacterIndex].name
		if !friendlies[activeCharacterIndex].picture.border.shown:
			turnPanel.get_node("VBox/Picture/PicBorder").hide()
		else:
			turnPanel.get_node("VBox/Picture/PicBorder").show()
			turnPanel.get_node("VBox/Picture/PicBorder").texture = load(friendlies[activeCharacterIndex].picture.border.path)
	print (nextCharacterIndex)
	for turn in nextCharacterIndex:
		turns.add_child(load("res://Scenes/Battle/NextProfile.tscn").instance())
		var turnPanel = turns.get_children()[turns.get_children().size()-1]
		if turn[0] == "Friendly":
			turnPanel.get_node("VBox/Picture/Pic").texture = load(friendlies[turn[1]].picture.path)
			turnPanel.get_node("VBox/Picture/Pic").flip_h = friendlies[turn[1]].picture.flip_profile[0]
			turnPanel.get_node("VBox/Picture/Pic").flip_v = friendlies[turn[1]].picture.flip_profile[1]
			turnPanel.get_node("VBox/Name").text = friendlies[turn[1]].name
			if !friendlies[turn[1]].picture.border.shown:
				turnPanel.get_node("VBox/Picture/PicBorder").hide()
			else:
				turnPanel.get_node("VBox/Picture/PicBorder").show()
				turnPanel.get_node("VBox/Picture/PicBorder").texture = load(friendlies[turn[1]].picture.border.path)
		else:
			turnPanel.get_node("VBox/Picture/Pic").texture = load(enemies[turn[1]].picture.path)
			turnPanel.get_node("VBox/Picture/Pic").flip_h = enemies[turn[1]].picture.flip_profile[0]
			turnPanel.get_node("VBox/Picture/Pic").flip_v = enemies[turn[1]].picture.flip_profile[1]
			turnPanel.get_node("VBox/Name").text = enemies[turn[1]].name
			if !enemies[turn[1]].picture.border.shown:
				turnPanel.get_node("VBox/Picture/PicBorder").hide()
			else:
				turnPanel.get_node("VBox/Picture/PicBorder").show()
				turnPanel.get_node("VBox/Picture/PicBorder").texture = load(enemies[turn[1]].picture.border.path)

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
func _process(delta):
	# Check if someone one
	if !gameOver:
		var maxFriendlies = 0
		var maxEnemies = 0
		for character in friendlies:
			if character.health.current > maxFriendlies:
				maxFriendlies = character.health.current
		for character in enemies:
			if character.health.current > maxEnemies:
				maxEnemies = character.health.current
		if maxFriendlies == 0:
			gameOver = true
			winner = "enemies"
		if maxFriendlies == 0:
			gameOver = true
			winner = "friendlies"
		if gameOver:
			gameEnded()
	# AI Attack
	if nextCharacterIndex.size() > 0 && activeCharacterIndex == -1 && !gameOver:
		print (nextCharacterIndex)
		if nextCharacterIndex[0][0] == "Friendly":
			var character = friendlies[nextCharacterIndex[0][1]]
			get_node("TopScreen/DisplayArea/BattleBoard/TurnSystem/CurrentCharacter").text = "Current Turn: "+ character.name
			if character.health.current > 0:
				if character.classType != "PLAYER":
					var attacked = false
					for attackType in character.attacks:
						for attackName in character.attacks[attackType]:
							var attack = Attacks[attackType][attackName]
							if character.AP.current >= attack.APcost:
								for otherCharacter in enemies:
									if otherCharacter.health.current > 0:
										otherCharacter.health.current-=attack.hpDamage
										if otherCharacter.health.current < 0:
											otherCharacter.health.current=0
										if otherCharacter.health.current > 0:
											Core.emit_signal('msg', character.name + ' uses ' + attack.name + ' for ' + str(attack.hpDamage) + ' HP damage against ' + otherCharacter.name + '!', Log.INFO, self)
										else:
											Core.emit_signal('msg', character.name + ' uses ' + attack.name + ' to kill ' + otherCharacter.name + '!', Log.INFO, self)
										character.AP.current -=attack.APcost
										attacked = true
										break
						if attacked:
							break
				else:
					activeCharacterIndex = nextCharacterIndex[0][1]
		else:
			var character = enemies[nextCharacterIndex[0][1]]
			get_node("TopScreen/DisplayArea/BattleBoard/TurnSystem/CurrentCharacter").text = "Current Turn: "+ character.name
			if character.health.current > 0:
				var attacked = false
				for attackType in character.attacks:
					for attackName in character.attacks[attackType]:
						var attack = Attacks[attackType][attackName]
						if character.AP.current >= attack.APcost:
							for otherCharacter in friendlies:
								if otherCharacter.health.current > 0:
									otherCharacter.health.current-=attack.hpDamage
									if otherCharacter.health.current < 0:
										otherCharacter.health.current=0
									if otherCharacter.health.current > 0:
										Core.emit_signal('msg', character.name + ' uses ' + attack.name + ' for ' + str(attack.hpDamage) + ' HP damage against ' + otherCharacter.name + '!', Log.INFO, self)
									else:
										Core.emit_signal('msg', character.name + ' uses ' + attack.name + ' to kill ' + otherCharacter.name + '!', Log.INFO, self)
									character.AP.current -=attack.APcost
									attacked = true
									break
					if attacked:
						break
		nextCharacterIndex.remove(0)
		update_Characters()
	# Increase characters AP intil a move is ready
	if nextCharacterIndex.size() == 0 && activeCharacterIndex == -1 && !gameOver:
		print("new Turn")
		for character in friendlies:
			if character.health.current > 0:
				print(character.name)
				print(character.AP.current)
				character.AP.current += character.AP.speed
				if character.AP.current > character.AP.max:
					character.AP.current = character.AP.max
				character.mana.current += character.mana.speed
				if character.mana.current > character.mana.max:
					character.mana.current = character.mana.max
				character.health.current += character.health.speed
				if character.health.current > character.health.max:
					character.health.current = character.health.max
				if character.AP.current >= character.attacks.lowestCost:
					nextCharacterIndex.append(["Friendly", friendlies.find(character)])
				print(character.AP.current)
		for character in enemies:
			if character.health.current > 0:
				print(character.name)
				print(character.AP.current)
				character.AP.current += character.AP.speed
				if character.AP.current > character.AP.max:
					character.AP.current = character.AP.max
				character.mana.current += character.mana.speed
				if character.mana.current > character.mana.max:
					character.mana.current = character.mana.max
				character.health.current += character.health.speed
				if character.health.current > character.health.max:
					character.health.current = character.health.max
				if character.AP.current >= character.attacks.lowestCost:
						nextCharacterIndex.append(["Enemy", enemies.find(character)])
				print(character.AP.current)
			
		

func _on_Attack_pressed():
	BattleBoard.hide()
	AttackList.show()
	for character in enemies:
		if character.health.current > 0:
			character.health.current-=10
			if character.health.current < 0:
				character.health.current=0
			if character.health.current > 0:
				Core.emit_signal('msg', friendlies[activeCharacterIndex].name + ' dealt ' + str(10) + ' HP damage against ' + character.name + '!', Log.INFO, self)
			else:
				Core.emit_signal('msg', friendlies[activeCharacterIndex].name + ' kills ' + character.name + '!', Log.INFO, self)
			friendlies[activeCharacterIndex].AP.current -=1
			break
	update_attacks(activeCharacterIndex)
	activeCharacterIndex = -1

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
	update_Characters()

func gameEnded():
	get_node("TopScreen/DisplayArea/BattleBoard/TurnSystem/CurrentCharacter").text = "Game Over!"
	Core.emit_signal('msg', 'Game Over!', Log.INFO, self)
