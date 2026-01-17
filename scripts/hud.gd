extends CanvasLayer

signal play
signal pause

@onready var texture_button: TextureButton = $TextureButton


func _on_texture_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		play.emit()
	else:
		pause.emit()
