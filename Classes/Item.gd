class_name Item

var broadType = ""
var type = ""
var name = ""
var typeStat = 0
var buffs = {"strength":0, "perception":0, "endurance":0, "charisma":0, "intelligence":0, "agility":0, "luck":0, "melee_attack":0, "mana_attack":0,  "defense":0}
var levelRequirement = 1
var subType = "None"

func _init(new_broadType:String, new_type:String, new_subType:String, new_name:String, new_buffs:Dictionary, new_levelRequirement:int):
	broadType = new_broadType
	type = new_type
	subType = new_subType
	name = new_name
	DictonaryFunc.merge_dict(buffs, new_buffs)
	levelRequirement = levelRequirement

## Compare with another item
func isTheSameAs(item2:Item):
	return (self.type == item2.type && self.name == item2.name && self.buffs == item2.buffs && self.levelRequirement == item2.levelRequirement)

func text():
	return "broadType: " + broadType + " type: " + type + " name: " + name + " buffs: " + str(buffs) + " levelRequirement: " + str(levelRequirement)
## Armor/weapon, class, subType, name, (typestat bonus, eg weapon: damage, armor: def)[0,0,0,0,0,0,0], levelNeeded
