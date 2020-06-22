class_name Items
const script_name := "items"

const items := {

	sword = {
		nickname = "Short Sword",
		name = "sword",
		broadType = "weapons",
		type = "melee",
		subType = "one-handed sword",
		tags = [],
		buffs = {
			strength = 2,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 0,
			luck = 0,
			melee = 10,
			mana = 0,
			defense = 0
		},
		level = 1,
		level_requirement = 1,
		quantity = 1,
	},

	staff = {
		nickname = "Small Staff",
		name = "staff",
		broadType = "weapons",
		type = "magic",
		subType = "one-handed staff",
		tags = [],
		buffs = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 2,
			agility = 0,
			luck = 0,
			melee = 0,
			mana = 10,
			defense = 0
		},
		level = 1,
		level_requirement = 1,
		quantity = 1,
	},

	axe = {
		nickname = "Battle Axe",
		name = "axe",
		broadType = "weapons",
		type = "melee",
		subType = "two-handed axe",
		tags = [],
		buffs = {
			strength = 3,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = -1,
			luck = 0,
			melee = 20,
			mana = 0,
			defense = 0
		},
		level = 1,
		level_requirement = 1,
		quantity = 1,
	},

	bow = {
		nickname = "Hunting bow",
		name = "bow",
		broadType = "weapons",
		type = "ranged",
		subType = "hunting bow",
		tags = [],
		buffs = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 2,
			luck = 0,
			melee = 0,
			mana = 0,
			defense = 0
		},
		level = 1,
		level_requirement = 1,
		quantity = 1,
	},

	arrow = {
		nickname = "Arrow",
		name = "arrow",
		broadType = "weapons",
		type = "consumables",
		subType = "arrow",
		tags = [],
		buffs = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 0,
			luck = 1,
			melee = 4,
			mana = 0,
			defense = 0
		},
		level = 1,
		level_requirement = 1,
		quantity = 1,
	},

	dagger = {
		nickname = "Dagger",
		name = "dagger",
		broadType = "weapons",
		type = "melee",
		subType = "dagger",
		tags = [],
		buffs = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 0,
			luck = 1,
			melee = 5,
			mana = 0,
			defense = 0
		},
		level = 1,
		level_requirement = 1,
		quantity = 1,
	}
}
