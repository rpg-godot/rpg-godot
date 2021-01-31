extends Node
const script_name := "battle"

onready var BattleBoard := $"DisplayArea/BattleBoard/"
onready var AttackList := $"DisplayArea/AttackBoard/"
onready var TargetList := $"DisplayArea/TargetSelection/"
onready var friendlies := []
onready var activeCharacterIndex := -1
onready var nextCharacterIndex := []
onready var enemies := []
onready var gameOver := false
onready var winner := "noone"
onready var charactersThatMoved := []
onready var processing := false
onready var activeAttackMode := ""
onready var activeAttackType := ""
onready var attacksLeft = 0
onready var attackTargets = []
onready var activeAttack = {}
onready var activeAttackRessurection = false

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
	
	for character in friendlies:
		character.AP.turnCount = 0
		character.AP.ticks = 0
	for character in enemies:
		character.AP.turnCount = 0
		character.AP.ticks = 0
	
	
	#update_attacks(activeCharacterIndex)

func _ready():
	var error = Core.connect("msg", self, "_on_msg")
	if error:
		Core.emit_signal("msg", "Event msg failed to bind", Log.WARN, self)
		print("Warn: Event msg failed to bind")
	
	Core.emit_signal("scene_loaded", self)
	BattleBoard.show()
	AttackList.hide()
	TargetList.hide()

func _on_msg(message, level, obj):
	if level == Log.BATTLE:
		get_node('BattleText').add_text(message + '\n')
	
func create_Characters():
	for board in [BattleBoard, TargetList]:
		# Delete all tiles until needed
		for characterPanel in board.get_node("Combat/Characters/AllFriendlies").get_children():
			characterPanel.free()
		for characterPanel in board.get_node("Combat/Characters/AllEnemies").get_children():
			characterPanel.free()
		## Initiate and unhide needed tiles
		for characterType in [friendlies, enemies]:
			for character in characterType:
				## Looks
				var characterPanel
				if characterType == friendlies:
					board.get_node("Combat/Characters/AllFriendlies").add_child(load("res://Scenes/Battle/CharacterPanel.tscn").instance())
					characterPanel = board.get_node("Combat/Characters/AllFriendlies").get_children()[friendlies.find(character)]
					characterPanel.index = friendlies.find(character)
					characterPanel.get_node("VBox/Health").hide()
					characterPanel.get_node("VBox/HealthAndMana").show()
				else:
					board.get_node("Combat/Characters/AllEnemies").add_child(load("res://Scenes/Battle/CharacterPanel.tscn").instance())
					characterPanel = board.get_node("Combat/Characters/AllEnemies").get_children()[enemies.find(character)]
					characterPanel.index = enemies.find(character)
					characterPanel.get_node("VBox/Health").show()
					characterPanel.get_node("VBox/HealthAndMana").hide()
				characterPanel.get_node("VBox/Picture/Pic").texture = load(character.picture.path)
				characterPanel.get_node("VBox/Picture/Pic").flip_h = character.picture.flip_profile[0]
				characterPanel.get_node("VBox/Picture/Pic").flip_v = character.picture.flip_profile[1]
				characterPanel.get_node("VBox/Name").text = character.name
				characterPanel.show()
				if character.picture.border.shown:
					characterPanel.get_node("VBox/Picture/PicBorder").texture = load(character.picture.border.path)
					characterPanel.get_node("VBox/Picture/PicBorder").show()
				else:
					characterPanel.get_node("VBox/Picture/PicBorder").hide()
				if board == TargetList:
					characterPanel.get_node("VBox/Picture/AttackControls").show()
					characterPanel.get_node("VBox/Picture/AttackCount").show()
				else:
					characterPanel.get_node("VBox/Picture/AttackControls").hide()
					characterPanel.get_node("VBox/Picture/AttackCount").hide()
	update_Characters()
	
