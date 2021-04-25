extends ReferenceRect

signal rerender_tiles
signal staging_area_valid_word
signal staging_area_invalid_word

var MIN_WORD_LENGTH = 3

var Tile = preload("res://tile/tile.tscn")

func _ready():
	randomize()
	Player.start_fight()
	for card in Player.deck:
		var tile = Tile.instance()
		tile.init(card, self, $Box/HandArea, $Box/Rect/StagingArea)
	emit_signal("rerender_tiles")

func stage_tile(tile: Tile):
	Player.stage_card(tile.card)
	emit_signal("rerender_tiles")
	check_staged_word_validity()

func unstage_tile_and_subsequent_tiles(tile: Tile):
	var card_index = Player.staging_area.find(tile.card)
	var num_of_staged_cards = Player.staging_area.size()
	var cards_to_unstage = Player.staging_area.slice(card_index, num_of_staged_cards - 1)
	for card in cards_to_unstage:
		Player.unstage_card(card)
	emit_signal("rerender_tiles")
	check_staged_word_validity()

func check_staged_word_validity():
	var word = Player.get_staged_word()
	if word.length() >= MIN_WORD_LENGTH and WordsDictionary.is_word(word):
		emit_signal("staging_area_valid_word")
	else:
		emit_signal("staging_area_invalid_word")

func scramble():
	Player.scramble()
	emit_signal("rerender_tiles")

func submit_word():
	Player.discard_staged_cards()
	Player.draw_to_full()
	emit_signal("rerender_tiles")
	emit_signal("staging_area_invalid_word")
