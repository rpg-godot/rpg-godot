class_name ItemManager

# Compare with another item
static func is_the_same(item1, item2):
	return (item1.type == item2.type && item1.name == item2.name && item1.buffs == item2.buffs && item1.levelRequirement == item2.levelRequirement)
