extends Node
const script_name := "battle"

onready var BattleBoard := $"DisplayArea/BattleBoard/"
onready var AttackList := $"DisplayArea/AttackBoard/"
onready var friendlies := []
onready var activeCharacterIndex := -1
onready var nextCharacterIndex := []
onready var enemies := []
onready var gameOver := false
onready var winner := "noone"

var battle_name setget set_battle_name, get_battle_name
var background setget set_background, get_background

func set_battle_name(value: String):
	get_node("TopScreen/Name").text = value

func get_battle_name():
	return get_node("TopScreen/Name").text

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
	for friendPanel in get_node("DisplayArea/BattleBoard/Combat/Characters/AllFriendlies").get_children():
		friendPanel.free()
	for enemyPanel in get_node("DisplayArea/BattleBoard/Combat/Characters/AllEnemies").get_children():
		enemyPanel.free()
	## Initiate and unhide needed tiles
	for character in friendlies:
		## Looks
		get_node("DisplayArea/BattleBoard/Combat/Characters/AllFriendlies").add_child(load("res://Scenes/Battle/CharacterPanel.tscn").instance())
		var friendPanel = get_node("DisplayArea/BattleBoard/Combat/Characters/AllFriendlies").get_children()[friendlies.find(character)]
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
		get_node("DisplayArea/BattleBoard/Combat/Characters/AllEnemies").add_child(load("res://Scenes/Battle/EnemyPanel.tscn").instance())
		var enemyPanel = get_node("DisplayArea/BattleBoard/Combat/Characters/AllEnemies").get_children()[enemies.find(character)]
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
		var friendPanel = get_node("DisplayArea/BattleBoard/Combat/Characters/AllFriendlies").get_children()[friendlies.find(character)]
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
		var enemyPanel = get_node("DisplayArea/BattleBoard/Combat/Characters/AllEnemies").get_children()[enemies.find(character)]
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
	if enemies.size() > 4:
		get_node("DisplayArea/BattleBoard/Combat/Characters/AllEnemies").add_constant_override("hseparation", 84)
	else:
		get_node("DisplayArea/BattleBoard/Combat/Characters/AllEnemies").add_constant_override("hseparation", 104)
	update_turn()

func update_turn():
	# Delete all tiles until needed
	var turns = get_node("DisplayArea/BattleBoard/TurnSystem/ScrollContainer2/NextTurns")
	for turnPanel in turns.get_children():
		turnPanel.free()
	if !gameOver:
		if activeCharacterIndex != -1:
			turns.add_child(load("res://Scenes/Battle/NextProfile.tscn").instance())
			var turnPanel = turns.get_children()[0]
			turnPanel.get_node("HBox/Picture/Pic").texture = load(friendlies[activeCharacterIndex].picture.path)
			turnPanel.get_node("HBox/Picture/Pic").flip_h = friendlies[activeCharacterIndex].picture.flip_profile[0]
			turnPanel.get_node("HBox/Picture/Pic").flip_v = friendlies[activeCharacterIndex].picture.flip_profile[1]
			turnPanel.get_node("Name").text = friendlies[activeCharacterIndex].name
			if !friendlies[activeCharacterIndex].picture.border.shown:
				turnPanel.get_node("HBox/Picture/PicBorder").hide()
			else:
				turnPanel.get_node("HBox/Picture/PicBorder").show()
				turnPanel.get_node("HBox/Picture/PicBorder").texture = load(friendlies[activeCharacterIndex].picture.border.path)
			turnPanel.resizeName()
		for turn in nextCharacterIndex:
			turns.add_child(load("res://Scenes/Battle/NextProfile.tscn").instance())
			var turnPanel = turns.get_children()[turns.get_children().size()-1]
			if turn[0] == "Friendly":
				turnPanel.get_node("HBox/Picture/Pic").texture = load(friendlies[turn[1]].picture.path)
				turnPanel.get_node("HBox/Picture/Pic").flip_h = friendlies[turn[1]].picture.flip_profile[0]
				turnPanel.get_node("HBox/Picture/Pic").flip_v = friendlies[turn[1]].picture.flip_profile[1]
				turnPanel.get_node("Name").text = friendlies[turn[1]].name
				if !friendlies[turn[1]].picture.border.shown:
					turnPanel.get_node("HBox/Picture/PicBorder").hide()
				else:
					turnPanel.get_node("HBox/Picture/PicBorder").show()
					turnPanel.get_node("HBox/Picture/PicBorder").texture = load(friendlies[turn[1]].picture.border.path)
				turnPanel.resizeName()
			else:
				turnPanel.get_node("HBox/Picture/Pic").texture = load(enemies[turn[1]].picture.path)
				turnPanel.get_node("HBox/Picture/Pic").flip_h = enemies[turn[1]].picture.flip_profile[0]
				turnPanel.get_node("HBox/Picture/Pic").flip_v = enemies[turn[1]].picture.flip_profile[1]
				turnPanel.get_node("Name").text = enemies[turn[1]].name
				if !enemies[turn[1]].picture.border.shown:
					turnPanel.get_node("HBox/Picture/PicBorder").hide()
				else:
					turnPanel.get_node("HBox/Picture/PicBorder").show()
					turnPanel.get_node("HBox/Picture/PicBorder").texture = load(enemies[turn[1]].picture.border.path)
				turnPanel.resizeName()

