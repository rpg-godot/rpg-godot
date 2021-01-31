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
		status = [["stunned", 40]],
		APcost = 1,
		targetEnemy = true,
		targetAmount = 1,
		selfCastable = false,
		attackTimes = 1,
		attackTimesChance = 100,
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
		status = [["stunned", 80]],
		APcost = 1,
		targetEnemy = true,
		targetAmount = 1,
		selfCastable = false,
		attackTimes = 1,
		attackTimesChance = 100,
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
		attackTimes = 1,
		attackTimesChance = 100,
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
		status = [["rejuvenated", 10]],
		APcost = 1,
		manaCost = 30,
		targetEnemy = false,
		targetAmount = 1,
		selfCastable = true,
		attackTimes = 1,
		attackTimesChance = 100,
		image = abilityImages.Heart_Heal,
		weaponNeeded = ["one-handed staff", "two-handed staff"],
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

	rejuvenated = {
		name = "Rejuvenated",
		hpDamage = -20,
		manaDamage = -10,
		APDamage = -0.5,
		specialEffects = [["restored", 70]], #[affect, chance] the chance will break the affect early if not hit right
		battleEffects = [],
		image = buffImages.Heal,
		timeToWait = [1], #affect happens every turn/tick
		timeModifier = [0], #can cause the affect to happen earlier or later, randomness
		timeLeft = [5], #affect ends after this many turns
		timePersistence = [2], #buff will last this long before it can be removed by chance
		timeGrowth = [[0, 0]] #[amount to grow, chance to grow]
	},

	confused = {
		name = "Confused",
		hpDamage = 0,
		manaDamage = 0,
		APDamage = 0,
		specialEffects = [],
		battleEffects = [["oppositeTarget",80]],
		image = buffImages.Confused,
		timeToWait = [1],
		timeModifier = [1],
		timeLeft = [7],
		timePersistence = [3],
		timeGrowth = [[1, 20]]
	},

	stunned = {
		name = "Stunned",
		hpDamage = 0,
		manaDamage = 0,
		APDamage = 0,
		specialEffects = [],
		battleEffects = [["noAttack", 80]],
		image = buffImages.Confused,
		timeToWait = [1],
		timeModifier = [0],
		timeLeft = [7],
		timePersistence = [3],
		timeGrowth = [[1, 20]]
	},
}
