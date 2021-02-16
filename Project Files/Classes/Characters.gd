class_name Characters
const script_name := "character_defaults"

const zero_stats = {
	strength = 0,
	perception = 0,
	endurance = 0,
	charisma = 0,
	intelligence = 0,
	agility = 0,
	luck = 0,
	melee = 0,
	mana = 0,
	defense = 0
}

const starting_equipment := {
	knight = [
		{
			name = "sword_short_iron",
			quantity = 1
		}
	],
	battle_mage = [
		{
		name = "staff_small",
		quantity = 1
		}
	],
	berserker = [
		{
		name = "axe_battle",
		quantity = 1
		}
	],
	quick_shooter = [ 
		{
			name = "bow_hunting",
			quantity = 1,
		},
		{
			name = "arrow_wooden",
			quantity = 15,
		},
		{
			name = "dagger_iron",
			quantity = 1,
		},
	],
	dev = [
		{
			name = "sword_short_iron",
			quantity = 1
		},
		{
		name = "staff_small",
		quantity = 1
		},
		{
		name = "axe_battle",
		quantity = 1
		},
		{
			name = "bow_hunting",
			quantity = 1,
		},
		{
			name = "arrow_wooden",
			quantity = 150,
		},
		{
			name = "dagger_iron",
			quantity = 1,
		},
	],
	death_hound = []
}

const starting_attacks := {
	knight = {
		melee = ["strike", "punch"],
		ranged = [],
		mana = [],
	},
	battle_mage = {
		melee = ["punch"],
		ranged = [],
		mana = ["flame"],
	},
	berserker = {
		melee = ["strike", "punch", "punch_double"],
		ranged = [],
		mana = [],
	},
	quick_shooter = {
		melee = ["strike", "punch", "punch_double"],
		ranged = ["quick_shot"],
		mana = [],
	},
	dev = {
		melee = ["strike", "punch", "punch_double"],
		mana = ["flame"],
		ranged = ["quick_shot"],
	},
	death_hound = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Human = {
		melee = [],
		ranged = [],
		mana = [],
	},
	HalfElf = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Elf = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Fairies = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Dwarf = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Demon = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Vampire = {
		melee = [],
		ranged = [],
		mana = [],
	},
}

const starting_abilities := {
	knight = {
		melee = ["stun_weak"],
		ranged = [],
		mana = [],
	},
	battle_mage = {
		melee = [],
		ranged = [],
		mana = ["heal_weak"],
	},
	berserker = {
		melee = ["stun_medium"],
		ranged = [],
		mana = [],
	},
	quick_shooter = {
		melee = [""],
		ranged = ["distract_arrow"],
		mana = [],
	},
	dev = {
		melee = ["stun_weak", "stun_medium"],
		mana = ["distract_arrow"],
		ranged = ["heal_weak"],
	},
	death_hound = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Human = {
		melee = [],
		ranged = [],
		mana = [],
	},
	HalfElf = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Elf = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Fairies = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Dwarf = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Demon = {
		melee = [],
		ranged = [],
		mana = [],
	},
	Vampire = {
		melee = [],
		ranged = [],
		mana = [],
	},
}

const flip_profile := {
	"res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png": [true, false],
	"res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_17.png": [false, false],
	"res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png": [false, false],
	"res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_51.png": [false, false],
	"res://Assets/Images/Profiles/Enemies/MonstersAvatarIcons_61.PNG": [false, false]
}
const racialModifiers := {
	#realStats = stats*racialModifier+equipbuffs
	Blank = {
		strength = 1,
		perception = 1,
		endurance = 1,
		charisma = 1,
		intelligence = 1,
		agility = 1,
		luck = 1,
		mana = 1
	},
	Human = {
		strength = 1.5,
		perception = 1,
		endurance = 1.5,
		charisma = 1,
		intelligence = 0.75,
		agility = 1,
		luck = 1,
		mana = 1
	},
	HalfElf = {
		strength = 1,
		perception = 1,
		endurance = 1.25,
		charisma = 1.5,
		intelligence = 1.25,
		agility = 1,
		luck = 1,
		mana = 1.5
	},
	Elf = {
		strength = 0.75,
		perception = 1,
		endurance = 1.25,
		charisma = 1,
		intelligence = 2,
		agility = 1.5,
		luck = 1,
		mana = 1.5
	},
	Fairies = {
		strength = 0.5,
		perception = 1,
		endurance = 0.75,
		charisma = 1,
		intelligence = 2,
		agility = 2,
		luck = 1.5,
		mana = 1.25
	},
	Dwarf = {
		strength = 1.5,
		perception = 1,
		endurance = 1,
		charisma = 1.5,
		intelligence = 1,
		agility = 0.75,
		luck = 1,
		mana = 1
	},
	Demon = {
		strength = 1.5,
		perception = 1,
		endurance = 1.5,
		charisma = 0.75,
		intelligence = 1.5,
		agility = 1,
		luck = 0.75,
		mana = 1.25
	},
	VampireDay = {
		strength = 1.5,
		perception = 1,
		endurance = 1.25,
		charisma = 2,
		intelligence = 1,
		agility = 0.75,
		luck = 0.75,
		mana = 0.75
	},
	VampireNight = {
		strength = 2,
		perception = 1.5,
		endurance = 1.25,
		charisma = 2,
		intelligence = 1,
		agility = .5,
		luck = 1,
		mana = 1.5
	},
	deathHound = {
		strength = 1.5,
		perception = 1.5,
		endurance = 1.25,
		charisma = .5,
		intelligence = 1,
		agility = 2,
		luck = 0.75,
		mana = 0
	},
}

