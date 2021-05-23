extends Node

var floor_plan_manager: FloorPlanManager
var map: Array
var chosen_room: RoomModel

func start_game():
	Player.init()
	if !Player.is_connected("player_died", self, "change_scene_to_you_died"):
		Player.connect("player_died", self, "change_scene_to_you_died")
	floor_plan_manager = FloorPlanManager.new()
	map = floor_plan_manager.get_map()
	change_scene_to_floor_plan()

func room_chosen(room: RoomModel):
	chosen_room = room
	change_scene_to_encounter()

func change_scene_to_encounter():
	get_tree().change_scene("res://encounter/encounter.tscn")

func change_scene_to_you_died():
	get_tree().change_scene("res://you_died/you_died.tscn")

func change_scene_to_main_menu():
	get_tree().change_scene("res://main_menu/main_menu.tscn")

func change_scene_to_floor_plan():
	get_tree().change_scene("res://floor_plan/floor_plan.tscn")

func _deferred_change_to_scene_instance(scene_instance: Node):
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	current_scene.free()
	current_scene = scene_instance
	root.add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func spawn_enemy():
	var root = get_tree().get_root()
	var encounter: EncounterScene = root.get_child(root.get_child_count() - 1)
	encounter.set_enemy(chosen_room.get_enemy_script())
	encounter.connect("encounter_won", self, "encounter_won")

func encounter_won() -> void:
	floor_plan_manager.advance()
	map = floor_plan_manager.get_map()
	change_scene_to_floor_plan()
