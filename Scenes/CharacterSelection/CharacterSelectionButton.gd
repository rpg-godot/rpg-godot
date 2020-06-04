extends Control

var pressed setget set_pressed, get_pressed

func set_pressed(value):
	get_node("VBox/Content/Button").pressed = value

func get_pressed():
	return get_node("VBox/Content/Button").pressed
