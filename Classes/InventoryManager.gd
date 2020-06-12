class_name InventoryManager

static func add(inventory: Array, item_data: Dictionary, quantity:=1):
	if quantity < 0:
		return false
	
	if item_exists(inventory, item_data):
		increase_quantity(inventory, item_data, quantity)
	else:
		inventory.append(item_data)
	
	return inventory.size() -1

static func remove(inventory: Array, item_data: Dictionary, quantity:=1):
	if quantity < 0:
		return false
	
	if item_exists(inventory, item_data):
		decrease_quantity(inventory, item_data, quantity)


static func increase_quantity(inventory: Array, item_data: Dictionary, quantity:=1):
	var index = find_item(inventory, item_data)
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
		if str(item_data) == str(inventory[index]):
			return index
	return false
