extends Node

class_name RoomModel

var start: Vector2
var end: Vector2

func get_room_color():
	pass

func get_enemy_script():
	return preload("res://enemies/guard/guard.gd")
