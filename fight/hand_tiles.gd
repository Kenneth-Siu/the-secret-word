extends ReferenceRect

var ALPHABET = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
"Q","R","S","T","U","V","W","X","Y","Z"]
var MAX_HAND_SIZE = 10
var SCRAMBLE_NUMBER_OF_TILES = 3

var Tile = preload("res://tile/tile.tscn")
var hand = []

func init_new_hand():
	_fill_hand()

func _fill_hand():
	while hand.size() < MAX_HAND_SIZE:
		_add_new_tile()

func _add_new_tile():
	var tile_letter = ALPHABET[randi() % (ALPHABET.size() - 1)]
	var tile = _create_tile_node(tile_letter)
	hand.append(tile)
	add_tile_as_child(tile)
	
func _create_tile_node(letter):
	var tile = Tile.instance()
	tile.get_node("Letter").text = letter
	return tile
	
func add_tile_as_child(tile):
	add_child(tile)
	_reset_tile_position(tile)
	tile.get_node("Button").connect("pressed", self, "_on_TileButton_pressed", [tile], CONNECT_ONESHOT)

func _reset_tile_position(tile):
	var original_size = tile.get_size()
	var child_position = hand.find(tile)
	tile.anchor_left = 0
	tile.anchor_right = 0
	tile.margin_left = child_position * original_size.x
	tile.set_size(original_size)

func _on_TileButton_pressed(tile):
	remove_child(tile)
	$"../PlayArea/PlayedTiles".add_tile_as_child(tile)

func _on_ConfirmButton_pressed():
	hand = get_children()
	_fill_hand()
	_reset_all_tile_positions()

func _reset_all_tile_positions():
	for child in get_children():
		_reset_tile_position(child)

func _on_ScrambleButton_pressed():
	$"../PlayArea/PlayedTiles".return_tiles_to_hand()
	for i in range(SCRAMBLE_NUMBER_OF_TILES):
		var tile_to_remove = hand[randi() % (hand.size() - 1)]
		hand.erase(tile_to_remove)
		tile_to_remove.queue_free()
	_fill_hand()
	_reset_all_tile_positions()
