class_name CharacterManager
const script_name := "character_manager"

static func create(character_name: String):
	return DictionaryFunc.clone_dict(Characters.characters[character_name])

static func load_class(character_data: Dictionary, character_class: String):
	var debug = 0
	# Add equipment to the character inventory and equip those items
	if Characters.starting_equipment.keys().has(character_class):
		for item in Characters.starting_equipment[character_class]:
			add(character_data, Items.items[item.name], item.quantity)
			var status = equip(character_data, Items.items[item.name])
	else:
		debug +=1
	var attackList
	# Add character attacks
	for mode in ["attacks", "abilities"]:
		if mode == "attacks":
			attackList = Characters.starting_attacks
		elif mode == "abilities":
			attackList = Characters.starting_abilities
			
		if attackList.keys().has(character_class):
			for attack_type in attackList[character_class].keys():
				for attack_name in attackList[character_class][attack_type]:
					learn_attack(character_data, mode, attack_type, attack_name)
		else:
			debug +=2
	if debug == 1:
		Core.emit_signal('msg', character_class + " starting equipment class doesn't exist", Log.WARN, "load_class")
	if debug == 4:
		Core.emit_signal('msg', character_class + " starting attacks class doesn't exist", Log.WARN, "load_class")
	if debug == 5:
		Core.emit_signal('msg', character_class + " starting class doesn't exist", Log.WARN, "load_class")
	return character_data

static func learn_attack(character_data: Dictionary, mode: String, attack_type: String, attack_name: String):
	var debug = 0
	var attackLibrary
	if mode == "attacks":
		attackLibrary = Attacks[attack_type]
	elif mode == "abilities":
		attackLibrary = Abilities[attack_type]
	if attackLibrary.has(attack_name):
		if !character_data[mode][attack_type].has(attack_name):
			character_data[mode][attack_type].append(attack_name)
			if attackLibrary[attack_name].APcost < character_data[mode].lowestCost:
				character_data[mode].lowestCost = attackLibrary[attack_name].APcost
		else:
			Core.emit_signal('msg', "Attack learner: " + mode + " already known", Log.WARN, "learn_attack")
	else:
		Core.emit_signal('msg', "Attack learner: " + mode + " not found", Log.WARN, "learn_attack")

static func calcuate_stats(character_data):
	var racialStats = character_data.racialModifier
	for race in character_data.subRaces:
		DictionaryFunc.add_dict(racialStats, race[1])
	var stats1 = DictionaryFunc.add_dict(character_data.stats, character_data.levelBuffs)
	var stats2 = DictionaryFunc.multiply_dict(stats1, racialStats)
	return DictionaryFunc.add_dict(stats2, character_data.equipBuffs)

static func add(character_data: Dictionary, item_data: Dictionary, quantity:=1):
	return InventoryManager.add(character_data.inventory, item_data, quantity)

static func remove(character_data: Dictionary, item_data: Dictionary, quantity:=1):
	return InventoryManager.remove(character_data.inventory, item_data, quantity)

static func equip(character_data: Dictionary, item:Dictionary):
	if InventoryManager.check(character_data.inventory, item, 1)[0]:
		if character_data.equipment[item.broadType][item.type] == -1:
			if item.broadType == "weapons":
				if "two-hand" in item.subType:
					if item.type == "melee" && character_data.equipment.weapons.magic != -1:
						Core.emit_signal('msg', "Equip manager: Dual handed weapon, magic cannot be equipped too", Log.WARN, "equip_func")
						return [false, "Dual handed weapon, magic cannot be equipped too"]
					elif item.type == "magic" && character_data.equipment.weapons.melee != -1:
						Core.emit_signal('msg', "Equip manager: Dual handed weapon, melee cannot be equipped too", Log.WARN, "equip_func")
						return [false, "Dual handed weapon, melee cannot be equipped too"]
				if character_data.equipment.weapons.melee != -1:
					if "two-hand" in  character_data.inventory.weapons.melee[character_data.equipment.weapons.melee].subType:
						Core.emit_signal('msg', "Equip manager: Dual handed weapon equipped, no new weapons can be equipped", Log.WARN, "equip_func")
						return [false, "Dual handed weapon, Dual handed weapon equipped"]
				if character_data.equipment.weapons.magic != -1:
					if "two-hand" in  character_data.inventory.weapons.magic[character_data.equipment.weapons.magic].subType:
						Core.emit_signal('msg', "Equip manager: Dual handed weapon equipped, no new weapons can be equipped", Log.WARN, "equip_func")
						return [false, "Dual handed weapon, Dual handed weapon equipped"]
			if item.levelRequirement <= character_data.level:
				character_data.equipment[item.broadType][item.type] = InventoryManager.check(character_data.inventory, item, 1)[1]
				for buffKey in item.buffs.keys():
					character_data.equipBuffs[buffKey] += item.buffs[buffKey]
				Core.emit_signal('msg', "Equip manager: Success", Log.TRACE, "equip_func")
				return [true, "Done"]
			else:
				Core.emit_signal('msg', "Equip manager: Level Requirement Not Met", Log.WARN, "equip_func")
				return [false, "Level Requirement Not Met"]
		else:
			Core.emit_signal('msg', "Equip manager: All ready equipped item present", Log.WARN, "equip_func")
			return [false, "All ready equipped item present"]
	else:
		Core.emit_signal('msg', "Equip manager: Doesn't Exist", Log.WARN, "equip_func")
		return [false, "Doesn't Exist"]

