class_name Item
const script_name := "item"

var broadType = ""
var type = ""
var name = ""
var typeStat = 0
var buffs = {"Strength":0, "Perception":0, "Endurance":0, "Charisma":0, "Intelligence":0, "Agility":0, "Luck":0}
var levelRequirement = 1
var subType = "None"

func text():
	return "broadType: " + broadType + " type: " + type + " name: " + name + " buffs: " + str(buffs) + " levelRequirement: " + str(levelRequirement)
