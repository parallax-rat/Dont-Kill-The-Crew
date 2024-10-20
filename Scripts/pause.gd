extends Label

@onready var unpause_sfx: AudioStreamPlayer = $"../Pause/Unpause"
@onready var pause_sfx: AudioStreamPlayer = $"../Pause/Pause"

#func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("pause"):
		#if get_tree().paused:
			#unpause()
		#else:
			#pause()

func _on_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pause()
	else:
		unpause()

func pause():
	get_tree().paused = true
	pause_sfx.play()
	show()

func unpause():
	get_tree().paused = false
	unpause_sfx.play()
	hide()
