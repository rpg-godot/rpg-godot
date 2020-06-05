extends Character
class_name DeathHound

func _ready():
	character_name = "Death Hound"
	stats = {"Strength":3, "Perception":3, "Endurance":3, "Charisma":3, "Intelligence":3, "Agility":3, "Luck":3}
	pic = ["res://Assets/Images/Profiles/Enemies/MonstersAvatarIcons_61.PNG", [false, false]]
	picBorder = [false]
	attacks = [[2, 3], [], []]
#	level = level
#	skills = skills
#	APmax = APmax
#	APspeed = APspeed
#	AP = APmax
#	healthMax = healthMax
#	health = healthMax
	manaMax = 0
	mana = 0

## [[meleeAttacks], [rangeAttacks], [manaAttacks]], level, [skills], APmax, APrecoverySpeedPerTurn, healthMax
#func DeathHound(attacks:Array, level:int, skills:Array, APmax:int, APspeed:int, healthMax:int):
#	for attacktype in attacks:
#		for attack in attacktype:
#			if newCharacter.attacks[attacks.find(attacktype)].find(attack) == -1:
#				newCharacter.attacks[attacks.find(attacktype)].append(attack)
#	## Set stat values based off level
#	var tempLevel = newCharacter.level
#	var count = 1
#	while tempLevel >= 5:
#		newCharacter.stats["Strength"] += 1
#		newCharacter.stats["Intelligence"] += 1
#		newCharacter.stats["Agility"] += 1
#		newCharacter.stats["Luck"] += 1
#		if count%3==0:
#			newCharacter.stats["Perception"] += 1
#			newCharacter.stats["Endurance"] += 1
#			newCharacter.stats["Charisma"] += 1
#		count+=1
#		tempLevel-=5
#	return newCharacter