func update_Characters():
	##update stats
	for board in [BattleBoard, TargetList]:
		for characterType in [friendlies, enemies]:
			for character in characterType:
				##looks
				var characterPanel
				if characterType == friendlies:
					characterPanel = board.get_node("Combat/Characters/AllFriendlies").get_children()[friendlies.find(character)]
				else:
					characterPanel = board.get_node("Combat/Characters/AllEnemies").get_children()[enemies.find(character)]
					characterPanel.disable("Minus")
				##stats
				characterPanel.get_node("VBox/Picture/AttackCount").text = ""
				characterPanel.get_node("VBox/Health/HealthBar").value = character.health.current*100/(character.health.max)
				characterPanel.get_node("VBox/Health/HealthText").text = "Health: %d/%d" % [character.health.current, character.health.max]
				characterPanel.get_node("VBox/HealthAndMana/Health/HealthBar").value = character.health.current*100/character.health.max
				characterPanel.get_node("VBox/HealthAndMana/Health/HealthText").text = "Health: %d/%d" % [character.health.current, character.health.max]
				if character.mana.max > 0:
					characterPanel.get_node("VBox/HealthAndMana/Mana/ManaBar").value = character.mana.current*100/character.mana.max
					characterPanel.get_node("VBox/HealthAndMana/Mana/ManaText").text = "Mana: %d/%d" % [character.mana.current, character.mana.max]
				else:
					characterPanel.get_node("VBox/HealthAndMana/Mana/ManaBar").value = 0
					characterPanel.get_node("VBox/HealthAndMana/Mana/ManaText").text = "Mana: 0/0"
				if character.health.current > 0:
					characterPanel.get_node("VBox/Picture/Blood").hide()
				else:
					characterPanel.get_node("VBox/Picture/Blood").show()
	if enemies.size() > 4:
		get_node("DisplayArea/BattleBoard/Combat/Characters/AllEnemies").add_constant_override("hseparation", 84)
	else:
		get_node("DisplayArea/BattleBoard/Combat/Characters/AllEnemies").add_constant_override("hseparation", 104)
	#Remove dead characters from target list
	for characterPanel in TargetList.get_node("Combat/Characters/AllEnemies").get_children():
		if characterPanel.get_node("VBox/Picture/Blood").visible and !activeAttackRessurection:
			characterPanel.hide()
		elif !characterPanel.get_node("VBox/Picture/Blood").visible and activeAttackRessurection:
			characterPanel.hide()
		else:
			characterPanel.show()
	for characterPanel in TargetList.get_node("Combat/Characters/AllFriendlies").get_children():
		if characterPanel.get_node("VBox/Picture/Blood").visible and !activeAttackRessurection:
			characterPanel.hide()
		elif !characterPanel.get_node("VBox/Picture/Blood").visible and activeAttackRessurection:
			characterPanel.hide()
		else:
			characterPanel.show()
		if activeAttack != {}:
			if characterPanel.index == activeCharacterIndex and activeAttackMode == "Abilities":
				if !activeAttack.selfCastable:
					characterPanel.hide()
				else:
					characterPanel.show()
				
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
	TargetList.hide()
	update_attacks(activeCharacterIndex, "attacks")
	AttackList.show()

func attackButton(attack, attackType, mode):
	if !processing:
		processing = true
		if friendlies[activeCharacterIndex].health.current > 0:
			if friendlies[activeCharacterIndex].AP.current >= attack.APcost:
				activeAttack = attack
				activeAttackType = attackType
				activeAttackMode = mode
				#if enemies[0].health.current > 0:
				#	attackCharacter(friendlies[activeCharacterIndex], [enemies[0]], attack, attackType)
				#else:
				#	break
				if attack.targetAmount % 1000 == 0:
					attackCharacter(friendlies[activeCharacterIndex], enemies, attack, attackType)
				else:
					attack.targetEnemy
					if attack.targetEnemy:
						TargetList.get_node("Combat/Characters/AllEnemies").show()
						TargetList.get_node("Combat/Characters/AllFriendlies").hide()
					if !attack.targetEnemy:
						TargetList.get_node("Combat/Characters/AllEnemies").hide()
						TargetList.get_node("Combat/Characters/AllFriendlies").show()
					attacksLeft = attack.targetAmount
					attackTargets = []
					update_Characters()
					updateAttackList(0, 0)
					AttackList.hide()
					TargetList.show()
					
		update_attacks(activeCharacterIndex, mode, false)
		processing = false

