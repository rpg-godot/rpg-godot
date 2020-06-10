class_name Attacks
const script_name := "attacks"




#### melee attacks #############################################################
#                 _                   _   _             _        
#                | |                 | | | |           | |       
#  _ __ ___   ___| | ___  ___    __ _| |_| |_ __ _  ___| | _____ 
# | '_ ` _ \ / _ \ |/ _ \/ _ \  / _` | __| __/ _` |/ __| |/ / __|
# | | | | | |  __/ |  __/  __/ | (_| | |_| || (_| | (__|   <\__ \
# |_| |_| |_|\___|_|\___|\___|  \__,_|\__|\__\__,_|\___|_|\_\___/
#                                                                
#                                                                

const melee_attacks := {
	
	
	
	
	punch = {
		name = "Punch", 
		hp_damage = 5, 
		mana_damage = 0, 
		ap_cost = 0.5,
		target = true, 
		image = "Fists Attack.png",
		weapon = [
			"none"
		], 
		item_level = 1
	},
	
	
	
	
	scratch = {
		name = "Scratch",
		hp_damage = 10,
		mana_damage = 0,
		ap_cost = 1, 
		target = true, 
		image = "Claws Attack.png",
		weapon = [
			"none"
		],
	},
	
	
	
	
	bite = {
		name = "Bite",
		hp_damage = 15,
		mana_damage = 0,
		ap_cost = 1.5,
		target = true,
		image = "Teeth Attack.png",
		weapon = [
			"none"
		], 
		item_level = 1,
	},
	
	
	
	
	strike = {
		name = "Strike",
		hp_damage = 25,
		mana_damage = 0,
		ap_cost = 1, 
		target = true, 
		image = "Sword Attack.png", 
		weapon = [
			"one-handed sword", 
			"two-handed swords", 
			"two-handed axe"
		], 
		item_level = 1
	}
	
	
	
	
}




#### ranged attacks ############################################################
#                                 _         _   _             _        
#                                 | |       | | | |           | |       
#   _ __ __ _ _ __   __ _  ___  __| |   __ _| |_| |_ __ _  ___| | _____ 
#  | '__/ _` | '_ \ / _` |/ _ \/ _` |  / _` | __| __/ _` |/ __| |/ / __|
#  | | | (_| | | | | (_| |  __/ (_| | | (_| | |_| || (_| | (__|   <\__ \
#  |_|  \__,_|_| |_|\__, |\___|\__,_|  \__,_|\__|\__\__,_|\___|_|\_\___/
#                    __/ |                                              
#                   |___/                                               

const ranged_attacks := {
	
	
	
	
	quick_shot = {
		name = "Quick Shot",
		hp_damage = 20,
		manaDamage = 0,
		ap_cost = 1,
		target = true, 
		image = "Bow Attack.png",
		ammo_cost = 1,
		weapon = [
			["bow", "hunting bow"],
			["arrow"]
		],
		item_level = 1,
		arrow_level = 1
	},
	
	
	
	
	percision_shot = {
		name = "Percision Shot",
		hp_damage = 40, 
		mana_damage = 0,
		ap_cost = 2, 
		target = true,
		image = "Bow Attack.png",
		ammo_cost = 1,
		weapon = [
			["bow", "hunting bow"], 
			["arrow"]
		],
		item_level = 2,
		arrow_level = 1
	}
	
	
	
	
}




#### mana attacks ##############################################################
#                                       _   _             _        
#                                      | | | |           | |       
#   _ __ ___   __ _ _ __   __ _    __ _| |_| |_ __ _  ___| | _____ 
#  | '_ ` _ \ / _` | '_ \ / _` |  / _` | __| __/ _` |/ __| |/ / __|
#  | | | | | | (_| | | | | (_| | | (_| | |_| || (_| | (__|   <\__ \
#  |_| |_| |_|\__,_|_| |_|\__,_|  \__,_|\__|\__\__,_|\___|_|\_\___/
#                                                                  
#                                                                  

const mana_attacks := {
	
	
	
	
	flame = {
		name = "Flame",
		hp_damage = 25,
		mana_damage = 5,
		ap_cost = 1,
		mana_cost = 20,
		target = true,
		image = "Fire-Small Attack.png",
		weapon = [
			"staff"
		],
		item_level = 1
	}
	
	
	
	
}