const characters := {                             

	blank = {
		name = "",
		info = "",
		kills = 0,
		timeCreated = "",
		classType = "PLAYER",
		gender = "",
		stats = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 0,
			luck = 0
		},
		racialModifier = racialModifiers.Blank,
		#[[name, {stats}]]
		subRaces = [],
		buffs = [],
		equipBuffs = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 0,
			luck = 0,
			melee = 0,
			mana = 0,
			defense = 0
		},
		levelBuffs = zero_stats,
		picture = {
			path = "",
			border = {
				path = "res://Assets/Images/Profiles/ImageBorder.png",
				shown = true,
			},
			flip_profile = [false, false]
		},
		level = 1,
		attacks = {
			melee = [],
			ranged = [],
			mana = [],
			lowestCost = 1000000000000
		},
		abilities = {
			melee = [],
			ranged = [],
			mana = [],
			lowestCost = 1000000000000},
		skills = {},
		
		AP = {
			max = 2,
			current = 2,
			speed = 0.5,
			ticks = 0, # used in buff calculation for how many turns have passed
			turnCount = 0
		},
		health = {
			max = 100,
			current = 100,
			speed = 0
		},
		mana = {
			max = 100,
			current = 100,
			speed = 0
		},
		equipment = {
			armour = {
				head = -1,
				torso = -1,
				arms = -1, 
				legs = -1,
				feet = -1,
				shield = -1
			},
			weapons = {
				melee = -1, 
				ranged = -1,
				consumables = -1, 
				magic = -1
			},
			other = []
		},
		inventory = {
			armour = {
				head = [],
				torso = [],
				arms = [], 
				legs = [],
				feet = [],
				shield = []
			},
			weapons = {
				melee = [], 
				ranged = [],
				consumables = [], 
				magic = []
			},
			other = []
		}
	},
	
	alrune = {
		name = "Alrune",
		info = "",
		kills = 0,
		timeCreated = "1592139824",
		classType = "PLAYER",
		gender = "",
		stats = {
			strength = 3,
			perception = 3,
			endurance = 3,
			charisma = 3,
			intelligence = 3,
			agility = 3,
			luck = 3
		},
		racialModifier = racialModifiers.Human,
		#[[name, {stats}]]
		subRaces = [],
		buffs = [],
		equipBuffs = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 0,
			luck = 0,
			melee = 0,
			mana = 0,
			defense = 0
		},
		levelBuffs = zero_stats,
		picture = {
			path = "res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png",
			border = {
				path = "res://Assets/Images/Profiles/ImageBorder.png",
				shown = true,
			},
			flip_profile = [false, false]
		},
		level = 1,
		attacks = {
			melee = ["punch"],
			ranged = [],
			mana = [],
			lowestCost = 0.5
		},
		abilities = {
			melee = ["stun_weak"],
			ranged = ["distract_arrow"],
			mana = ["heal_weak"],
			lowestCost = 0.5},
		skills = {},
		AP = {
			max = 2,
			current = 2,
			speed = 0.5,
			ticks = 0,
			turnCount = 0
		},
		health = {
			max = 100,
			current = 100,
			speed = 0
		},
		mana = {
			max = 100,
			current = 100,
			speed = 0
		},
		equipment = {
			armour = {
				head = -1,
				torso = -1,
				arms = -1, 
				legs = -1,
				feet = -1,
				shield = -1
			},
			weapons = {
				melee = -1, 
				ranged = -1,
				consumables = [], 
				magic = -1
			},
			other = []
		},
		
		inventory = {
			armour = {
				head = [],
				torso = [],
				arms = [], 
				legs = [],
				feet = [],
				shield = []
			},
			weapons = {
				melee = [], 
				ranged = [],
				consumables = [], 
				magic = []
			},
			other = []
		}
	},
	
	death_hound = {
		name = "Death Hound",
		info = "",
		kills = 0,
		classType = "Death Hound",
		stats = {
			strength = 3,
			perception = 3,
			endurance = 3,
			charisma = 3,
			intelligence = 3,
			agility = 3,
			luck = 3
		},
		racialModifier = racialModifiers.Blank,
		#[[name, {stats}]]
		subRaces = [],
		buffs = [],
		equipBuffs = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 0,
			luck = 0,
			melee = 0,
			mana = 0,
			defense = 0
		},
		levelBuffs = zero_stats,
		picture = {
			path = "res://Assets/Images/Profiles/Enemies/MonstersAvatarIcons_61.PNG",
			border = {
				shown = false,
			},
			flip_profile = [false, false]
		},
		level = 1,
		attacks = {
			melee = ["bite"],
			ranged = [],
			mana = [],
			lowestCost = 1.5
		},
		abilities = {
			melee = [],
			ranged = [],
			mana = [],
			lowestCost = 0.5},
		skills = {},
		AP = {
			max = 2,
			current = 2,
			speed = 0.5,
			ticks = 0,
			turnCount = 0
		},
		health = {
			max = 50,
			current = 50,
			speed = 0
		},
		mana = {
			max = 0,
			current = 0,
			speed = 0
		},
		equipment = {
			armour = {
				head = -1,
				torso = -1,
				arms = -1, 
				legs = -1,
				feet = -1,
				shield = -1
			},
			weapons = {
				melee = -1, 
				ranged = -1,
				consumables = -1, 
				magic = -1
			},
			other = []
		},
		inventory = {
			armour = {
				head = [],
				torso = [],
				arms = [], 
				legs = [],
				feet = [],
				shield = []
			},
			weapons = {
				melee = [], 
				ranged = [],
				consumables = [], 
				magic = []
			},
			other = []
		}
	}
}