func _on_Abilities_pressed():
	BattleBoard.hide()
	TargetList.hide()
	update_attacks(activeCharacterIndex, "abilities")
	AttackList.show()

func update_attacks(CharacterIndex: int, mode: String, create=true):
	#character index variable should be replaced with activeCharacterIndex global variable
	var attacksList = get_node("DisplayArea/AttackBoard/AttackScrollBar/AttacksList")
	if create:
		for attack in attacksList.get_children():
			attack.free()
	#Add character attacks
	var moveList = friendlies[CharacterIndex][mode]
	var attackLibrary
	if mode == "attacks":
		attackLibrary = Attacks
	elif mode == "abilities":
		attackLibrary = Abilities
	var attackCount = 0
	for attackType in ["melee", "ranged", "mana"]:
		for attack in moveList[attackType]:
			attack = attackLibrary[attackType][attack]
			if create:
				attacksList.add_child(load("res://Scenes/Battle/AttackItem.tscn").instance())
			#Get move info
			var attackItem = attacksList.get_children()[attackCount]
			var pictureLocation = attack.image
			var attackName = attack.name
			var attackDamage = attack.hpDamage
			var attackCost = attack.APcost
			var check = checkAttack(friendlies[CharacterIndex], attack, attackType)
			if mode == "attacks":
				attackItem.get_node("Description").text = "Attack Name: " + attack.name
			elif mode == "abilities":
				attackItem.get_node("Description").text = "Ability Name: " + attack.name
			else:
				attackItem.get_node("Description").text = "Name: " + attack.name
			if attack.hpDamage > 0:
				attackItem.get_node("Description").text += "\nHP Damage: " + str(attack.hpDamage)
			elif attack.hpDamage < 0:
				attackItem.get_node("Description").text += "\nHeal Amount: " + str(-attack.hpDamage)
			if attackType == "ranged":
				if attack.ammoCost > 1:
					attackItem.get_node("Description").text += "\nAmmo Cost: " + str(attack.ammoCost)
				elif attack.ammoCost < 0:
					attackItem.get_node("Description").text += "\nAmmo Recovered: " + str(-attack.ammoCost)
			if attackType == "mana":
				if attack.manaDamage > 0:
					attackItem.get_node("Description").text += "\nMana Damage: " + str(attack.manaDamage)
				elif attack.manaDamage < 0:
					attackItem.get_node("Description").text += "\nMana Given: " + str(-attack.manaDamage)
				if attack.manaCost > 0:
					attackItem.get_node("Description").text += "\nMana Cost: " + str(attack.manaCost)
				elif attack.manaCost < 0:
					attackItem.get_node("Description").text += "\nMana Recovered: " + str(-attack.manaCost)
			if mode == "abilities" and attack.status.size() > 0:
				attackItem.get_node("Description").text += "\nStatus affects:"
				for status in attack.status:
					attackItem.get_node("Description").text += "\n      - " + str(status[1]) + "% chance to get " + status[0]
			if attack.targetAmount >= getAlive(enemies) or attack.targetAmount == 1000:
				if attack.targetEnemy:
					attackItem.get_node("Description").text += "\nTargets: all enemies"
				else:
					attackItem.get_node("Description").text += "\nTargets: all friendlies"
			elif attack.targetAmount > 1:
				if attack.targetEnemy:
					attackItem.get_node("Description").text += "\nTargets: " + str(attack.targetAmount) + " enemies"
				else:
					attackItem.get_node("Description").text += "\nTargets: " + str(attack.targetAmount) + " friendlies"
			elif attack.targetAmount == 1:
				if attack.targetEnemy:
					attackItem.get_node("Description").text += "\nTargets: 1 enemy"
				else:
					attackItem.get_node("Description").text += "\nTargets: 1 friendly"
			if attack.targetAmount == 0:
				attackItem.get_node("Description").text += "\nTargets: self-casted"
			if attack.targetAmount < 0:
				if attack.targetEnemy:
					attackItem.get_node("Description").text += "\nTargets: " + str(attack.targetAmount) + " random enemies"
				else:
					attackItem.get_node("Description").text += "\nTargets: " + str(attack.targetAmount) + " random friendlies"
			if attack.APcost > 0:
				attackItem.get_node("Description").text += "\nAP Cost: " + str(attack.APcost)
			elif attack.APcost < 0:
				attackItem.get_node("Description").text += "\nAP Recovered: " + str(-attack.APcost)
			var disabled = !check[0]
			var hint = check[1]
			attackItem.get_node("Picture").texture = load(pictureLocation)
			attackItem.get_node("Use").disabled = disabled
			attackItem.get_node("Use").hint_tooltip = hint
			attackItem.get_node("Use").connect("pressed", self, "attackButton", [ attack, attackType, mode ])
			attackCount+=1

