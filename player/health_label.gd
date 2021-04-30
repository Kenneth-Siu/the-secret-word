extends Label

func _ready():
	update_health_label()
	Player.connect("player_health_changed", self, "update_health_label")

func update_health_label():
	text = "Health: %d/%d" % [Player.health, Player.max_health]
