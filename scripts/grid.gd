extends TileMapLayer

#var width := 16
#var height := 9
#var cells: Array[bool] = []
#var cursor: Vector2i
#var cursor_index: int

func _ready() -> void:
	pass
	#for x in width:
		#for y in height:
			#cells.append(false)
			#set_cell(Vector2(x, y), 0, Vector2(0, 0), 0)

func _process(delta: float) -> void:
	pass
	#cursor = local_to_map(get_global_mouse_position())
	#print("cursor: ", cursor)
	#cursor_index = vector_to_index(cursor)
	#print("index:", cursor_index)
	#print("vectorised index:", index_to_vector(cursor_index))

func set_cell_state(coords: Vector2i, new_state: bool) -> void:
	set_cell(coords, 1 if new_state else 0, Vector2(0, 0), 0)

#func flip_cell(index: int) -> void:
	#var state = 0 if cells[index] == true else 1
	#set_cell(index_to_vector(index), state, Vector2(0, 0), 0)

#func index_to_vector(index: int) -> Vector2i:
	#@warning_ignore("integer_division")
	#return Vector2(index % width, index / width)

#func vector_to_index(vector: Vector2) -> int:
	#return int(vector.y * width + vector.x)
