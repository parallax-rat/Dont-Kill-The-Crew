extends Node2D

@export var crewmate : CharacterBody2D
@export var music : AudioStreamPlayer
@export var music_to_begin : AudioStreamPlayer
@onready var begin: AnimationPlayer = $Begin
@onready var debug_skip: Button = $DEBUG_SKIP

func _ready() -> void:
	if OS.is_debug_build():
		debug_skip.show()
		print("Showing Skip")
	else:
		debug_skip.hide()

func _on_control_gui_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("action"):
		crewmate.explode()
		music.stop()
		music_to_begin.play()
		begin.play("MainMenuBegin")

func start_game():
	Scenes.change_scene(Scenes.GAME)


func _on_debug_skip_pressed() -> void:
	start_game()
