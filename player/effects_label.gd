extends Label

func _ready():
	update_effects_label()
	Player.connect("player_effects_changed", self, "update_effects_label")

func update_effects_label():
	var new_text = ""
	if Player.effects.sneak_attack > 0.0:
		new_text += "Sneak Attack Multiplier: %0.1fx" % Player.effects.sneak_attack
	text = new_text
