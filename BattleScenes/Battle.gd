extends Node

onready var BattleBoard = $"TopScreen/DisplayArea/BattleBoard/"
onready var AttackList = $"TopScreen/DisplayArea/AttackBoard/"
onready var friendlies = []
onready var activeCharcterIndex = 0
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
	##Set characters and menues
	get_node("TopScreen/AreaTitle/Name").text = sceneName
	get_node("TopScreen/Background").texture = load(background)
	##Initiate and unhide needed tiles
	for character in friendlies:
		##looks
		get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").add_child(load("res://BattleScenes/CharacterPanel.tscn").instance())
		var friendPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllFriendlies").get_children()[friendlies.find(character)]
		friendPanel.get_node("VBox/Picture/Pic").texture = load(character.pic[0])
		friendPanel.get_node("VBox/Picture/Pic").flip_h = character.pic[1]
		friendPanel.get_node("VBox/Picture/Pic").flip_v = character.pic[2]
		friendPanel.get_node("VBox/Name").text = character.name
		friendPanel.show()
		if character.picBorder[0]:
			friendPanel.get_node("VBox/Picture/PicBorder").texture = load(character.picBorder[1])
			friendPanel.get_node("VBox/Picture/PicBorder").show()
		else:
			friendPanel.get_node("VBox/Picture/PicBorder").hide()
	for character in enemies:
		##looks
		get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").add_child(load("res://BattleScenes/EnemyPanel.tscn").instance())
		var enemyPanel = get_node("TopScreen/DisplayArea/BattleBoard/AllEnemies").get_children()[enemies.find(character)]
		enemyPanel.get_node("VBox/Control/Pic").texture = load(character.pic[0])
		enemyPanel.get_node("VBox/Control/Pic").flip_h = character.pic[1]
		enemyPanel.get_node("VBox/Control/Pic").flip_v = character.pic[2]
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
	for attackType in friendlies[0].attacks:
		for attack in attackType:
			attacksList.add_child(load("res://BattleScenes/AttackItem.tscn").instance())
			var attackItem = attacksList.get_children()[attackCount]
			var pictureLocation
			if friendlies[0].attacks.find(attackType) == 0:
				var attackName = meleeAttackList[attack].name
				var attackDamage = meleeAttackList[attack].hpDamage
				var attackCost = meleeAttackList[attack].APcost
				pictureLocation = attackImages[meleeAttackList[attack].weapon]
				attackItem.get_node("Description").text = """Attack Name: %s
HP Damage: %s
AP Cost: %s""" % [attackName, attackDamage, attackCost]
			if friendlies[0].attacks.find(attackType) == 1:
				var attackName = rangedAttackList[attack].name
				var attackDamage = rangedAttackList[attack].hpDamage
				var attackCost = rangedAttackList[attack].APcost
				var ammoCost = rangedAttackList[attack].ammoCost
				pictureLocation = attackImages[rangedAttackList[attack].weapon]
				attackItem.get_node("Description").text = """Attack Name: %s
HP Damage: %s
AP Cost: %s
Ammo Cost: %s""" % [attackName, attackDamage, attackCost, ammoCost]
			if friendlies[0].attacks.find(attackType) == 2:
				var attackName = manaAttackList[attack].name
				var attackDamage = manaAttackList[attack].hpDamage
				var attackCost = manaAttackList[attack].APcost
				var manaCost = manaAttackList[attack].manaCost
				pictureLocation = attackImages[manaAttackList[attack].weapon]
				attackItem.get_node("Description").text = """Attack Name: %d
HP Damage: %s
Mana Damage: %s
AP Cost: %s
Mana Cost: %s""" % [attackName, attackDamage, attackCost, manaCost]
			attackItem.get_node("Picture").texture = load(pictureLocation)
			attackCount+=1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Attack_pressed():
	BattleBoard.hide()
	AttackList.show()
	enemies[0].health-=10

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
		friendPanel.get_node("VBox/Mana/ManaBar").value = character.mana*100/character.manaMax
		friendPanel.get_node("VBox/Mana/ManaText").text = "Mana: %d/%d" % [character.mana, character.manaMax]
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
