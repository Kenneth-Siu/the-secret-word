extends Label

func update_state():
	var damage = Player.get_staged_damage()
	if damage > 0:
		text = "%d damage" % damage
	else:
		text = ""
