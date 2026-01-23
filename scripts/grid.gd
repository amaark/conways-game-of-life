extends TileMapLayer

func set_cell_state(coords: Vector2i, new_state: bool) -> void:
	set_cell(coords, 1 if new_state else 0, Vector2(0, 0), 0)
