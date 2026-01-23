extends Node2D

@onready var evolution_timer: Timer = $EvolutionTimer
@onready var grid: TileMapLayer = $Grid

var live_cells: Dictionary[Vector2i, int] = {
	Vector2i(18, 10): 0,
	Vector2i(19, 10): 0,
	Vector2i(20, 10): 0,
	Vector2i(20, 9): 0,
	Vector2i(19, 8): 0
	}

var neighbours := [
	Vector2i(-1, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1),
	Vector2i(0, -1),
	Vector2i(0, 1),
	Vector2i(1, -1),
	Vector2i(1, 0),
	Vector2i(1, 1),
	]

var prev_mouse_pos

var painting_mode: bool

func _ready() -> void:
	for coords in live_cells:
		grid.set_cell_state(coords, true)
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("paint_cell"):
		click()
	if Input.is_action_just_released("paint_cell"):
		prev_mouse_pos = null

func click() -> void:
	if Input.is_action_just_pressed("paint_cell"):
		painting_mode = not grid.local_to_map(get_global_mouse_position()) in live_cells
		
	var coords := grid.local_to_map(get_global_mouse_position())
	
	# Debounce
	if coords == prev_mouse_pos:
		return
	
	prev_mouse_pos = coords
	grid.set_cell_state(coords, painting_mode)
	
	if painting_mode:
		live_cells[coords] = 0
	else:
		live_cells.erase(coords)

func _on_evolution_timer_timeout() -> void:
	evolve()

func _on_hud_play() -> void:
	evolution_timer.start()

func _on_hud_pause() -> void:
	evolution_timer.stop()

## Flips live cells and their neighbours according to the game rules
func evolve() -> void:
	var num_neighbours: Dictionary[Vector2i, int] = {}
	var to_live: Array[Vector2i] = []
	var to_die: Array[Vector2i] = []
	var neighbour_coords: Vector2i
	
	# Increment the number of neighbours for each live cell's neighbours
	for cell in live_cells:
		# Make sure that solitary cells still get added to num_neighbours
		if cell not in num_neighbours:
			num_neighbours[cell] = 0
			
		for n in neighbours:
			neighbour_coords = Vector2i(cell.x + n.x, cell.y + n.y)
			if neighbour_coords in num_neighbours:
				num_neighbours[neighbour_coords] += 1
			else:
				num_neighbours[neighbour_coords] = 1
	
	# Check each live cell and adjacent cell against the 4 cell rules
	for coords in num_neighbours:
		if (num_neighbours[coords] < 2 or num_neighbours[coords] > 3) and coords in live_cells:
			to_die.append(coords)
		elif num_neighbours[coords] == 3 and not coords in live_cells:
			to_live.append(coords)
	
	for coords in to_live:
		grid.set_cell_state(coords, true)
		live_cells[coords] = 0
	
	for coords in to_die:
		grid.set_cell_state(coords, false)
		live_cells.erase(coords)

func _on_hud_change_speed(new_value: float) -> void:
	evolution_timer.wait_time = 0.1 / new_value
