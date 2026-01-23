extends TileMapLayer

var prev_mouse_pos: Vector2i

func _process(delta: float) -> void:
	var tile := local_to_map(get_global_mouse_position())
	set_cell(tile, 0, Vector2(0,0), 0)
	
	if prev_mouse_pos != tile:
		erase_cell(prev_mouse_pos)
		prev_mouse_pos = tile
