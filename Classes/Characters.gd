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
	knight = [ {
			name = "sword",
			quantity = 1
	} ],
	battle_mage = [ {
		name = "staff",
		quantity = 1
	} ],
	berserker = [ {
		name = "axe",
		quantity = 1
	} ],
	quick_shooter = [ 
		{
			name = "bow",
			quantity = 1,
		},
		{
			name = "arrow",
			quantity = 15,
		},
		{
			name = "dagger",
			quantity = 1,
		},
	],
	death_hound = []
}




const starting_attacks := {
	knight = {
		melee = ["strike"],
		ranged = [],
		mana = [],
	},
	battle_mage = {
		melee = [],
		ranged = [],
		mana = ["flame"],
	},
	berserker = {
		melee = ["strike"],
		ranged = [],
		mana = [],
	},
	quick_shooter = {
		melee = ["strike"],
		ranged = ["quick_shot"],
		mana = [],
	},
	death_hound = {
		melee = [],
		ranged = [],
		mana = [],
	}
}

const flip_profile := {
	"res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_01.png": [true, false],
	"res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_17.png": [false, false],
	"res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_28.png": [false, false],
	"res://Assets/Images/Profiles/Friendlies/Tex_AnimeAva_51.png": [false, false],
	"res://Assets/Images/Profiles/Enemies/MonstersAvatarIcons_61.PNG": [false, false]
}

const characters := {                             

	alrune = {
		name = "Alrune",
		info = "",
		kills = 0,
		timeCreated = "1592139824",
		classType = "PLAYER",
		stats = {
			strength = 3,
			perception = 3,
			endurance = 3,
			charisma = 3,
			intelligence = 3,
			agility = 3,
			luck = 3
		},
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
		skills = {},
		AP = {
			max = 2,
			current = 2,
			speed = 0.5
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
	blank = {
		name = "",
		info = "",
		kills = 0,
		timeCreated = "",
		classType = "PLAYER",
		stats = {
			strength = 0,
			perception = 0,
			endurance = 0,
			charisma = 0,
			intelligence = 0,
			agility = 0,
			luck = 0
		},
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
		skills = {},
		
		AP = {
			max = 2,
			current = 2,
			speed = 0.5
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
		skills = {},
		AP = {
			max = 2,
			current = 2,
			speed = 0.5
		},
		health = {
			max = 100,
			current = 100,
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
