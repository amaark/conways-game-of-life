extends CanvasLayer

signal play
signal pause
signal change_speed(new_value: float)
signal clear

@onready var play_button: TextureButton = $PlayButton

var paused := true

var play_texture_normal = preload("res://assets/play_button_normal.png")
var play_texture_pressed = preload("res://assets/play_button_pressed.png")
var pause_texture_normal = preload("res://assets/pause_button_normal.png")
var pause_texture_pressed = preload("res://assets/pause_button_pressed.png")

func _on_play_button_pressed() -> void:
	if paused:
		play.emit()
		paused = false
		play_button.texture_normal = pause_texture_normal
		play_button.texture_pressed = pause_texture_pressed
	else:
		pause.emit()
		paused = true
		play_button.texture_normal = play_texture_normal
		play_button.texture_pressed = play_texture_pressed

func _on_speed_slider_value_changed(value: float) -> void:
	change_speed.emit(value)

func _on_clear_button_pressed() -> void:
	clear.emit()
