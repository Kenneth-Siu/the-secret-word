extends Node

signal player_staging_area_changed
signal tiles_moved_zone
signal player_dealt_enemy_damage
signal player_gained_trust_with_enemy
signal player_action_complete
signal player_health_changed
signal player_effects_changed
signal player_died

var MAX_HAND_SIZE = 10
var SCRAMBLE_NUMBER_OF_TILES = 4
var MIN_WORD_LENGTH = 3

var deck: Array = []
var max_health: int

var draw_pile: Array = []
var discard_pile: Array = []
var hand: Array = []
var staging_area: Array = []
var health: int

var effects: PlayerEffects = PlayerEffects.new()

func init():
	load_deck()
	max_health = 60
	health = max_health

func load_deck():
	deck.clear()
	for _i in range(8):
		deck.append(Punch.new())
	for _i in range(6):
		deck.append(Kick.new())
	for _i in range(4):
		deck.append(Tackle.new())
	for _i in range(2):
		deck.append(Choke.new())
	deck.append(Suplex.new())

func start_fight():
	draw_pile = deck.duplicate()
	draw_pile.shuffle()
	discard_pile.clear()
	hand.clear()
	staging_area.clear()
	effects = PlayerEffects.new()
	start_turn()

func take_scramble_action():
	for _i in range(SCRAMBLE_NUMBER_OF_TILES):
		discard_card_from_hand(randi() % (hand.size() - 1))
	emit_signal("player_action_complete")

func take_action(is_hostile: bool):
	if !is_hostile:
		emit_signal("player_gained_trust_with_enemy", get_staged_action().non_hostile.gain_trust)
	else:
		emit_signal("player_dealt_enemy_damage", get_staged_action().hostile.deal_damage)
		clear_sneak_attack()
	discard_staged_cards()
	emit_signal("player_action_complete")

func start_turn():
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
	emit_signal("tiles_moved_zone")

func discard_card_from_hand(index: int):
	var card = hand[index]
	hand.remove(index)
	discard_pile.append(card)
	emit_signal("tiles_moved_zone")

func stage_card(card: Card):
	if (!hand.has(card)):
		push_error("Can't stage card not in hand.")
	staging_area.append(card)
	emit_signal("player_staging_area_changed")
	emit_signal("tiles_moved_zone")

func unstage_card(card: Card):
	staging_area.remove(staging_area.find(card))
	emit_signal("player_staging_area_changed")
	emit_signal("tiles_moved_zone")
	
func unstage_card_and_subsequent_cards(card: Card):
	var card_index = staging_area.find(card)
	var num_of_staged_cards = staging_area.size()
	var cards_to_unstage = staging_area.slice(card_index, num_of_staged_cards - 1)
	for card in cards_to_unstage:
		unstage_card(card)

func discard_staged_cards():
	for card in staging_area:
		var hand_index = hand.find(card)
		hand.remove(hand_index)
		discard_pile.append(card)
	staging_area.clear()
	emit_signal("player_staging_area_changed")
	emit_signal("tiles_moved_zone")

func is_staged_word_valid() -> bool:
	var word = get_staged_word()
	return word.length() >= MIN_WORD_LENGTH and WordsDictionary.is_word(word)

func get_staged_word() -> String:
	var word: String = ""
	for card in staging_area:
		word += card.current_letter.to_lower()
	return word

func get_staged_action() -> PlayerAction:
	var action = PlayerAction.new()
	for card in staging_area:
		action.non_hostile.gain_trust += card.get_trust()
		action.hostile.deal_damage += card.get_damage()
	if effects.sneak_attack > 0.0:
		action.hostile.deal_damage = int(action.hostile.deal_damage * effects.sneak_attack)
	return action

func take_damage(damage_amount: int):
	if damage_amount > health:
		health = 0
	else:
		health -= damage_amount
	if damage_amount > 0:
		emit_signal("player_health_changed")
	if health == 0:
		die()

func die():
	emit_signal("player_died")

func gain_sneak_attack_bonus(enemy_trust: int):
	var bonus = enemy_trust / 5.0
	if bonus > 1.0:
		effects.sneak_attack = bonus
		emit_signal("player_effects_changed")

func clear_sneak_attack():
	if effects.sneak_attack != 0.0:
		effects.sneak_attack = 0.0
		emit_signal("player_effects_changed")
