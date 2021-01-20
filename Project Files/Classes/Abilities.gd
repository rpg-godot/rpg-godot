class_name Abilities
const script_name := "abilities"

##Ability name, Image location
const abilityImages = {
	"Heart_Heal": "res://Assets/Images/Icons/Attacks/Heart Heal.png",
	"Stun_Weak": "res://Assets/Images/Icons/Attacks/Sword Stun.png",
	"Distract": "res://Assets/Images/Icons/Attacks/Arrow.png"
}
# negative target amount means random
const melee := {

	stun_weak = {
		name = "Weak Stun", 
		hpDamage = 5,
		#status type, chance
		status = [["Stunned", 40]],
		APcost = 1,
		targetEnemy = true,
		targetAmount = 1,
		selfCastable = false,
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
		status = [["stunned", 60]],
		APcost = 1,
		targetEnemy = true,
		targetAmount = 1,
		selfCastable = false,
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
		status = [["confused", 70]],
		APcost = 1,
		targetEnemy = true,
		targetAmount = 1000, #everyone
		selfCastable = false,
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
		status = [["rejuvenation", 10]],
		APcost = 1,
		manaCost = 30,
		targetEnemy = false,
		targetAmount = 1,
		selfCastable = true,
		image = abilityImages.Heart_Heal,
		weaponNeeded = ["two-handed staff"],
		itemLevelRequirements = 1
	}
}

##Buff name, Image location
const buffImages := {
	"Heal": "res://Assets/Images/Icons/Attacks/Heart Heal.png",
	"Stun": "res://Assets/Images/Icons/Attacks/Sword Stun.png",
	"Confused": "res://Assets/Images/Icons/Attacks/Arrow.png"
}

const buffs := {

	rejuvination = {
		name = "Rejuvination",
		hpDamage = -20,
		manaDamage = -10,
		APDamage = -0.5,
		specialAffect = [],
		image = buffImages.Heal,
		ticks = 1, #affect happens every turn
		ticksLeft = 5 #affect ends after this many turns
	},

	confused = {
		name = "Confused",
		hpDamage = 0,
		manaDamage = 0,
		APDamage = 0,
		specialAffect = [["randomTarget",80]], #[affect, chance] the chance will break the affect early if not hit right
		image = buffImages.Confused,
		ticks = 1,
		ticksLeft = 7
	},

	stunned = {
		name = "Stunned",
		hpDamage = 0,
		manaDamage = 0,
		APDamage = 0,
		specialAffect = [["noAttack", 80]],
		image = buffImages.Confused,
		ticks = 1,
		ticksLeft = 7
	},
}
