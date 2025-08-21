extends Node

@onready var mission_progress_bar: TextureProgressBar = %MissionProgressBar
@onready var crt_shader: Control = $"CRT Shader"
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@export var hud_overlay: Control
@export var default_scene : PackedScene
@export var progress_bar : TextureProgressBar


#var scenes : Dictionary
#var current_scene
#var previous_scene
#
#var cameras : Dictionary
#var current_camera
#var previous_camera

func _ready() -> void:
	Scenes.master_scene = self
	Scenes.game_viewport = sub_viewport
	#for scene in get_tree().get_nodes_in_group("Game Scenes"):
		#var scene_name = scene.name
		#scenes[scene_name] = scene
	#if !default_scene:
		#push_warning("NO DEFAULT SCENE SET IN MAIN_GAME_ROOT")
	#for camera in get_tree().get_nodes_in_group("Cameras"):
		#var camera_name = camera.name
		#cameras[camera_name] = camera 
	call_deferred("_setup")

func _setup() -> void:
	Scenes.change_scene(default_scene)
#func change_scene(new_scene):
	#if current_scene:
		#previous_scene = current_scene
	#current_scene = scenes[new_scene]
	#
	#current_scene.process_mode = Node.PROCESS_MODE_PAUSABLE
	#current_scene.visible = true
	#change_camera(new_scene)
	#
	#if previous_scene:
		#previous_scene.process_mode = Node.PROCESS_MODE_DISABLED
		#previous_scene.visible = false
#
	#if current_scene == scenes[Settings.MAIN_MENU]:
		#hud_overlay.visible = false
	#else:
		#hud_overlay.visible = true
#
#
#func change_camera(new_camera):
	#if current_camera:
		#previous_camera = current_camera
		#previous_camera.enabled = false
	#current_camera = new_camera
	#
	#current_camera.enabled = true

func _on_unlock_all_doors_pressed() -> void:
	for door in get_tree().get_nodes_in_group("Doors"):
		if door.locked:
			door.unlock()
		if !door.open:
			door._open()


func _on_lock_all_doors_pressed() -> void:
	for door in get_tree().get_nodes_in_group("Doors"):
		if door.locked:
			door.unlock()
		if door.open:
			door._close()
		if !door.locked:
			door.lock()


func DEBUG_KILL_ALL() -> void:
	for crew in get_tree().get_nodes_in_group("Crew"):
		crew.explode()


func DEBUG_PRINT_ALIVE() -> void:
	print(Crew.crew_killed)
