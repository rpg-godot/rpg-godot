extends Node

#onready var Client = get_node("/root/World/Systems/Client")
#onready var Server = get_node("/root/World/Systems/Server")

signal _request_scene_load(scene)
signal _scene_loaded(scene)
signal _entity_used(entity, amount)
signal _msg(message, level, obj)
signal _damage_dealt(target, shooter, weapon_data)
signal _damage_taken(target, shooter)
signal _entity_picked_up(picker, entity)

signal _gui_loaded(name, entity)
signal _gui_pushed(name, data)

var character_data = {}
