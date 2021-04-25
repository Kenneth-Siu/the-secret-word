extends Node

var MAX_HAND_SIZE = 10
var SCRAMBLE_NUMBER_OF_TILES = 4

var deck: Array = []

var draw_pile: Array = []
var discard_pile: Array = []
var hand: Array = []
var staging_area: Array = []

func _ready():
	for _i in range(8):
		deck.append(BasicCard.new())
	for _i in range(6):
		deck.append(CommonCard.new())
	for _i in range(4):
		deck.append(UncommonCard.new())
	for _i in range(2):
		deck.append(RareCard.new())
	deck.append(LegendaryCard.new())

func start_fight():
	discard_pile.clear()
	hand.clear()
	staging_area.clear()
	draw_pile = deck.duplicate()
	draw_pile.shuffle()
	draw_to_full()

func scramble():
	for _i in range(SCRAMBLE_NUMBER_OF_TILES):
		discard_card_from_hand(randi() % (hand.size() - 1))
	draw_to_full()

func draw_to_full():
	if hand.size() < MAX_HAND_SIZE:
		for _i in range(MAX_HAND_SIZE - hand.size()):
			draw_card()

func draw_card():
	if draw_pile.empty() and !discard_pile.empty():
		draw_pile = discard_pile.duplicate()
		discard_pile.clear()
		draw_pile.shuffle()
	elif draw_pile.empty() and !discard_pile.empty():
		return
	var card = draw_pile.pop_back()
	hand.append(card)
	card.randomise_current_letter()

func discard_card_from_hand(index: int):
	var card = hand[index]
	hand.remove(index)
	discard_pile.append(card)

func stage_card(card: Card):
	if (!hand.has(card)):
		push_error("Can't stage card not in hand.")
	staging_area.append(card)

func unstage_card(card: Card):
	staging_area.remove(staging_area.find(card))

func discard_staged_cards():
	for card in staging_area:
		var hand_index = hand.find(card)
		hand.remove(hand_index)
		discard_pile.append(card)
	staging_area.clear()

func get_staged_word() -> String:
	var word: String = ""
	for card in staging_area:
		word += card.current_letter.to_lower()
	return word
