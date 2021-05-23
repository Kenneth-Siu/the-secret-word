extends TextureButton

signal scramble_button_pressed

func pressed():
	emit_signal("scramble_button_pressed")
