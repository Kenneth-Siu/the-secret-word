extends CenterContainer

func _ready():
	randomize()

func new_game():
	Narrator.start_game()

func exit():
	get_tree().quit()