func _on_Attack_pressed():
	BattleBoard.hide()
	update_attacks(activeCharacterIndex, "attack")
	AttackList.show()

func attackButton(attack, attackType):
	if friendlies[activeCharacterIndex].health.current > 0:
		for character in enemies:
			while character.health.current > 0  && friendlies[activeCharacterIndex].AP.current >= attack.APcost:
				attackCharacter(friendlies[activeCharacterIndex], [character], attack, attackType)
			if friendlies[activeCharacterIndex].AP.current < attack.APcost:
				break
	if attack.targetEnemy:
		update_attacks(activeCharacterIndex, "attack", false)
	else:
		update_attacks(activeCharacterIndex, "abilities", false)

func _on_Abilities_pressed():
	BattleBoard.hide()
	update_attacks(activeCharacterIndex, "abilities")
	AttackList.show()
	
func update_attacks(CharacterIndex: int, mode: String, create=true):
	#character index variable should be replaced with activeCharacterIndex global variable
	var attacksList = get_node("DisplayArea/AttackBoard/AttackScrollBar/AttacksList")
	if create:
		for attack in attacksList.get_children():
			attack.free()
	##Add character attacks
	var attackCount = 0
	for attack in friendlies[CharacterIndex].attacks.melee:
		attack = Attacks.melee[attack]
		if (mode == "attack" && attack.targetEnemy) || (mode == "abilities" && !attack.targetEnemy):
			if create:
				attacksList.add_child(load("res://Scenes/Battle/AttackItem.tscn").instance())
			var attackItem = attacksList.get_children()[attackCount]
			var pictureLocation
			var attackName = attack.name
			var attackDamage = attack.hpDamage
			var attackCost = attack.APcost
			var check = checkAttack(friendlies[CharacterIndex], attack, "melee")
			var disabled = !check[0]
			var hint = check[1]
			pictureLocation = attack.image
			if mode == "attack":
				attackItem.get_node("Description").text = """Attack Name: %s
	HP Damage: %s
	AP Cost: %s""" % [attackName, attackDamage, attackCost]
			if mode == "abilities":
				attackItem.get_node("Description").text = """Ability Name: %s
	Heal Amount: %s
	AP Cost: %s""" % [attackName, -attackDamage, attackCost]
			attackItem.get_node("Picture").texture = load(pictureLocation)
			attackItem.get_node("Use").disabled = disabled
			attackItem.get_node("Use").hint_tooltip = hint
			attackItem.get_node("Use").connect("pressed", self, "attackButton", [ attack, "melee" ])
			attackCount+=1
	for attack in friendlies[CharacterIndex].attacks.ranged:
		attack = Attacks.ranged[attack]
		if (mode == "attack" && attack.targetEnemy) || (mode == "abilities" && !attack.targetEnemy):
			if create:
				attacksList.add_child(load("res://Scenes/Battle/AttackItem.tscn").instance())
			var attackItem = attacksList.get_children()[attackCount]
			var pictureLocation
			var attackName = attack.name
			var attackDamage = attack.hpDamage
			var attackCost = attack.APcost
			var ammoCost = attack.ammoCost
			var check = checkAttack(friendlies[CharacterIndex], attack, "ranged")
			var disabled = !check[0]
			var hint = check[1]
			pictureLocation = attack.image
			if mode == "attack":
				attackItem.get_node("Description").text = """Attack Name: %s
	HP Damage: %s
	AP Cost: %s
	Ammo Cost: %s""" % [attackName, attackDamage, attackCost, ammoCost]
			if mode == "abilities":
				attackItem.get_node("Description").text = """Ability Name: %s
	Heal Amount: %s
	AP Cost: %s
	Ammo Cost: %s""" % [attackName, attackDamage, attackCost, ammoCost]
			attackItem.get_node("Picture").texture = load(pictureLocation)
			attackItem.get_node("Use").disabled = disabled
			attackItem.get_node("Use").hint_tooltip = hint
			attackItem.get_node("Use").connect("pressed", self, "attackButton", [ attack, "ranged" ])
			attackCount+=1
	for attack in friendlies[CharacterIndex].attacks.mana:
		attack = Attacks.mana[attack]
		if (mode == "attack" && attack.targetEnemy) || (mode == "abilities" && !attack.targetEnemy):
			if create:
				attacksList.add_child(load("res://Scenes/Battle/AttackItem.tscn").instance())
			var attackItem = attacksList.get_children()[attackCount]
			var pictureLocation
			var attackName = attack.name
			var attackDamage = attack.hpDamage
			var manaDamage = attack.manaDamage
			var attackCost = attack.APcost
			var manaCost = attack.manaCost
			var check = checkAttack(friendlies[CharacterIndex], attack, "mana")
			var disabled = !check[0]
			var hint = check[1]
			pictureLocation = attack.image
			if mode == "attack":
				attackItem.get_node("Description").text = """Attack Name: %s
	HP Damage: %s
	Mana Damage: %s
	AP Cost: %s
	Mana Cost: %s""" % [attackName, attackDamage, manaDamage, attackCost, manaCost]
			if mode == "abilities":
				attackItem.get_node("Description").text = """Ability Name: %s
	Heal Amount: %s
	Mana Regen: %s
	AP Cost: %s
	Mana Cost: %s""" % [attackName, -attackDamage, -manaDamage, attackCost, manaCost]
			attackItem.get_node("Picture").texture = load(pictureLocation)
			attackItem.get_node("Use").disabled = disabled
			attackItem.get_node("Use").hint_tooltip = hint
			attackItem.get_node("Use").connect("pressed", self, "attackButton", [ attack, "mana" ])
			attackCount+=1

