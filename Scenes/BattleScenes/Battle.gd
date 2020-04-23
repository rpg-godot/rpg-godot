extends Node

onready var BattleBoard = $"TopScreen/DisplayArea/BattleBoard/"
onready var AttackList = $"TopScreen/DisplayArea/AttackBoard/"
onready var friendlies = []
onready var activeCharacterIndex = 0
onready var enemies = []
onready var Classes = get_node("/root/Variables").Classes
onready var meleeAttackList = Classes.meleeAttackList
onready var rangedAttackList = Classes.rangedAttackList
onready var manaAttackList = Classes.manaAttackList
onready var attackImages = Classes.attackImages


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

func update_Setting(sceneName:String, background:String):
	## Set characters and menues
	get_node("TopScreen/AreaTitle/Name").text = sceneName
	get_node("TopScreen/Background").texture = load(background)
	## Initiate and unhide needed tiles
	for character in friendlies:
		## Looks
		get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").add_child(load("res://Scenes/BattleScenes/CharacterPanel.tscn").instance())
		var friendPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").get_children()[friendlies.find(character)]
		friendPanel.get_node("VBox/Picture/Pic").texture = load(character.pic[0])
		friendPanel.get_node("VBox/Picture/Pic").flip_h = character.pic[1][0]
		friendPanel.get_node("VBox/Picture/Pic").flip_v = character.pic[1][1]
		friendPanel.get_node("VBox/Name").text = character.name
		friendPanel.show()
		if character.picBorder[0]:
			friendPanel.get_node("VBox/Picture/PicBorder").texture = load(character.picBorder[1])
			friendPanel.get_node("VBox/Picture/PicBorder").show()
		else:
			friendPanel.get_node("VBox/Picture/PicBorder").hide()
	for character in enemies:
		##looks
		get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").add_child(load("res://Scenes/BattleScenes/EnemyPanel.tscn").instance())
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()[enemies.find(character)]
		enemyPanel.get_node("VBox/Control/Pic").texture = load(character.pic[0])
		enemyPanel.get_node("VBox/Control/Pic").flip_h = character.pic[1][0]
		enemyPanel.get_node("VBox/Control/Pic").flip_v = character.pic[1][1]
		enemyPanel.get_node("VBox/Name").text = character.name
		enemyPanel.show()
		if character.picBorder[0]:
			enemyPanel.get_node("VBox/Control/PicBorder").texture = load(character.picBorder[1])
			enemyPanel.get_node("VBox/Control/PicBorder").show()
		else:
			enemyPanel.get_node("VBox/Control/PicBorder").hide()

