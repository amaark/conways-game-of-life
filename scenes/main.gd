extends Node2D

@onready var evolution_timer: Timer = $EvolutionTimer
@onready var grid: TileMapLayer = $Grid

var paused: bool = true

var live_cells: Dictionary[Vector2i, int] = {
	Vector2i(1, 3): 0,
	Vector2i(2, 3): 0,
	Vector2i(3, 3): 0,
	Vector2i(3, 2): 0,
	Vector2i(2, 1): 0
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

func _ready() -> void:
	for coords in live_cells:
		grid.set_cell_state(coords, true)
	
	evolution_timer.start()

func _process(delta: float) -> void:
	click()

func click() -> void:
	if paused and Input.is_action_just_pressed("paint_tile"):
		var coords := grid.local_to_map(get_global_mouse_position())
		var new_state := not coords in live_cells
		grid.set_cell_state(coords, new_state)
		
		if new_state:
			live_cells[coords] = 0
		else:
			live_cells.erase(coords)

func _on_evolution_timer_timeout() -> void:
	if not paused:
		evolve()

func _on_hud_play() -> void:
	evolution_timer.start()
	paused = false

func _on_hud_pause() -> void:
	evolution_timer.stop()
	paused = true

## Flips live cells and their neighbours according to the game rules
func evolve() -> void:
	var num_neighbours: Dictionary[Vector2i, int] = {}
	var to_live: Array[Vector2i] = []
	var to_die: Array[Vector2i] = []
	var neighbour_coords: Vector2i
	
	# Increment the number of neighbours for each neighbour of each live cell
	for cell in live_cells:
		for n in neighbours:
			neighbour_coords = Vector2i(cell.x + n.x, cell.y + n.y)
			if neighbour_coords in num_neighbours:
				num_neighbours[neighbour_coords] += 1
			else:
				num_neighbours[neighbour_coords] = 1
	
	# Check each live cell and adjacent cell against the 4 cell rules
	for coords in num_neighbours:
		if num_neighbours[coords] < 2 or num_neighbours[coords] > 3 and coords in live_cells:
			to_die.append(coords)
		elif num_neighbours[coords] == 3 and not coords in live_cells:
			to_live.append(coords)
	
	for coords in to_live:
		grid.set_cell_state(coords, true)
		live_cells[coords] = 0
	
	for coords in to_die:
		grid.set_cell_state(coords, false)
		live_cells.erase(coords)
