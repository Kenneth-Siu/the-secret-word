extends ReferenceRect

var Square = preload("res://floor_plan/square/square.tscn")
var model_square = Square.instance()

var RoomScene = preload("res://floor_plan/room/room.tscn")

func _ready():
	for room_model in Narrator.map:
		render_room(room_model)
	center_and_scale_squares()

func render_room(room_model: RoomModel) -> void:
	var room = RoomScene.instance()
	room.set_model(room_model)
	$Squares.add_child(room)
	var margins = FloorPlanUtilities.position_to_pixels(room.get_start(), model_square)
	room.margin_left = margins.x
	room.margin_top = margins.y

func center_and_scale_squares() -> void:
	var map_pixel_size = get_map_pixel_size()
	var new_scale = min(get_size().x / map_pixel_size.x, get_size().y / map_pixel_size.y)
	$Squares.rect_scale = Vector2(new_scale, new_scale)
	var map_middle = get_min_pixel_coordinates() + (map_pixel_size / 2)
	$Squares.margin_left = -map_middle.x * new_scale
	$Squares.margin_top = -map_middle.y * new_scale

func get_map_pixel_size() -> Vector2:
	return get_max_pixel_coordinates() - get_min_pixel_coordinates()

func get_min_pixel_coordinates() -> Vector2:
	if Narrator.map.empty():
		return Vector2.ZERO
	var smallest_coordinates: Vector2 = Vector2(INF, INF)
	for room in Narrator.map:
		var pixel_coordinates = FloorPlanUtilities.position_to_pixels(room.start, model_square)
		smallest_coordinates.x = min(smallest_coordinates.x, pixel_coordinates.x)
		smallest_coordinates.y = min(smallest_coordinates.y, pixel_coordinates.y)
	return smallest_coordinates

func get_max_pixel_coordinates() -> Vector2:
	if Narrator.map.empty():
		return Vector2.ZERO
	var largest_coordinates: Vector2 = Vector2(-INF, -INF)
	for room in Narrator.map:
		var pixel_coordinates = FloorPlanUtilities.position_to_pixels(room.end, model_square)
		largest_coordinates.x = max(largest_coordinates.x, pixel_coordinates.x + model_square.get_size().x)
		largest_coordinates.y = max(largest_coordinates.y, pixel_coordinates.y + model_square.get_size().y)
	return largest_coordinates