func checkAttack(attacker: Dictionary, attack: Dictionary, attackType:String):
	var valid = false
	var attackName = attack.name
	var attackDamage = attack.hpDamage
	var attackCost = attack.APcost
	var hint = ""
	if attackType == "melee":
		if attackCost <= attacker.AP.current:
			if attacker.equipment.weapons.melee != -1:
				if attacker.inventory.weapons.melee[attacker.equipment.weapons.melee].subType in attack.weaponNeeded:
					if attacker.inventory.weapons.melee[attacker.equipment.weapons.melee].levelRequirement >= attack.itemLevelRequirements:
						valid = true
					else:
						hint = "Weapon level too low"
				else:
					hint = "Wrong weapon type equipped"
			if "none" in attack.weaponNeeded:
				if attacker.level >= attack.itemLevelRequirements:
					valid = true
				else:
					hint = "Character level too low"
		else:
			hint = "Character AP too low"
	if attackType == "ranged":
		var ammoCost = attack.ammoCost
		if attackCost <= attacker.AP.current:
			if attacker.equipment.weapons.ranged != -1:
				if attacker.inventory.weapons.ranged[attacker.equipment.weapons.ranged].subType in attack.weaponNeeded[0]:
					if attacker.inventory.weapons.ranged[attacker.equipment.weapons.ranged].levelRequirement >= attack.itemLevelRequirements:
						valid = true
						# for now
					else:
						hint = "Weapon level too low"
				else:
					hint = "Wrong weapon type equipped"
			if "none" == attack.weaponNeeded[0][0]:
				if attacker.level >= attack.itemLevelRequirements:
					valid = true
					# for now
				else:
					hint = "Character level too low"
			if valid:
				for ammo in attacker.inventory.weapons.consumables:
					if ammo.subType in attack.weaponNeeded[1]:
						if ammo.levelRequirement >= attack.itemLevelRequirements:
							if ammo.quantity >= attack.ammoCost:
								valid = true
								hint = ""
								break
							else:
								hint = "Not enough arrows available"
						else:
							if hint !=  "Not enough arrows available":
								hint = "Arrow level too low"
					else:
						if hint !=  "Not enough arrows available" && hint !=  "Arrow level too low":
							hint = "No arrows available"
		else:
			hint = "Character AP too low"
	if attackType == "mana":
		var manaDamage = attack.manaDamage
		var manaCost = attack.manaCost
		if attackCost <= attacker.AP.current:
			if manaCost <= attacker.mana.current:
				if attacker.equipment.weapons.magic != -1:
					if attacker.inventory.weapons.magic[attacker.equipment.weapons.magic].subType in attack.weaponNeeded:
						if attacker.inventory.weapons.magic[attacker.equipment.weapons.magic].levelRequirement >= attack.itemLevelRequirements:
							valid = true
						else:
							hint = "Weapon level too low"
					else:
						hint = "Wrong weapon type equipped"
				if "none" in attack.weaponNeeded:
					if attacker.level >= attack.itemLevelRequirements:
						valid = true
					else:
						hint = "Character level too low"
			else:
				hint = "Character mana too low"
		else:
			hint = "Character AP too low"
	return [valid, hint]
	
