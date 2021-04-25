extends Reference

class_name Card

enum RARITY {
	BASIC,
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY
}

var current_letter: String

func get_rarity():
	pass

func get_letters():
	pass

func get_damage():
	pass

func randomise_current_letter():
	var letters = get_letters()
	current_letter = letters[randi() % (letters.size() - 1)]
