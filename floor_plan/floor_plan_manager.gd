extends Reference

class_name FloorPlanManager

const STARTING_ROOMS = 4
const ROOMS_GAINED_PER_ADVANCE = 2

var map: Array
var rooms: Array

var rooms_available: int = 0

func _init() -> void:
	rooms = RoomsArrayFactory.new().get_rooms()
	map = []
	advance(STARTING_ROOMS)

func get_map() -> Array:
	return map.duplicate()

func advance(advance_by: int = ROOMS_GAINED_PER_ADVANCE) -> void:
	if rooms_available >= rooms.size():
		return
	for room_number in range(rooms_available, rooms_available + advance_by):
		if room_number >= rooms.size():
			rooms_available = rooms.size()
			return
		var room = get_room_model(rooms[room_number])
		set_room_corners(room, room_number)
		map.append(room)
	rooms_available += advance_by

func get_room_model(room_type: int) -> RoomModel:
	match room_type:
		ROOM_TYPE.OFFICE:
			return RoomModelOffice.new()
		ROOM_TYPE.LABORATORY:
			return RoomModelLaboratory.new()
		ROOM_TYPE.BREAK_ROOM:
			return RoomModelBreakRoom.new()
		ROOM_TYPE.BATHROOM:
			return RoomModelBathroom.new()
		ROOM_TYPE.CAMERA_ROOM:
			return RoomModelCameraRoom.new()
		ROOM_TYPE.VAULT:
			return RoomModelVault.new()
		ROOM_TYPE.EXECUTIVES_OFFICE:
			return RoomModelExecutivesOffice.new()
		_:
			return RoomModelOffice.new()

func set_room_corners(room, room_number: int) -> void:
	room.start = Vector2(room_number * 2, 0)
	room.end = Vector2(room_number * 2 + 1, 1)