func update_Attacks(CharacterIndex):
	var attacksList = get_node("TopScreen/DisplayArea/AttackBoard/AttackScrollBar/AttacksList")
	for attack in attacksList.get_children():
		attack.free()
	##Add character attacks
	var attackCount = 0
	print (friendlies[CharacterIndex].attacks)
	for attack in friendlies[CharacterIndex].attacks["melee"]:
		attacksList.add_child(load("res://Scenes/BattleScenes/AttackItem.tscn").instance())
		var attackItem = attacksList.get_children()[attackCount]
		var pictureLocation
		var disabled = true
		var attackName = meleeAttackList[attack].name
		var attackDamage = meleeAttackList[attack].hpDamage
		var attackCost = meleeAttackList[attack].APcost
		pictureLocation = attackImages[meleeAttackList[attack].image]
		attackItem.get_node("Description").text = """Attack Name: %s
HP Damage: %s
AP Cost: %s""" % [attackName, attackDamage, attackCost]
		if attackCost <= friendlies[CharacterIndex].AP:
			if friendlies[CharacterIndex].equipment.items["weapons"]["melee"].size() > 0:
				if friendlies[CharacterIndex].equipment.items["weapons"]["melee"][0][0].subType in meleeAttackList[attack].weaponNeeded:
					if friendlies[CharacterIndex].equipment.items["weapons"]["melee"][0][0].levelRequirement >= meleeAttackList[attack]["itemLevelRequirements"]:
						disabled = false
			if "none" in meleeAttackList[attack].weaponNeeded:
				if friendlies[CharacterIndex].level >= meleeAttackList[attack]["itemLevelRequirements"]:
					disabled = false
		attackItem.get_node("Picture").texture = load(pictureLocation)
		attackItem.get_node("Use").disabled = disabled
		attackCount+=1
	for attack in friendlies[CharacterIndex].attacks["ranged"]:
		attacksList.add_child(load("res://Scenes/BattleScenes/AttackItem.tscn").instance())
		var attackItem = attacksList.get_children()[attackCount]
		var pictureLocation
		var disabled = true
		var attackName = rangedAttackList[attack].name
		var attackDamage = rangedAttackList[attack].hpDamage
		var attackCost = rangedAttackList[attack].APcost
		var ammoCost = rangedAttackList[attack].ammoCost
		pictureLocation = attackImages[rangedAttackList[attack].image]
		attackItem.get_node("Description").text = """Attack Name: %s
HP Damage: %s
AP Cost: %s
Ammo Cost: %s""" % [attackName, attackDamage, attackCost, ammoCost]
		if attackCost <= friendlies[CharacterIndex].AP:
			if friendlies[CharacterIndex].equipment.items["weapons"]["ranged"].size() > 0:
				if friendlies[CharacterIndex].equipment.items["weapons"]["ranged"][0][0].subType in rangedAttackList[attack].weaponNeeded[0]:
					if friendlies[CharacterIndex].equipment.items["weapons"]["ranged"][0][0].levelRequirement >= rangedAttackList[attack]["itemLevelRequirements"]:
						for ammo in friendlies[CharacterIndex].inventory.items["weapons"]["consumables"]:
							if ammo[1] >= rangedAttackList[attack].ammoCost:
								if ammo[0].subType in rangedAttackList[attack].weaponNeeded[1] && ammo[0].levelRequirement >=  rangedAttackList[attack]["itemLevelRequirements"]:
									disabled = false
			if "none" == rangedAttackList[attack].weaponNeeded[0][0]:
				if friendlies[CharacterIndex].level >= rangedAttackList[attack]["itemLevelRequirements"]:
					for ammo in friendlies[CharacterIndex].inventory.items["weapons"]["consumables"]:
						if ammo[0].subType in rangedAttackList[attack].weaponNeeded[1]:
							if ammo[1] >= rangedAttackList[attack].ammoCost && ammo[0].levelRequirement >=  rangedAttackList[attack]["itemLevelRequirements"]:
								disabled = false
						else:
							disabled = false
		attackItem.get_node("Picture").texture = load(pictureLocation)
		attackItem.get_node("Use").disabled = disabled
		attackCount+=1
	for attack in friendlies[CharacterIndex].attacks["mana"]:
		attacksList.add_child(load("res://Scenes/BattleScenes/AttackItem.tscn").instance())
		var attackItem = attacksList.get_children()[attackCount]
		var pictureLocation
		var disabled = true
		var attackName = manaAttackList[attack].name
		var attackDamage = manaAttackList[attack].hpDamage
		var manaDamage = manaAttackList[attack].manaDamage
		var attackCost = manaAttackList[attack].APcost
		var manaCost = manaAttackList[attack].manaCost
		if attackCost <= friendlies[CharacterIndex].AP && manaCost <= friendlies[CharacterIndex].mana:
			if friendlies[CharacterIndex].equipment.items["weapons"]["magic"].size() > 0:
				if friendlies[CharacterIndex].equipment.items["weapons"]["magic"][0][0].subType in manaAttackList[attack].weaponNeeded || "none" in manaAttackList[attack].weaponNeeded:
					if friendlies[CharacterIndex].equipment.items["weapons"]["magic"][0][0].levelRequirement >= manaAttackList[attack].itemLevelRequirements:
						disabled = false
			if "none" in manaAttackList[attack].weaponNeeded:
				if friendlies[CharacterIndex].level >= manaAttackList[attack].itemLevelRequirements:
					disabled = false
		pictureLocation = attackImages[manaAttackList[attack].image]
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
	enemies[0].health-=10
	update_Attacks(activeCharacterIndex)

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
	

func update_Characters():
	##update stats
	for character in friendlies:
		##looks
		var friendPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").get_children()[friendlies.find(character)]
		##stats
		friendPanel.get_node("VBox/Health/HealthBar").value = character.health*100/character.healthMax
		friendPanel.get_node("VBox/Health/HealthText").text = "Health: %d/%d" % [character.health, character.healthMax]
		if character.manaMax > 0:
			friendPanel.get_node("VBox/Mana/ManaBar").value = character.mana*100/character.manaMax
			friendPanel.get_node("VBox/Mana/ManaText").text = "Mana: %d/%d" % [character.mana, character.manaMax]
		else:
			friendPanel.get_node("VBox/Mana/ManaBar").value = 0
			friendPanel.get_node("VBox/Mana/ManaText").text = "Mana: 0/0"
		if character.health > 0:
			friendPanel.get_node("VBox/Picture/Blood").hide()
		else:
			friendPanel.get_node("VBox/Picture/Blood").show()
	for character in enemies:
		##looks
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()[enemies.find(character)]
		##stats
		enemyPanel.get_node("VBox/Health/HealthBar").value = character.health*100/character.healthMax
		enemyPanel.get_node("VBox/Health/HealthText").text = "Health: %d/%d" % [character.health, character.healthMax]
		enemyPanel.get_node("VBox/HealthAndMana/Health/HealthBar").value = character.health*100/character.healthMax
		enemyPanel.get_node("VBox/HealthAndMana/Health/HealthText").text = "Health: %d/%d" % [character.health, character.healthMax]
		if character.manaMax > 0:
			enemyPanel.get_node("VBox/HealthAndMana/Mana/ManaBar").value = character.mana*100/character.manaMax
			enemyPanel.get_node("VBox/HealthAndMana/Mana/ManaText").text = "Mana: %d/%d" % [character.mana, character.manaMax]
		else:
			enemyPanel.get_node("VBox/HealthAndMana/Mana/ManaBar").value = 0
			enemyPanel.get_node("VBox/HealthAndMana/Mana/ManaText").text = "Mana: 0/0"
		enemyPanel.get_node("VBox/Health").show()
		enemyPanel.get_node("VBox/HealthAndMana").hide()
		if character.health > 0:
			enemyPanel.get_node("VBox/Control/Blood").hide()
		else:
			enemyPanel.get_node("VBox/Control/Blood").show()
