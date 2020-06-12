class_name Item

var broadType = ""
var type = ""
var name = ""
var typeStat = 0
var buffs = {"Strength":0, "Perception":0, "Endurance":0, "Charisma":0, "Intelligence":0, "Agility":0, "Luck":0}
var levelRequirement = 1
var subType = "None"

func _init(new_broadType:String, new_type:String, new_subType:String, new_name:String, new_buffs:Array, new_levelRequirement:int):
	broadType = new_broadType
	type = new_type
	subType = new_subType
	name = new_name
	buffs = {"Strength":new_buffs[0], "Perception":new_buffs[1], "Endurance":new_buffs[2], "Charisma":new_buffs[3], "Intelligence":new_buffs[4], "Agility":new_buffs[5], "Luck":new_buffs[6], "MeleeAttack":new_buffs[7], "ManaAttack":new_buffs[8],  "Defense":new_buffs[9]}
	levelRequirement = levelRequirement

## Compare with another item
func isTheSameAs(item2:Item):
	return (self.type == item2.type && self.name == item2.name && self.buffs == item2.buffs && self.levelRequirement == item2.levelRequirement)

func text():
	return "broadType: " + broadType + " type: " + type + " name: " + name + " buffs: " + str(buffs) + " levelRequirement: " + str(levelRequirement)
## Armor/weapon, class, subType, name, (typestat bonus, eg weapon: damage, armor: def)[0,0,0,0,0,0,0], levelNeeded
