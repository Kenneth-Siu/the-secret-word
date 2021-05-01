extends ReferenceRect

class_name EncounterScene

signal encounter_won

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
		tile.init(card, self, $Box/HandArea, $Box/Rect/StagingArea)
		Player.connect("tiles_moved_zone", tile, "redraw")
	$ScrambleButton.connect("scramble_button_pressed", Player, "take_scramble_action")
	Player.connect("player_action_complete", $Box/Rect/HostilitiesBegunLabel, "hide")

func setup_enemy():
	Narrator.spawn_enemy()
	$Enemy.connect("enemy_convinced", self, "encounter_won")
	$Enemy.connect("enemy_died", self, "encounter_won")
	$Enemy.connect("enemy_became_hostile", self, "become_hostile")
	$Enemy.connect("enemy_became_hostile", $Box/Rect/HostilitiesBegunLabel, "show")

func setup_player_enemy_connections():
	Player.connect("player_action_complete", $Enemy, "take_action")
	$Enemy.connect("enemy_action_complete", Player, "start_turn")

func set_enemy(enemy_script: Resource):
	$Enemy.set_script(enemy_script)

func become_hostile():
	is_hostile = true
	Player.gain_sneak_attack_bonus($Enemy.trust)

func stage_tile(tile: Tile):
	Player.stage_card(tile.card)

func unstage_tile_and_subsequent_tiles(tile: Tile):
	var card_index = Player.staging_area.find(tile.card)
	var num_of_staged_cards = Player.staging_area.size()
	var cards_to_unstage = Player.staging_area.slice(card_index, num_of_staged_cards - 1)
	for card in cards_to_unstage:
		Player.unstage_card(card)

func scramble():
	take_enemy_actions()
	Player.draw_to_full()

func submit_word():
	take_player_actions()
	Player.discard_staged_cards()
	take_enemy_actions()
	Player.draw_to_full()

func take_player_actions():
	if !$Enemy.is_hostile:
		$Enemy.gain_trust(Player.get_staged_action().non_hostile.gain_trust)
	else:
		$Enemy.take_damage(Player.get_staged_action().hostile.deal_damage)
		Player.clear_sneak_attack()

func take_enemy_actions():
	hide_hositilities_label()
	var action: EnemyAction = $Enemy.get_action()
	if action.deal_damage:
		Player.take_damage(action.deal_damage)
	if action.gain_suspicion:
		$Enemy.gain_suspicion(action.gain_suspicion)

func encounter_won():
	emit_signal("encounter_won")

func hide_hositilities_label():
	$Box/Rect/HostilitiesBegunLabel.modulate = Color(1.0, 1.0, 1.0, 0.0)
