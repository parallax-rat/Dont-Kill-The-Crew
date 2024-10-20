extends Node

const MAIN_MENU = preload("res://Scenes/MainMenu.tscn")
const GAME = preload("res://Scenes/Game.tscn")
const VICTORY = preload("res://Scenes/Victory.tscn")
const GAME_OVER = preload("res://Scenes/GameOver.tscn")
const FIRE = preload("res://Scenes/Objects/fire.tscn")

# Scene Variables
var master_scene
var game_viewport
var current_scene
var previous_scene
var destroyed_events = []

func change_scene(new_scene : PackedScene):
	if new_scene == Scenes.MAIN_MENU:
		master_scene.hud_overlay.visible = false
	else:
		master_scene.hud_overlay.visible = true
	if current_scene:
		previous_scene = current_scene
	current_scene = new_scene
	current_scene = current_scene.instantiate()
	game_viewport.add_child(current_scene)
	#current_scene.get_child(0).enabled = true
	
	if previous_scene:
		previous_scene.queue_free()
		#previous_scene.process_mode = Node.PROCESS_MODE_DISABLED
		#previous_scene.visible = false
		#previous_scene.get_child("Camera2D").enabled = true

func check_events():
	if destroyed_events.size() >= 10:
		Scenes.change_scene(GAME_OVER)
