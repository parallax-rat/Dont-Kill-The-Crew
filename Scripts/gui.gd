extends Control

@onready var main_camera: Camera2D = $"../../../MainCamera"

func _process(delta: float) -> void:
	position = main_camera.position
