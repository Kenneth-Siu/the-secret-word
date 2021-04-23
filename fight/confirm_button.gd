extends TextureButton

func _on_PlayedTiles_valid_word_formed():
	self.disabled = false

func _on_PlayedTiles_valid_word_deformed():
	self.disabled = true
