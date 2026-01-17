extends TileMapLayer

@export var grid: TileMapLayer

func _process(delta: float) -> void:
	var tile := local_to_map(get_global_mouse_position())
	var index = grid.util.vector_to_index(tile)
	
	print(index)
	if index > 0 && index < grid.cells.size():
		set_cell(tile, 1, Vector2(0,0), 0)
