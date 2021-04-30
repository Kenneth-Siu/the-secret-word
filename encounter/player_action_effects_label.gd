extends Label

func update_state():
	var new_text = ""
	var player_action = Player.get_staged_action()
	if !$"../../../../Encounter".is_hostile:
		var trust = player_action.non_hostile.gain_trust
		if trust > 0:
			new_text = "Gain %d trust" % trust
	else:
		var damage = player_action.hostile.deal_damage
		if damage > 0:
			new_text = "Deal %d damage" % damage
	text = new_text

	if Player.is_staged_word_valid():
		add_color_override("font_color", Color.white)
	else:
		add_color_override("font_color", Color("#66FFFFFF"))
