extends Card

class_name RareCard

func get_rarity() -> int:
	return RARITY.RARE

func get_letters() -> Array:
	return ["B", "G", "K", "P", "V", "W"]
