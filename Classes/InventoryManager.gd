class_name InventoryManager

static func add(player: Dictionary, item: Dictionary, quantity:=1):
	if quantity < 0:
		return false
	
	if item_exists(player, item):
		increase_quantity(player, item, quantity)
	else:
		player.items.inventory.append(item)

static func remove(player: Dictionary, item: Dictionary, quantity:=1):
	if quantity < 0:
		return false
	
	if item_exists(player, item):
		decrease_quantity(player, item, quantity)


static func increase_quantity(player: Dictionary, item: Dictionary, quantity:=1):
	var index = find_item(player, item)
	player.items.inventory[index].quantity += quantity

static func decrease_quantity(player: Dictionary, item: Dictionary, quantity:=1):
	var index = find_item(player, item)
	player.items.inventory[index].quantity -= quantity
	
	if player.items.inventory[index] <= 0:
		player.items.inventory.erase(item)


static func item_exists(player, item: Dictionary):
	for item2 in player.items.inventory:
		if str(item) == str(item2):
			return true
	return false

static func find_item(player, item: Dictionary):
	for index in item.size():
		if str(item) == str(player.items.inventory[index]):
			return index
	return false
