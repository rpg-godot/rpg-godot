class_name Attacks
const script_name := "attacks"

##Weapon type, Image location
const attackImages = {
	"Fists":"res://Assets/Images/Icons/Attacks/Fists Attack.png",
	"Claws":"res://Assets/Images/Icons/Attacks/Claws Attack.PNG",
	"Sword":"res://Assets/Images/Icons/Attacks/Sword Attack.PNG",
	"Bow":"res://Assets/Images/Icons/Attacks/Bow Attack.png",
	"Teeth":"res://Assets/Images/Icons/Attacks/Teeth Attack.png",
	"Fire_Small":"res://Assets/Images/Icons/Attacks/Fire-Small Attack.png"
}
const melee := {

	punch = {
		name = "Punch", 
		hpDamage = 5,
		APcost = 0.5,
		target = true, 
		image = attackImages.Fists,
		weaponNeeded = ["none"], 
		itemLevelRequirements = 1
	},

	scratch = {
		name = "Scratch",
		hpDamage = 10,
		APcost = 1, 
		target = true, 
		image = attackImages.Claws,
		weaponNeeded = ["none"], 
		itemLevelRequirements = 1
	},

	bite = {
		name = "Bite",
		hpDamage = 15,
		APcost = 1.5,
		target = true,
		image = attackImages.Teeth,
		weaponNeeded = ["none"], 
		itemLevelRequirements = 1
	},

	strike = {
		name = "Strike",
		hpDamage = 25,
		APcost = 1, 
		target = true, 
		image = attackImages.Sword, 
		weaponNeeded = [
			"one-handed sword", 
			"two-handed swords", 
			"two-handed axe"
		], 
		itemLevelRequirements = 1
	}
}

const ranged := {

	quick_shot = {
		name = "Quick Shot",
		hpDamage = 20,
		APcost = 1,
		target = true, 
		image = attackImages.Bow,
		ammoCost = 1,
		weaponNeeded = [
			["bow", "hunting bow"],
			["arrow"]
		],
		itemLevelRequirements = 1,
		arrowLevelRequirements = 1
	},

	precision_shot = {
		name = "Precision Shot",
		hpDamage = 40, 
		APcost = 2, 
		target = true,
		image = attackImages.Bow,
		ammoCost = 1,
		weaponNeeded = [
			["bow", "hunting bow"], 
			["arrow"]
		],
		itemLevelRequirements = 2,
		arrowLevelRequirements = 1
	}
}

const mana := {

	flame = {
		name = "Flame",
		hpDamage = 25,
		manaDamage = 5,
		APcost = 1,
		manaCost = 20,
		target = true,
		image = attackImages.Fire_Small,
		weaponNeeded = ["one-handed staff"],
		itemLevelRequirements = 1
	}
}
