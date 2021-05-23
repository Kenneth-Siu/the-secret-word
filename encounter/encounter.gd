extends ReferenceRect

class_name EncounterScene

signal encounter_won
signal submit_button_pressed

var is_hostile: bool = false

var Tile = preload("res://tile/tile.tscn")

func _ready():
	setup_player()
	setup_enemy()
	setup_player_enemy_connections()

func setup_player():
	Player.start_fight()
	for card in Player.deck:
		var tile = Tile.instance()
		tile.init(card, $Box/HandArea, $Box/Rect/StagingArea)
		Player.connect("tiles_moved_zone", tile, "redraw")
	$ScrambleButton.connect("scramble_button_pressed", Player, "take_scramble_action")
	Player.connect("player_action_complete", $Box/Rect/HostilitiesBegunLabel, "make_hidden")
	Player.connect("player_staging_area_changed", $Box/Rect/PlayerActionEffectsLabel, "update")
	Player.connect("player_staging_area_changed", $SubmitButton, "update_state")
	connect("submit_button_pressed", Player, "take_action")

func setup_enemy():
	Narrator.spawn_enemy()
	$Enemy.connect("enemy_convinced", self, "encounter_won")
	$Enemy.connect("enemy_died", self, "encounter_won")
	$Enemy.connect("enemy_became_hostile", self, "become_hostile")
	$Enemy.connect("enemy_became_hostile", $Box/Rect/HostilitiesBegunLabel, "make_visible")

func setup_player_enemy_connections():
	Player.connect("player_action_complete", $Enemy, "take_action")
	$Enemy.connect("enemy_dealt_player_damage", Player, "take_damage")
	$Enemy.connect("enemy_action_complete", Player, "start_turn")
	$Enemy.connect("enemy_became_hostile", Player, "gain_sneak_attack_bonus")
	Player.connect("player_gained_trust_with_enemy", $Enemy, "gain_trust")
	Player.connect("player_dealt_enemy_damage", $Enemy, "take_damage")

func set_enemy(enemy_script: Resource):
	$Enemy.set_script(enemy_script)

func become_hostile(_trust: int):
	is_hostile = true

func submit_button_pressed():
	emit_signal("submit_button_pressed", is_hostile)

func encounter_won():
	emit_signal("encounter_won")

func hide_hositilities_label():
	$Box/Rect/HostilitiesBegunLabel.modulate = Color(1.0, 1.0, 1.0, 0.0)
