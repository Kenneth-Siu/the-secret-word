extends ReferenceRect

var ALPHABET = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P",
"Q","R","S","T","U","V","W","X","Y","Z"]
var MAX_HAND_SIZE = 10

var Tile = preload("res://Tile.tscn")
var hand = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_new_hand():
	for i in range(MAX_HAND_SIZE):
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
	var original_size = tile.get_size()
	var child_position = hand.find(tile)
	tile.anchor_left = 0
	tile.anchor_right = 0
	tile.margin_left = child_position * original_size.x
	tile.set_size(original_size)
	tile.get_node("Button").connect("pressed", self, "_on_TileButton_pressed", [tile], CONNECT_ONESHOT)

func _on_TileButton_pressed(tile):
	remove_child(tile)
	$"../PlayArea/PlayedTiles".add_tile_as_child(tile)