func getAlive(characters: Array):
	var count = 0
	for character in characters:
		if character.health.current > 0:
			count+=1
	return count

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
	var checkResults = checkAttack(attacker, attack, attackType)
	if checkResults[0]:
		var canAttack=true
		Core.emit_signal('msg', attacker.name + ' uses ' + attack.name + '!', Log.BATTLE, self)
		var effectsActivated = CharacterManager.checkBuffs(attacker, "battleEffects")
		for effect in effectsActivated:
			if effect == "noAttack":
					canAttack=false
			if effect == "randomTarget" or effect == "oppositeTarget" and (attacker != otherCharacters[0] and otherCharacters.size() == 1): # doesnt work if self casted only on the player
				var newTargets
				if effect == "oppositeTarget":
					if randi()%2==1:
						newTargets = friendlies
					else: newTargets = enemies
				if effect == "oppositeTarget":
					if !effectsActivated.has("randomTarget"):
						if enemies.has(otherCharacters[0]):
							newTargets = friendlies
						else:
							newTargets = enemies
				var index = 0
				for character in otherCharacters:
					otherCharacters[index] = newTargets[randi()%newTargets.size()]
					while (otherCharacters[index] == attacker or otherCharacters[index].health.current == 0) and getAlive(newTargets) > 1: #allow health = 0 if type is resurrection
						otherCharacters[index] = newTargets[randi()%newTargets.size()]
					if getAlive(newTargets) <= 1:
						otherCharacters[index] = attacker
						Core.emit_signal('msg', '        -' + attacker.name + ' targets themselves by accident', Log.BATTLE, self)
					else:
						Core.emit_signal('msg', '        -' + attacker.name + ' targets their own team by accident', Log.BATTLE, self)
		if canAttack:
			var attackTimes = attack.attackTimes
			while attackTimes > 0:
				if attack.targetEnemy:
					# attack enemy
					for otherCharacter in otherCharacters:
						otherCharacter.health.current-=attack.hpDamage
						if otherCharacter.health.current < 0:
							otherCharacter.health.current=0
						if otherCharacter.health.current > 0:
							if attack.hpDamage > 0:
								Core.emit_signal('msg', '    -' + otherCharacter.name + ' takes ' + str(attack.hpDamage) + ' HP damage', Log.BATTLE, self)
							if "status" in attack.keys():
								for buff in attack.status:
									if randi()%100+1 <= buff[1]:
										CharacterManager.addBuff(otherCharacter, buff[0])
										Core.emit_signal('msg', '        -' + otherCharacter.name + ' is ' + buff[0], Log.BATTLE, self)
						else:
							Core.emit_signal('msg', '    -' + otherCharacter.name + ' has died!', Log.BATTLE, self)
						if attackType == "mana":
							otherCharacter.mana.current-=attack.manaDamage
							if otherCharacter.mana.current < 0:
								otherCharacter.mana.current=0
						attacked = true
				else:
					# heal friendly
					for otherCharacter in otherCharacters:
						otherCharacter.health.current -= attack.hpDamage
						if otherCharacter.health.current > otherCharacter.health.max:
							otherCharacter.health.current = otherCharacter.health.current
						Core.emit_signal('msg', '    -' + otherCharacter.name + ' is healed by ' + str(-attack.hpDamage) + ' HP', Log.BATTLE, self)
						if attack.has("specialAffects"):
							for buff in attack.specialAffects:
								if randi()%100+1 <= buff[1]:
									CharacterManager.addBuff(otherCharacter, buff[0])
									Core.emit_signal('msg', '        -' + otherCharacter.name + ' is ' + buff[0], Log.BATTLE, self)
						if attackType == "mana":
							otherCharacter.mana.current-=attack.manaDamage
							if otherCharacter.mana.current < 0:
								otherCharacter.mana.current=0
						attacked = true
				if randi()%100+1 <= attack.attackTimesChance:
					attackTimes -= 1
				else:
					attackTimes = 0
			attacker.AP.current -=attack.APcost
			if attackType == "mana":
				attacker.mana.current-=attack.manaCost
				if attacker.mana.current < 0:
					attacker.mana.current=0
			attacker.AP.ticks +=1
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
			for otherCharacter in otherCharacters:
				if otherCharacter.health.current == 0:
					if otherCharacter in enemies:
						var referencePoint = enemies.find(otherCharacter)
						enemies.remove(referencePoint)
						enemies.append(otherCharacter)
						var count = 0
						while count < nextCharacterIndex.size():
							var turn = nextCharacterIndex[count]
							if turn[0] == "Enemy":
								#print ("turn", referencePoint)
								#print(nextCharacterIndex)
								if turn[1] > referencePoint:
									nextCharacterIndex[count] = [turn[0], turn[1]-1]
									#print(1, nextCharacterIndex)
								elif turn[1] == referencePoint:
									nextCharacterIndex.remove(count)
									count-=1
									#print(4, nextCharacterIndex)
							count+=1
					else:
						var referencePoint = friendlies.find(otherCharacter)
						friendlies.remove(referencePoint)
						friendlies.append(otherCharacter)
						var count = 0
						while count < nextCharacterIndex.size():
							var turn = nextCharacterIndex[count]
							if turn[0] == "Friendlies":
								#print ("turn", referencePoint)
								#print(nextCharacterIndex)
								if turn[1] > referencePoint:
									nextCharacterIndex[count] = [turn[0], turn[1]-1]
									#print(1, nextCharacterIndex)
								elif turn[1] == referencePoint:
									nextCharacterIndex.remove(count)
									count-=1
									#print(4, nextCharacterIndex)
							count+=1
	else:
		Core.emit_signal('msg', 'Attack_Character failed: check attack said: ' + checkResults[1], Log.DEBUG, self)
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
			gameEnded()
	# AI Attack
	if nextCharacterIndex.size() > 0 && activeCharacterIndex == -1 && !gameOver:
		if !processing:
			processing = true
			for buttonArea in get_node("Buttons").get_children():
				for button in buttonArea.get_children():
					button.disabled = true
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
											while character.AP.current >= attack.APcost:
												if otherCharacter.health.current > 0:
													if attackCharacter(character, [otherCharacter], attack, attackType) == true:
														attacked = true
												else:
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
										while character.AP.current >= attack.APcost:
											if otherCharacter.health.current > 0:
												if attackCharacter(character, [otherCharacter], attack, attackType) == true:
													attacked = true
											else:
												break
							if attacked:
								break
			if nextCharacterIndex.size() > 0:
				charactersThatMoved.append(nextCharacterIndex[0])
				nextCharacterIndex.remove(0)
			create_Characters()
			processing = false
			for buttonArea in get_node("Buttons").get_children():
				for button in buttonArea.get_children():
					button.disabled = false
	
	if nextCharacterIndex.size() == 0 && activeCharacterIndex == -1 && !gameOver:
		if !processing:
			processing = true
			for buttonArea in get_node("Buttons").get_children():
				for button in buttonArea.get_children():
					button.disabled = true
			#Apply end of turn effects
			for characterDetails in charactersThatMoved:
				if characterDetails[0] == "Friendly":
					var character = friendlies[characterDetails[1]]
					if character.health.current > 0:
						character.AP.turnCount+=1
						#Core.emit_signal('msg', '    -' + character.name + ' increase turn count' + str (character.AP.turnCount), Log.BATTLE, self)
						CharacterManager.checkBuffs(character, "specialEffects")
					
				else:
					var character = enemies[characterDetails[1]]
					if character.health.current > 0:
						character.AP.turnCount+=1
						#Core.emit_signal('msg', '    -' + character.name + ' increase turn count' + str (character.AP.turnCount), Log.BATTLE, self)
						CharacterManager.checkBuffs(character, "specialEffects")
			charactersThatMoved = []
			# Increase characters AP intil a move is ready
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
			processing = false
			for buttonArea in get_node("Buttons").get_children():
				for button in buttonArea.get_children():
					button.disabled = false
		