static func unequip(character_data: Dictionary, item:Dictionary):
	if InventoryManager.check(character_data.inventory, item, 1)[0]:
		if character_data.equipment[item.broadType][item.type] == InventoryManager.check(character_data.inventory, item, 1)[1]:
			character_data.equipment[item.broadType][item.type] = -1
			for buffKey in item.buffs.keys():
				character_data.equipBuffs[buffKey] -= item.buffs[buffKey]
			return [true, "Done"]
		else:
			Core.emit_signal('msg', "UnEquip manager: Doesn't Exist", Log.WARN, "unequip_func")
			return [false, "Doesn't Exist"]

static func set_level(character_data: Dictionary, level: int):
	character_data.level = level
	process_level_buffs(character_data)

static func process_level_buffs(character_data: Dictionary):
	var temp_level = character_data.level
	var count = 1
	var levelBuffs = Characters.zero_stats
	match character_data.classType:
		"Death Hound":
			while temp_level >= 5:
				levelBuffs.strength += 1
				levelBuffs.intelligence += 1
				levelBuffs.agility +=1
				levelBuffs.luck += 1
				
				if count%3==0:
					levelBuffs.perception += 1
					levelBuffs.endurance += 1
					levelBuffs.charisma += 1
				count+=1
				temp_level-=5
	character_data.levelBuffs = levelBuffs

static func addBuff(character_data: Dictionary, buffName: String):
	if Abilities.buffs.has(buffName):
		for buff in character_data.buffs:
			#Extend if exists
			if buff.name == Abilities.buffs[buffName].name:
				var count = 0
				for num in buff.timeLeft: 
					buff.timeLeft[count] += Abilities.buffs[buffName].timeLeft[count]
				Core.emit_signal('msg', "Buff manager: Buff extended on " + character_data.name, Log.TRACE, "addBuff_func")
				return [true, "Extended"]
		#Doesn't exist
		var buff = DictionaryFunc.clone_dict(Abilities.buffs[buffName])
		buff.lastTimeCalculated = []
		for buffType in ["specialEffects", "battleEffects"]:
			for effect in buff[buffType]:
				buff.lastTimeCalculated.append(character_data.AP.ticks)
		buff.lastTimeActivated = buff.lastTimeCalculated
		buff.nextTimeActivated = buff.lastTimeCalculated
		character_data.buffs.append(buff)
		Core.emit_signal('msg', "Buff manager: Buff added to " + character_data.name, Log.TRACE, "addBuff_func")
		return [true, "Done"]
	else:
		Core.emit_signal('msg', "Buff manager: Doesn't Exist: " + buffName, Log.WARN, "addBuff_func")
		return [false, "Doesn't Exist"]

