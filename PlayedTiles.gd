extends ReferenceRect

signal valid_word_formed
signal valid_word_deformed

var valid_word = false

func add_tile_as_child(tile):
	add_child(tile)
	tile.get_node("Button").connect("pressed", self, "_on_TileButton_pressed", [tile])
	_align_children_to_center()
	_check_is_word()

func _align_children_to_center():
	var children = get_children()
	if children.size() == 0:
		return
	var child_width = get_child(0).get_size().x
	var starting_x = -(children.size() * child_width) / 2
	for i in range(children.size()):
		var child = children[i]
		var child_original_size = child.get_size()
		child.anchor_left = 0.5
		child.anchor_right = 0.5
		child.margin_left = i * child_width + starting_x
		child.set_size(child_original_size)

func _on_TileButton_pressed(tile):
	var children = get_children()
	var tile_index = children.find(tile)
	for child in children.slice(tile_index, children.size() - 1):
		child.get_node("Button").disconnect("pressed", self, "_on_TileButton_pressed")
		remove_child(child)
		$"../../HandTiles".add_tile_as_child(child)
	_align_children_to_center()
	_check_is_word()

func _check_is_word():
	var valid = get_child_count() > 2
	if valid and !valid_word:
		valid_word = true
		emit_signal("valid_word_formed")
	elif !valid and valid_word:
		valid_word = false
		emit_signal("valid_word_deformed")
