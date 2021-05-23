extends Reference

class_name FloorPlanUtilities

static func position_to_pixels(position: Vector2, model_square) -> Vector2:
	return Vector2(
		position.x * model_square.get_size().x,
		position.y * model_square.get_size().y
	)