func _on_Items_pressed():
	BattleBoard.hide()
	AttackList.hide()
	TargetList.hide()

func _on_Retreat_pressed():
	#####not final
	Core.get_parent().add_child(load("res://Scenes/CharacterSelection/CharacterSelection.tscn").instance())
	queue_free()
	
func _on_EndTurn_pressed():
	if !processing:
		processing = true
		for buttonArea in get_node("Buttons").get_children():
			for button in buttonArea.get_children():
				button.disabled = true
		if friendlies[activeCharacterIndex].AP.current > friendlies[activeCharacterIndex].abilities.lowestCost or friendlies[activeCharacterIndex].AP.current > friendlies[activeCharacterIndex].attacks.lowestCost:
			friendlies[activeCharacterIndex].AP.ticks +=1 ###Should this be a feature. People who are waiting for a stronger attack will stil count as a turn.
		BattleBoard.show()
		TargetList.hide()
		AttackList.hide()
		activeCharacterIndex = -1
		processing = false
		for buttonArea in get_node("Buttons").get_children():
			for button in buttonArea.get_children():
				button.disabled = false
	
func _on_BackButton_pressed():
	BattleBoard.show()
	TargetList.hide()
	AttackList.hide()
	create_Characters()

func gameEnded():
	activeCharacterIndex = -1
	nextCharacterIndex.clear()
	update_turn()
	update_Characters()
	BattleBoard.show()
	get_node("DisplayArea/BattleBoard/TurnSystem/CurrentCharacter").text = "Game Over!"
	Core.emit_signal('msg', 'Game Over!', Log.BATTLE, self)


