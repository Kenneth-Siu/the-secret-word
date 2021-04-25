extends Card

class_name LegendaryCard

func get_rarity() -> int:
	return RARITY.LEGENDARY

func get_letters() -> Array:
	return ["J", "Q", "X", "Z"]
