extends TextureButton

signal room_chosen

var Square = preload("res://floor_plan/square/square.tscn")
var model_square = Square.instance()

var room_model: RoomModel

func _ready():
	connect("pressed", self, "room_chosen")
	connect("room_chosen", Narrator, "room_chosen")

func get_start() -> Vector2:
	return room_model.start

func set_model(_room_model: RoomModel) -> void:
	room_model = _room_model
	set_room_corners()

func set_room_corners() -> void:
	if room_model.start.x > room_model.end.x or room_model.start.y > room_model.end.y:
		push_error("Room start should be smaller than or equal to room end")
		
	for x in range(0, room_model.end.x - room_model.start.x + 1):
		for y in range(0, room_model.end.y - room_model.start.y + 1):
			render_square(Vector2(x, y))
	
	var size = FloorPlanUtilities.position_to_pixels(
		Vector2(room_model.end.x + 1, room_model.end.y + 1), 
		model_square
	)
	margin_right = size.x
	margin_bottom = size.y

func render_square(position: Vector2) -> void:
	var square = Square.instance()
	add_child(square)
	square.modulate = room_model.get_room_color()
	var margins = FloorPlanUtilities.position_to_pixels(position, model_square)
	square.margin_left = margins.x
	square.margin_top = margins.y

func room_chosen() -> void:
	emit_signal("room_chosen", room_model)
