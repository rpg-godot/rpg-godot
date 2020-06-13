class_name InventoryManager

static func add(inventory: Array, item_data: Dictionary, quantity:=1):
	Core.emit_signal("msg", "Adding item " + item_data.name + str(quantity) + " times...", Log.WARN, "inventory_manager")
	if quantity < 0:
		return false
	
	if item_exists(inventory, item_data):
		increase_quantity(inventory, item_data, quantity)
	else:
		item_data.quantity = quantity
		inventory.append(item_data)
	
	return inventory.size() -1

static func remove(inventory: Array, item_data: Dictionary, quantity:=1):
	if quantity < 0:
		return false
	
	if item_exists(inventory, item_data):
		decrease_quantity(inventory, item_data, quantity)


static func increase_quantity(inventory: Array, item_data: Dictionary, quantity:=1):
	Core.emit_signal("msg", "Increasing quantity by " + str(quantity) + " for item " + item_data.name + "...", Log.WARN, "inventory_manager")
	var index = find_item(inventory, item_data)
	print(index)
	inventory[index].quantity += quantity

static func decrease_quantity(inventory: Array, item_data: Dictionary, quantity:=1):
	var index = find_item(inventory, item_data)
	inventory[index].quantity -= quantity
	
	if inventory[index] <= 0:
		inventory.erase(item_data)


static func item_exists(inventory: Array, item_data: Dictionary):
	for item2 in inventory:
		if str(item_data) == str(item2):
			return true
	return false

static func find_item(inventory: Array, item_data: Dictionary):
	for index in item_data.size():
		var item2_data: Dictionary = inventory[index]
		item2_data.erase("quantity")
		item_data.erase("quantity")
		if str(item_data) == str(item2_data):
			return index
	return false
