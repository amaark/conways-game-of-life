extends Node2D

@onready var grid: TileMapLayer = $Grid

var live_cells: Dictionary[Vector2i, bool] = {
	Vector2i(18, 10): true,
	Vector2i(19, 10): true,
	Vector2i(20, 10): true,
	Vector2i(20, 9): true,
	Vector2i(19, 8): true
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

const WAIT_TIME_BASE := 0.1
var wait_time := WAIT_TIME_BASE
var time_elapsed := 0.0

var paused := true

func _ready() -> void:
	for coords in live_cells:
		grid.set_cell_state(coords, true)

func _physics_process(delta: float) -> void:
	if not paused:
		time_elapsed += delta
		if time_elapsed >= wait_time:
			evolve()
			time_elapsed = 0.0
	
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
		live_cells[coords] = true
	else:
		live_cells.erase(coords)

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
			grid.set_cell_state(coords, false)
			live_cells.erase(coords)
		elif num_neighbours[coords] == 3 and not coords in live_cells:
			grid.set_cell_state(coords, true)
			live_cells[coords] = true

func _on_hud_play() -> void:
	paused = false

func _on_hud_pause() -> void:
	paused = true
	time_elapsed = 0.0

func _on_hud_change_speed(new_value: float) -> void:
	wait_time = WAIT_TIME_BASE / new_value

func _on_hud_clear() -> void:
	for cell in live_cells:
		grid.set_cell_state(cell, false)
	live_cells.clear()
