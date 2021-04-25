extends TextureButton

func update_state():
	if Player.is_staged_word_valid():
		self.disabled = false
	else:
		self.disabled = true
