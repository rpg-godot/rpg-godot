class character:
	var name = "Default Name"
	var stats = {"Strength":0, "Perception":0, "Endurance":0, "Charisma":0, "Intelligence":0, "Agility":0, "Luck":0}
	var pic = ["res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png", true, false]
	var picBorder = [true, "res://Assets/Images/Profiles/Image Border.png"]
	var attacks = []
	var level = 1
	var skills = []
	var APmax = 1
	var APspeed = 0.5
	var AP = APmax
	var healthMax = 100
	var health = healthMax
	var manaMax = 50
	var mana = manaMax
	var kills = 0
## charName, [Strength, Perception, Endurance, Charisma, Intelligence, Agility, Luck], [imageLocation, flipH, flipV], [useBorder, borderLocation], [[meleeAttacks], [rangeAttacks], [manaAttacks]], level, [skills], APmax, APrecoverySpeedPerTurn, healthMax, manaMax
static func CreateClass(name:String, stats:Array, pic:Array, picBorder:Array, attacks:Array, level:int, skills:Array, APmax:int, APspeed:int, healthMax:int, manaMax:int):
	var Character = character.new()
	Character.name = name
	Character.stats = {"Strength":stats[0], "Perception":stats[1], "Endurance":stats[2], "Charisma":stats[3], "Intelligence":stats[4], "Agility":stats[5], "Luck":stats[6]}
	Character.pic = pic
	Character.picBorder = picBorder
	Character.attacks = attacks
	Character.level = level
	Character.skills = skills
	Character.APmax = APmax
	Character.APspeed = APspeed
	Character.AP = APmax
	Character.healthMax = healthMax
	Character.health = healthMax
	Character.manaMax = manaMax
	Character.mana = manaMax
	return Character

## [[meleeAttacks], [rangeAttacks], [manaAttacks]], level, [skills], APmax, APrecoverySpeedPerTurn, healthMax
static func DeathHound(attacks:Array, level:int, skills:Array, APmax:int, APspeed:int, healthMax:int):
	var Character = character.new()
	Character.name = "Death Hound"
	Character.stats = {"Strength":0, "Perception":0, "Endurance":0, "Charisma":0, "Intelligence":0, "Agility":0, "Luck":0}
	Character.pic = ["res://Assets/Images/Profiles/Enemies/MonstersAvatarIcons_61.PNG", false, false]
	Character.picBorder = [false]
	Character.attacks = [[2, 3], [], []]
	Character.level = level
	Character.skills = skills
	Character.APmax = APmax
	Character.APspeed = APspeed
	Character.AP = APmax
	Character.healthMax = healthMax
	Character.health = healthMax
	Character.manaMax = 0
	Character.mana = 0
	for attacktype in attacks:
		for attack in attacktype:
			if Character.attacks[attacks.find(attacktype)].find(attack) == -1:
				Character.attacks[attacks.find(attacktype)].append(attack)
	## Set stat values based off level
	var tempLevel = Character.level
	var count = 1
	while tempLevel >= 5:
		Character.stats["Strength"] += 1
		Character.stats["Intelligence"] += 1
		Character.stats["Agility"] += 1
		Character.stats["Luck"] += 1
		if count%3==0:
			Character.stats["Perception"] += 1
			Character.stats["Endurance"] += 1
			Character.stats["Charisma"] += 1
		count+=1
		tempLevel-=5
	return Character

##  Name, HP Damage, Mana Damage, AP Cost, Target-Type (true = enemy, false = friendly), SFX type, weapon type
var meleeAttackList = {
		1:["Punch", 5, 0, 0.5, true, "Quick", "Fists"],
		2:["Scratch", 10, 0, 1, true, "Claw", "Claws"],
		3:["Bite", 15, 0, 1.5, true, "Teeth", "Claws"],
		4:["Strike", 25, 0, 1, true, "Sword", "Sword"]
	}
##  Name, HP Damage, Mana Damage, AP Cost, Target-Type (true = enemy, false = friendly), weapon type, ammo use
var rangedAttackList = {
		1:["Single Shot", 10, 0, 2, true, "Bow", 1]
	}
##  Name, HP Damage, Mana Damage, AP Cost, Mana Cost, Target-Type (true = enemy, false = friendly), SFX type
var manaAttackList = {
		1:["Flame", 25, 5, 1, 20, true, "Fire-Small"]
	}
##Weapon type, Image location
var attackImages = {
	"Fists":"res://Assets/Images/Icons/Fists Attack.PNG",
	"Sword":"res://Assets/Images/Icons/Sword Attack.PNG"
	}
