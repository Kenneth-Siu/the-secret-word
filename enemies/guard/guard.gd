extends Enemy

func _init():
	set_portrait()
	max_health = 20
	health = 20

func set_portrait():
	$Portrait.texture = preload("res://enemies/guard/guard_portrait.png")
