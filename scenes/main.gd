extends Node2D

@onready var evolution_timer: Timer = $EvolutionTimer

var play: bool = false

var live_cells: Dictionary[Vector2i, int] = {Vector2i(0,3):0, Vector2i(1,3):0, Vector2i(2,3):0, Vector2i(2,2):0, Vector2i(1,1):0}

var neighbours = [
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
		$Grid.set_cell_state(coords, true)
	
	evolution_timer.start()

func _on_evolution_timer_timeout() -> void:
	if play:
		evolve()

func _on_hud_play() -> void:
	evolution_timer.start()
	play = true

func _on_hud_pause() -> void:
	evolution_timer.stop()
	play = false

## Flips live cells and their neighbours according to the game rules
func evolve() -> void:
	var num_neighbours: Dictionary[Vector2i, int] = {}
	var to_live: Array[Vector2i] = []
	var to_die: Array[Vector2i] = []
	var neighbour_coords: Vector2i
	
	for cell in live_cells:
		for n in neighbours:
			neighbour_coords = Vector2i(cell.x + n.x, cell.y + n.y)
			if neighbour_coords in num_neighbours:
				num_neighbours[neighbour_coords] += 1
			else:
				num_neighbours[neighbour_coords] = 1
			#print("cell", Vector2i(cell.x + n.x, cell.y + n.y), " has ", num_neighbours[Vector2i(cell.x + n.x, cell.y + n.y)], " neighbours")
	
	for coords in num_neighbours:
		if num_neighbours[coords] < 2 or num_neighbours[coords] > 3 and coords in live_cells:
			to_die.append(coords)
			#print(coords, " dies")
		elif num_neighbours[coords] == 3 and not coords in live_cells:
			to_live.append(coords)
			#print(coords, " lives")
	
	for coords in to_live:
		$Grid.set_cell_state(coords, true)
		live_cells[coords] = 0
	
	for coords in to_die:
		$Grid.set_cell_state(coords, false)
		live_cells.erase(coords)