func attackCharacter(attacker: Dictionary, otherCharacters: Array, attack: Dictionary, attackType:String):
	var attacked = false
	if checkAttack(attacker, attack, attackType)[0] == true:
		if attack.targetEnemy:
			# attack enemy
			if attacker.AP.current >= attack.APcost:
				Core.emit_signal('msg', attacker.name + ' uses ' + attack.name + '!', Log.INFO, self)
				for otherCharacter in otherCharacters:
					otherCharacter.health.current-=attack.hpDamage
					if otherCharacter.health.current < 0:
						otherCharacter.health.current=0
					if otherCharacter.health.current > 0:
						Core.emit_signal('msg', '    -' + otherCharacter.name + ' takes ' + str(attack.hpDamage) + ' HP damage!', Log.INFO, self)
					else:
						Core.emit_signal('msg', '    -' + otherCharacter.name + ' has died!', Log.INFO, self)
					attacker.AP.current -=attack.APcost
					if attackType == "mana":
						attacker.mana.current-=attack.manaCost
						otherCharacter.mana.current-=attack.manaDamage
						if otherCharacter.mana.current < 0:
							otherCharacter.mana.current=0
					attacked = true
		else:
			# heal friendly
			if attacker.AP.current >= attack.APcost:
				Core.emit_signal('msg', attacker.name + ' uses ' + attack.name + '!', Log.INFO, self)
				for otherCharacter in otherCharacters:
					otherCharacter.health.current -= attack.hpDamage
					if otherCharacter.health.current > otherCharacter.health.max:
						otherCharacter.health.current = otherCharacter.health.current
					Core.emit_signal('msg', '    -' + otherCharacter.name + ' is healed by ' + str(attack.hpDamage) + ' HP', Log.INFO, self)
					attacker.AP.current -=attack.APcost
					if attackType == "mana":
						attacker.mana.current-=attack.manaCost
						otherCharacter.mana.current-=attack.manaDamage
					attacked = true
		if attackType == "ranged" && attacked:
			var ammoChoice = []
			for ammo in attacker.inventory.weapons.consumables:
				###need to add selection if there are multiple
				if ammo.subType in attack.weaponNeeded[1]:
					if ammo.levelRequirement >= attack.itemLevelRequirements:
						if ammo.quantity >= attack.ammoCost:
							ammoChoice.append(ammo)
			if ammoChoice.size() > 0:
				InventoryManager.remove(attacker.inventory, ammoChoice[0], attack.ammoCost)
	return attacked

