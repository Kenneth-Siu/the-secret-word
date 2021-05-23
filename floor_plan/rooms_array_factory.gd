extends Reference

class_name RoomsArrayFactory

const ROOMS_IN_MAP: int = 20
const ROOMS_REVEALED_ON_ADVANCE: int = 3
const ROOM_RANGES: Dictionary = {
	"FIRST_BATHROOM": { "start": 6, "end": 8 },
	"SECOND_BATHROOM": { "start": 14, "end": 16 },
	"TARGET": { "start": 10, "end": 12 },
}

const TARGET_ROOM_TYPES: Array = [
	ROOM_TYPE.VAULT,
	ROOM_TYPE.EXECUTIVES_OFFICE,
]
const RANDOM_ROOM_TYPES: Array = [
	ROOM_TYPE.OFFICE,
	ROOM_TYPE.LABORATORY,
	ROOM_TYPE.BREAK_ROOM,
]

var rooms: Array
var _reserved_room_locations: Array

func get_rooms() -> Array:
	rooms = []
	_reserved_room_locations = []
	fill_rooms()
	return rooms.duplicate()

func fill_rooms() -> void:
	var first_bathroom_location: int = reserve_range_room_location(ROOM_RANGES.FIRST_BATHROOM)
	var second_bathroom_location: int = reserve_range_room_location(ROOM_RANGES.SECOND_BATHROOM)
	var target_location: int = reserve_range_room_location(ROOM_RANGES.TARGET)
	var camera_room_location: int = reserve_random_room_location()
	for i in range(ROOMS_IN_MAP):
		match i:
			first_bathroom_location:
				add_bathroom()
			second_bathroom_location:
				add_bathroom()
			target_location:
				add_target()
			camera_room_location:
				add_camera_room()
			_:
				add_random_room()

func reserve_range_room_location(location_range: Dictionary) -> int:
	for i in range(location_range.start, location_range.end + 1):
		if !_reserved_room_locations.has(i):
			break
		push_error("Range full. Not enough space for a range room.")
		return -1
	var location: int = (randi() % (location_range.end - location_range.start)) + location_range.start
	_reserved_room_locations.append(location)
	return location

func reserve_random_room_location() -> int:
	for i in range(ROOMS_IN_MAP):
		if !_reserved_room_locations.has(i):
			break
		push_error("Floor full. Not enough space for a random room.")
		return -1
	var location: int = -1
	while (location == -1 or _reserved_room_locations.has(location)):
		location = randi() % ROOMS_IN_MAP
	_reserved_room_locations.append(location)
	return location

func add_bathroom() -> void:
	add_room(ROOM_TYPE.BATHROOM)

func add_target() -> void:
	add_room(TARGET_ROOM_TYPES[randi() % TARGET_ROOM_TYPES.size()])

func add_camera_room() -> void:
	add_room(ROOM_TYPE.CAMERA_ROOM)

func add_random_room() -> void:
	add_room(RANDOM_ROOM_TYPES[randi() % RANDOM_ROOM_TYPES.size()])

func add_room(room_type: int) -> void:
	rooms.append(room_type)