static func checkBuffs(character_data: Dictionary, buffType: String):
	Core.emit_signal('msg', "Buff manager: Check buffs on " + character_data.name, Log.TRACE, "checkBuffs_func")
	var triggered = []
	for buff in character_data.buffs:
		var buffsRemaining = buff.battleEffects.size()+buff.specialEffects.size()
		var index = 0
		var count = 0
		var announced = false
		if buffType == "battleEffects":
			index = buff.specialEffects.size()-1
		if index < 0:
			index = 0
		var removeBuff = false
		for effect in buff[buffType]:
			#Core.emit_signal('msg', '        timepersistence part 1 ' + str(buff.timePersistence[index]) + ', ' + str(character_data.AP.ticks - buff.lastTimeCalculated[index]) + ", " + str(character_data.AP.ticks) + ", " + str(buff.lastTimeCalculated[index]), Log.DEBUG, "checkBuffs")
			#Check if buff is recovered
			if buffType == "battleEffects":
				buff.timeLeft[index] -= (character_data.AP.ticks - buff.lastTimeCalculated[index])
				buff.timePersistence[index] -= (character_data.AP.ticks - buff.lastTimeCalculated[index])
				buff.lastTimeCalculated[index] = character_data.AP.ticks
			else:
				buff.timeLeft[index] -= (character_data.AP.turnCount - buff.lastTimeCalculated[index])
				buff.timePersistence[index] -= (character_data.AP.turnCount - buff.lastTimeCalculated[index])
				buff.lastTimeCalculated[index] = character_data.AP.turnCount
			#Core.emit_signal('msg', '        timepersistence part 2 ' + str(buff.timePersistence[index]) + ', ' + str(character_data.AP.turnCount - buff.lastTimeCalculated[index]) + ", " + str(character_data.AP.turnCount) + ", " + str(buff.lastTimeCalculated[index]), Log.DEBUG, "checkBuffs")
			if buff.timeLeft[index] <= 0:
				buffsRemaining-=1
			else:
				#Grow buff duration if needed
				if buff.timeGrowth[index][1] > 0:
					if randi()%100+1 <= buff.timeGrowth[index][1]:
						buff.timeLeft[index] += buff.timeGrowth[index][0]
				#calculate when next attack should happen if not calculated
				if buff.nextTimeActivated[index] <= buff.lastTimeActivated[index]:
					#converts a modifier of x to a random value between -x and x
					var nextModifier = (randi() % (buff.timeModifier[index]*2+1)) - buff.timeModifier[index]
					buff.nextTimeActivated[index] = buff.lastTimeActivated[index] + nextModifier
				if buff.nextTimeActivated[index] <= character_data.AP.ticks:
					if buffType == "specialEffects":
						if randi()%100+1 <= effect[1]:
							buff.lastTimeActivated[index] = character_data.AP.turnCount
							if count == 0:
								announced = true
								Core.emit_signal('msg', '    -' + character_data.name + ' is ' + buff.name, Log.BATTLE, "checkBuffs")
							if buff.hpDamage != 0:
								character_data.health.current -= buff.hpDamage
								if character_data.health.current < 0:
									character_data.health.current=0
									Core.emit_signal('msg', '        -' + character_data.name + ' has died!', Log.BATTLE, "checkBuffs")
								elif buff.hpDamage > 0:
									Core.emit_signal('msg', '        -' + character_data.name + ' takes ' + str(buff.hpDamage) + ' HP damage!', Log.BATTLE, "checkBuffs")
								if buff.hpDamage < 0:
									Core.emit_signal('msg', '        -' + character_data.name + ' is healed by ' + str(-buff.hpDamage) + ' HP!', Log.BATTLE, "checkBuffs")
							character_data.mana.current -= buff.manaDamage
							if character_data.mana.current < 0:
								character_data.mana.current=0
							character_data.AP.current -= buff.APDamage
							if character_data.AP.current < 0:
								character_data.AP.current=0
							count +=1
						else:
							var defaultTimeLeft = buff.timeLeft[index]
							for defaultBuffKey in Abilities.buffs.keys():
								if buff.name == Abilities.buffs[defaultBuffKey].name:
									defaultTimeLeft = Abilities.buffs[defaultBuffKey].timeLeft[index]
							if buff.timeLeft[index] > defaultTimeLeft:
								buff.timeLeft[index] -=defaultTimeLeft
							elif buff.timePersistence[index] <= 0:
								buff.timeLeft[index] = 0
								buffsRemaining-=1
					else:
						if buff.timeLeft[index] > 0:
							if randi()%100+1 <= effect[1]:
								buff.lastTimeActivated[index] = character_data.AP.ticks
								if count == 0:
									announced = true
									Core.emit_signal('msg', '    -' + character_data.name + ' is ' + buff.name, Log.BATTLE, "checkBuffs")
								if !triggered.has(effect[0]):
									triggered.append(effect[0])
								count +=1
							else:
								var defaultTimeLeft = buff.timeLeft[index]
								for defaultBuffKey in Abilities.buffs.keys():
									if buff.name == Abilities.buffs[defaultBuffKey].name:
										defaultTimeLeft = Abilities.buffs[defaultBuffKey].timeLeft[index]
								if buff.timeLeft[index] > defaultTimeLeft:
									buff.timeLeft[index] -=defaultTimeLeft
								elif buff.timePersistence[index] <= 0:
									buff.timeLeft[index] = 0
									buffsRemaining-=1
					buff.lastTimeActivated[index] = character_data.AP.ticks
			index +=1
		if count == 0 and announced:
			Core.emit_signal('msg', '        -Nothing Happened', Log.BATTLE, "checkBuffs")
		elif count == 0 and index > 0 and buffsRemaining > 0:
			announced = true
			Core.emit_signal('msg', '    -' + character_data.name + ' is ' + buff.name, Log.BATTLE, "checkBuffs")
			Core.emit_signal('msg', '        -Nothing Happened', Log.BATTLE, "checkBuffs")
		if buffsRemaining == 0:
			character_data.buffs.remove(character_data.buffs.find(buff))
			Core.emit_signal('msg', '    -' + character_data.name + ' is no longer ' + buff.name, Log.BATTLE, "checkBuffs")
	return triggered







