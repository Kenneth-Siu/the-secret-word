extends ReferenceRect

class_name Tile

var card: Card
var hand_area: Node
var staging_area: Node

func init(new_card: Card, new_hand_area: Node, new_staging_area: Node):
	card = new_card
	hand_area = new_hand_area
	staging_area = new_staging_area
	match card.get_rarity():
		Card.RARITY.BASIC:
			$RaritySymbol.modulate = Color("#ffffff")
		Card.RARITY.COMMON:
			$RaritySymbol.modulate = Color("#606aff")
		Card.RARITY.UNCOMMON:
			$RaritySymbol.modulate = Color("#72ed71")
		Card.RARITY.RARE:
			$RaritySymbol.modulate = Color("#dc60ff")
		Card.RARITY.LEGENDARY:
			$RaritySymbol.modulate = Color("#ffdb39")
	redraw()

func redraw():
	$Letter.text = card.current_letter
	if Player.staging_area.has(card) and Player.hand.has(card):
		move_to_staging_area()
	elif Player.hand.has(card):
		move_to_hand_area()
	else:
		discard()

func move_to_staging_area():
	if get_parent() != staging_area:
		if get_parent() != null:
			get_parent().remove_child(self)
		staging_area.add_child(self)
	var original_size = get_size()
	var width = original_size.x
	var starting_x = -(Player.staging_area.size() * width) / 2
	var index = Player.staging_area.find(card)
	anchor_left = 0.5
	anchor_right = 0.5
	margin_left = index * width + starting_x
	set_size(original_size)
	if $Button.is_connected("pressed", Player, "stage_card"):
		$Button.disconnect("pressed", Player, "stage_card")
	if !$Button.is_connected("pressed", Player, "unstage_card_and_subsequent_cards"):
		$Button.connect("pressed", Player, "unstage_card_and_subsequent_cards", [card])

func move_to_hand_area():
	if get_parent() != hand_area:
		if get_parent() != null:
			get_parent().remove_child(self)
		hand_area.add_child(self)
	var original_size = get_size()
	var width = original_size.x
	var index = Player.hand.find(card)
	anchor_left = 0
	anchor_right = 0
	margin_left = index * width
	set_size(original_size)
	if $Button.is_connected("pressed", Player, "unstage_card_and_subsequent_cards"):
		$Button.disconnect("pressed", Player, "unstage_card_and_subsequent_cards")
	if !$Button.is_connected("pressed", Player, "stage_card"):
		$Button.connect("pressed", Player, "stage_card", [card])

func discard():
	if get_parent() != null:
		get_parent().remove_child(self)
