extends Camera2D

@export var zoom_speed := 10.0
var zoom_target: Vector2

@export var pan_speed := 1000.0

var drag_start_mouse_pos := Vector2.ZERO
var drag_start_camera_pos := Vector2.ZERO
var dragging := false

func _ready() -> void:
	zoom_target = zoom

func _process(delta: float) -> void:
	zoom_camera(delta)
	pan(delta)
	click_and_drag()

func zoom_camera(delta: float):
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom_target *= 1.1
		if zoom_target > Vector2(2.5, 2.5):
			zoom_target = Vector2(2.5, 2.5)
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom_target *= 0.9
		if zoom_target < Vector2(0.05, 0.05):
			zoom_target = Vector2(0.05, 0.05)
		
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)

func pan(delta: float):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("camera_move_up"):
		direction.y -= 1
	if Input.is_action_pressed("camera_move_down"):
		direction.y += 1
	if Input.is_action_pressed("camera_move_right"):
		direction.x += 1
	if Input.is_action_pressed("camera_move_left"):
		direction.x -= 1
	
	direction = direction.normalized()
	position += direction * delta * pan_speed * (1/zoom.x)
	
func click_and_drag():
	if not dragging and Input.is_action_just_pressed("camera_pan"):
		drag_start_mouse_pos = get_viewport().get_mouse_position()
		drag_start_camera_pos = position
		dragging = true
	
	elif dragging:
		if Input.is_action_just_released("camera_pan"):
			dragging = false
		else:
			var move_vector := get_viewport().get_mouse_position() - drag_start_mouse_pos
			position = drag_start_camera_pos - move_vector * (1/zoom.x)
