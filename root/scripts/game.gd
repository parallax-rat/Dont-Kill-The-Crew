extends Node2D

var mission_progress_bar : TextureProgressBar
@onready var mission_progress_timer: Timer = $MissionProgressTimer
@onready var progress_sfx: AudioStreamPlayer = $ProgressSFX
@onready var game_start_timer: Timer = $GameStartTimer

func _ready() -> void:
	call_deferred("_setup_game")

func _setup_game():
	mission_progress_bar = Scenes.master_scene.mission_progress_bar
	mission_progress_bar.value_changed.connect(_on_mission_progress_bar_value_changed)

func _on_mission_progress_bar_timer_timeout() -> void:
	mission_progress_bar.value = mission_progress_bar.value + 2
	progress_sfx.play()


func _on_mission_progress_bar_value_changed(value: float) -> void:
	if value == 38:
		win()


func win():
	print_rich("[color=green][b]VICTORY[/b][/color]")
	Scenes.change_scene(Scenes.VICTORY)


func _on_game_start_timer_timeout() -> void:
	print("Game Start")
	for crew in get_tree().get_nodes_in_group("Crew"):
		crew.give_job()
