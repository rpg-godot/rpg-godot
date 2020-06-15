class_name InventoryManager

static func add(inventory: Dictionary, item: Dictionary, quantity:=1):
	Core.emit_signal("msg", "Adding item " + item.name + str(quantity) + " times...", Log.WARN, "inventory_manager")
	item.quantity = quantity
	if quantity > 0:
		if item.broadType != "other":
			if check(inventory, item, 1)[0]:
				inventory[item.broadType][item.type][check(inventory, item, 1)[1]].quantity += quantity
			else:
				inventory[item.broadType][item.type].append(item)
		if item.broadType == "other":
			if check(inventory, item, 1)[0]:
				inventory[item.broadType][check(inventory, item, 1)[1]].quantity += quantity
			else:
				inventory[item.broadType].append([item, quantity])
		return [true, "Done"]
	else:
		return [false, "Quantity Error"]

static func remove(inventory: Dictionary, item: Dictionary, quantity:=1):
	Core.emit_signal("msg", "Removing item " + item.name + " " + str(quantity) + " times...", Log.WARN, "inventory_manager")
	if quantity > 0:
		if item.broadType != "other":
			if check(inventory, item, quantity)[0]:
				inventory[item.broadType][item.type][check(inventory, item, 1)[1]].quantity -= quantity
				if inventory[item.broadType][item.type][check(inventory, item, 0)[1]].quantity == 0:
					inventory[item.broadType][item.type].remove(check(inventory, item, 0)[1])
				return [true, "Done"]
			else:
				return [false, "Doesn't Exist"]
		if item.broadType == "other":
			if check(inventory, item, quantity)[0]:
				inventory[item.broadType][check(inventory, item, 1)[1]].quantity -= quantity
				if inventory[item.broadType][check(inventory, item, 1)[1]].quantity == 0:
					inventory[item.broadType].remove(check(inventory, item, 1)[1])
				return [true, "Done"]
			else:
				return [false, "Doesn't Exist"]
	else:
		return [false, "Quantity Error"]

static func check(inventory: Dictionary, item: Dictionary, quantity:int):
	var done = false
	if item.broadType != "other":
		for item2 in inventory[item.broadType][item.type]:
			if itemIsTheSameAs(item, item2) && item2.quantity >= quantity:
				return [true, inventory[item.broadType][item.type].find(item2)]
	elif item.broadType == "other":
		for item2 in inventory[item.broadType]:
			if itemIsTheSameAs(item, item2) && item2.quantity >= quantity:
				return [true, inventory[item.broadType].find(item2)]
	if !done:
		return [false, -1]

static func itemIsTheSameAs(item:Dictionary, item2:Dictionary):
		return (item.type == item2.type && item.name == item2.name && item.buffs == item2.buffs && item.level_requirement == item2.level_requirement)
