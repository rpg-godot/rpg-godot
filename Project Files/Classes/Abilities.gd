class_name Abilities
const script_name := "attacks"

##Weapon type, Image location
const abilityImages = {
	"Heart_Heal": "res://Assets/Images/Icons/Attacks/Heart Heal.png",
	"Stun_Weak": "res://Assets/Images/Icons/Attacks/Sword Stun.png",
	"Distract": "res://Assets/Images/Icons/Attacks/Arrow.png"
}
# negative target amount means all
const melee := {

	stun_weak = {
		name = "Weak Stun", 
		hpDamage = 5,
		#status type, chance
		status = [["Stunned", 40]],
		APcost = 1,
		targetEnemy = true,
		targetAmount = 1,
		image = abilityImages.Stun_Weak,
		weaponNeeded = [
			"one-handed sword", 
			"two-handed swords", 
			"two-handed axe"], 
		itemLevelRequirements = 1
	},

	stun_medium = {
		name = "Medium Stun", 
		hpDamage = 5,
		#status type, chance
		status = [["Stunned", 60]],
		APcost = 1,
		targetEnemy = true,
		targetAmount = 1,
		image = abilityImages.Stun_Weak,
		weaponNeeded = [
			"two-handed axe"], 
		itemLevelRequirements = 1
	}
}

const ranged := {

	distract_arrow = {
		name = "Arrow Distraction",
		hpDamage = 0,
		status = [["Confused", 70]],
		APcost = 1,
		targetEnemy = true,
		targetAmount = -1, #everyone
		image = abilityImages.Distract,
		ammoCost = 1,
		weaponNeeded = [
			["bow", "hunting bow"],
			["arrow"]
		],
		itemLevelRequirements = 1,
		arrowLevelRequirements = 1
	}
}

const mana := {

	heal_weak = {
		name = "Heal",
		hpDamage = -50,
		manaDamage = 0,
		status = [],
		APcost = 1,
		manaCost = 30,
		targetEnemy = false,
		targetAmount = 1,
		image = abilityImages.Heart_Heal,
		weaponNeeded = ["two-handed staff"],
		itemLevelRequirements = 1
	}
}
