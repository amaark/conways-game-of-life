extends CanvasLayer

signal play
signal pause

@onready var texture_button: TextureButton = $TextureButton

var paused := true

var play_texture_normal = preload("res://assets/play_button_normal.png")
var play_texture_pressed = preload("res://assets/play_button_pressed.png")
var pause_texture_normal = preload("res://assets/pause_button_normal.png")
var pause_texture_pressed = preload("res://assets/pause_button_pressed.png")

func _on_texture_button_pressed() -> void:
	if paused:
		play.emit()
		paused = false
		texture_button.texture_normal = pause_texture_normal
		texture_button.texture_pressed = pause_texture_pressed
	else:
		pause.emit()
		paused = true
		texture_button.texture_normal = play_texture_normal
		texture_button.texture_pressed = play_texture_pressed
