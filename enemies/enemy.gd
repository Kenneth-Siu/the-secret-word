extends ReferenceRect

class_name Enemy

signal enemy_died

var max_health: int
var health: int

func _init():
	pass

func take_damage(damage_amount: int):
	if damage_amount > health:
		health = 0
	else:
		health -= damage_amount
	if health == 0:
		kill_enemy()

func kill_enemy():
	emit_signal("enemy_died")
