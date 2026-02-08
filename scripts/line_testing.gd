extends Node

var a := Vector2i(44, 297)
var b := Vector2i(109654, 54834)


func _ready() -> void:
	run_test(a, b)


func run_test(a: Vector2i, b: Vector2i):
	var startTime1 = Time.get_ticks_usec()
	linear_interpolate(a, b)
	var endTime1 = Time.get_ticks_usec()
	var duration1 = (endTime1 - startTime1) * 10e-6
	print("Linear interpolation time = %.6f" % [duration1])

	var startTime2 = Time.get_ticks_usec()
	get_line(a, b)
	var endTime2 = Time.get_ticks_usec()
	var duration2 = (endTime2 - startTime2) * 10e-6
	print("Bresenham time = %.6f" % [duration2])


func linear_interpolate(a: Vector2i, b: Vector2i):
	var distance: Vector2i = b - a
	var cells: Array[Vector2i]
	for i in distance.length():
		cells.append(Vector2i(Vector2(b).lerp(a, i / distance.length())))
	return cells


func get_line(a: Vector2i, b: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i]

	if abs(b.y - a.y) < abs(b.x - a.x):
		if a.x > b.x:
			cells = get_line_low(b, a)
		else:
			cells = get_line_low(a, b)
	else:
		if a.y > b.y:
			cells = get_line_high(b, a)
		else:
			cells = get_line_high(a, b)

	return cells


func get_line_high(a: Vector2i, b: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i]
	var dx = b.x - a.x
	var dy = b.y - a.y
	var xi = 1

	if dx < 0:
		xi = -1
		dx = -dx

	var diff = (2 * dx) - dy
	var x = a.x

	for y in range(a.y, b.y):
		cells.append(Vector2i(x, y))
		if diff > 0:
			x = x + xi
			diff += 2 * (dx - dy)
		else:
			diff += 2 * dx

	return cells


func get_line_low(a: Vector2i, b: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i]
	var dx = b.x - a.x
	var dy = b.y - a.y
	var yi = 1

	if dy < 0:
		yi = -1
		dy = -dy

	var diff = (2 * dy) - dx
	var y = a.y

	for x in range(a.x, b.x):
		cells.append(Vector2i(x, y))
		if diff > 0:
			y = y + yi
			diff += 2 * (dy - dx)
		else:
			diff += 2 * dy

	return cells