func _process(delta):
	# Check if someone won
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
		if maxEnemies == 0:
			gameOver = true
			winner = "friendlies"
		if gameOver:
			activeCharacterIndex = -1
			gameEnded()
	# AI Attack
	if nextCharacterIndex.size() > 0 && activeCharacterIndex == -1 && !gameOver:
		if nextCharacterIndex[0][0] == "Friendly":
			var character = friendlies[nextCharacterIndex[0][1]]
			get_node("DisplayArea/BattleBoard/TurnSystem/CurrentCharacter").text = "Current Turn: "+ character.name
			if character.health.current > 0:
				if character.classType != "PLAYER":
					var attacked = false
					for attackType in character.attacks:
						if attackType != "lowestCost":
							for attackName in character.attacks[attackType]:
								var attack = Attacks[attackType][attackName]
								if character.AP.current >= attack.APcost:
									for otherCharacter in enemies:
										while otherCharacter.health.current > 0 && character.AP.current >= attack.APcost:
											if attackCharacter(character, [otherCharacter], attack, attackType) == true:
												attacked = true
										if character.AP.current < attack.APcost:
											break
							if attacked:
								break
				else:
					activeCharacterIndex = nextCharacterIndex[0][1]
		else:
			var character = enemies[nextCharacterIndex[0][1]]
			get_node("DisplayArea/BattleBoard/TurnSystem/CurrentCharacter").text = "Current Turn: "+ character.name
			if character.health.current > 0:
				var attacked = false
				for attackType in character.attacks:
					if attackType != "lowestCost":
						for attackName in character.attacks[attackType]:
							var attack = Attacks[attackType][attackName]
							if character.AP.current >= attack.APcost:
								for otherCharacter in friendlies:
									while otherCharacter.health.current > 0 && character.AP.current >= attack.APcost:
										if attackCharacter(character, [otherCharacter], attack, attackType) == true:
											attacked = true
									if character.AP.current < attack.APcost:
										break
						if attacked:
							break
		nextCharacterIndex.remove(0)
		update_Characters()
	# Increase characters AP intil a move is ready
	if nextCharacterIndex.size() == 0 && activeCharacterIndex == -1 && !gameOver:
		for character in friendlies:
			if character.health.current > 0:
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
		for character in enemies:
			if character.health.current > 0:
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

func _on_Items_pressed():
	BattleBoard.hide()
	AttackList.hide()

func _on_Retreat_pressed():
	#####not final
	Core.get_parent().add_child(load("res://Scenes/CharacterSelection/CharacterSelection.tscn").instance())
	queue_free()
	
func _on_EndTurn_pressed():
	BattleBoard.show()
	AttackList.hide()
	activeCharacterIndex = -1
	
func _on_BackButton_pressed():
	BattleBoard.show()
	AttackList.hide()
	update_Characters()

func gameEnded():
	get_node("DisplayArea/BattleBoard/TurnSystem/CurrentCharacter").text = "Game Over!"
	Core.emit_signal('msg', 'Game Over!', Log.INFO, self)
