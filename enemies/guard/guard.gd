extends Enemy

func _init().(30, 1, 20):
	set_portrait()

func set_portrait():
	$Portrait.texture = preload("res://enemies/guard/guard_portrait.png")

func get_action() -> EnemyAction:
	var action = EnemyAction.new()
	if !is_hostile:
		action.gain_suspicion = 1
	else:
		action.deal_damage = 3
	return action