func _on_Cancel_pressed():
	TargetList.hide()
	AttackList.show()
	update_Characters()
		
func updateAttackList(modifier:int, index:int):
	attacksLeft += modifier
	if attacksLeft > 1:
		TargetList.get_node("TargetText").text = "Choose " + str(attacksLeft) + " targets"
	elif attacksLeft == 0:
		TargetList.get_node("TargetText").text = "All targets chosen"
		if activeAttack.targetEnemy:
			for characterPanel in TargetList.get_node("Combat/Characters/AllEnemies").get_children():
				characterPanel.disable("Plus")
		else:
			for characterPanel in TargetList.get_node("Combat/Characters/AllFriendlies").get_children():
				characterPanel.disable("Plus")
	else:
		TargetList.get_node("TargetText").text = "Choose 1 target"
		if activeAttack.targetEnemy:
			for characterPanel in TargetList.get_node("Combat/Characters/AllEnemies").get_children():
				characterPanel.enable("Plus")
		else:
			for characterPanel in TargetList.get_node("Combat/Characters/AllFriendlies").get_children():
				characterPanel.enable("Plus")
	if modifier != 0:
		var targets = []
		if activeAttack.targetEnemy:
			targets = enemies
		else:
			targets = friendlies
		if modifier == -1:
			attackTargets.append(targets[index])
		else:
			attackTargets.remove(attackTargets.find(targets[index]))

func _on_Done_pressed():
	attackCharacter(friendlies[activeCharacterIndex], attackTargets, activeAttack, activeAttackType)
	update_Characters()
	update_attacks(activeCharacterIndex, activeAttackMode, false)
	TargetList.hide()
	if !gameOver:
		AttackList.show()
