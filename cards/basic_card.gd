extends Card

class_name BasicCard

func get_rarity() -> int:
	return RARITY.BASIC

func get_letters() -> Array:
	return ["A", "E", "I", "O", "U"]
