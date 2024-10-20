extends PointLight2D

func _ready() -> void:
	position = get_viewport().get_mouse_position()

func _physics_process(delta: float) -> void:
	print(global_position)
	print(get_viewport().get_mouse_position())
	position = get_viewport().get_mouse_position()
