extends ReferenceRect

func _ready():
	randomize()
	$Box/HandTiles.init_new_hand()
