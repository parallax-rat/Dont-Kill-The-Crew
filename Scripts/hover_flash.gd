extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var hover : bool = false

func _on_mouse_entered() -> void:
	hover = true

func _on_mouse_exited() -> void:
	hover = false

func _process(_delta: float) -> void:
	if hover:
		animation_player.play("highlight")
	else:
		if animation_player.is_playing():
			animation_player.play("RESET")
