extends ReferenceRect

class_name EncounterScene

signal encounter_ready
signal rerender_encounter
signal encounter_won

var is_hostile: bool = false

var Tile = preload("res://tile/tile.tscn")

func _ready():
	Player.start_fight()
	for card in Player.deck:
		var tile = Tile.instance()
		tile.init(card, self, $Box/HandArea, $Box/Rect/StagingArea)
	emit_signal("rerender_encounter")
	self.connect("encounter_ready", Narrator, "spawn_enemy")
	emit_signal("encounter_ready")
	$Enemy.connect("enemy_convinced", self, "encounter_won")
	$Enemy.connect("enemy_died", self, "encounter_won")
	$Enemy.connect("enemy_became_hostile", self, "become_hostile")

func set_enemy(enemy_script: Resource):
	$Enemy.set_script(enemy_script)

func become_hostile():
	is_hostile = true
	emit_signal("rerender_encounter")

func stage_tile(tile: Tile):
	Player.stage_card(tile.card)
	emit_signal("rerender_encounter")

func unstage_tile_and_subsequent_tiles(tile: Tile):
	var card_index = Player.staging_area.find(tile.card)
	var num_of_staged_cards = Player.staging_area.size()
	var cards_to_unstage = Player.staging_area.slice(card_index, num_of_staged_cards - 1)
	for card in cards_to_unstage:
		Player.unstage_card(card)
	emit_signal("rerender_encounter")

func scramble():
	Player.scramble()
	emit_signal("rerender_encounter")

func submit_word():
	take_player_actions()
	take_enemy_actions()
	upkeep()
	emit_signal("rerender_encounter")

func take_player_actions():
	if !$Enemy.is_hostile:
		$Enemy.gain_trust(Player.get_staged_action().non_hostile.gain_trust)
	else:
		$Enemy.take_damage(Player.get_staged_action().hostile.deal_damage)

func take_enemy_actions():
	var action: EnemyAction = $Enemy.get_action()
	if action.deal_damage:
		Player.take_damage(action.deal_damage)
	if action.gain_suspicion:
		$Enemy.gain_suspicion(action.gain_suspicion)

func upkeep():
	Player.discard_staged_cards()
	Player.draw_to_full()

func encounter_won():
	emit_signal("encounter_won")
