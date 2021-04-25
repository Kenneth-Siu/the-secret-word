extends Node

func start_game():
	Player.init()
	Player.connect("player_died", self, "end_game")
	get_tree().change_scene("res://encounter/encounter.tscn")

func spawn_enemy():
	var root = get_tree().get_root()
	var encounter: EncounterScene = root.get_child(root.get_child_count() - 1)
	encounter.set_enemy(preload("res://enemies/guard/guard.gd"))
	encounter.connect("encounter_won", self, "end_game")

func end_game():
	get_tree().change_scene("res://main_menu/main_menu.tscn")
