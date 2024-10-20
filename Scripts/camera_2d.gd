extends Camera2D

#const CAMERA_


const CAMERA_LIMIT_256 = Vector4(-64.0,-64.0,320.0,320.0)
const CAMERA_LIMIT_DEFAULT = Vector4(-10000000,-10000000,10000000,10000000)
const MAP_64_POSITION = Vector2(352,32)

#@export var zMin = Vector2(0.25,0.25)
#@export var zMax = Vector2(0.5,0.5)
@export var drag_speed = 160

@onready var display_map : bool = false

var can_zoom : bool = true
var can_move : bool = true
var pre_zoom_position = null
var move_tween
var zoom_tween

func _process(delta: float) -> void:
	if can_move:
		if Input.is_action_pressed("camera_down",true):
			global_position = global_position + Vector2.DOWN * drag_speed * delta
	
		if Input.is_action_pressed("camera_up",true):
			global_position = global_position + Vector2.UP * drag_speed * delta
	
		if Input.is_action_pressed("camera_left",true):
			global_position = global_position + Vector2.LEFT * drag_speed * delta
	
		if Input.is_action_pressed("camera_right",true):
			global_position = global_position + Vector2.RIGHT * drag_speed * delta
	
	snap_in_limit()
	
#func zoom_camera():
	#can_zoom = false
	#if ship_map_64.visible:
		#ship_map_64.visible = false
		#limit_right = 256
		#if pre_zoom_position != null:
			#position = pre_zoom_position
			#await get_tree().create_timer(0.2).timeout
		#position_smoothing_enabled = true
		#can_move = true
	#else:
		#ship_map_64.visible = true
		#limit_right = 512
		#position_smoothing_enabled = false
		#pre_zoom_position = position
		#position = MAP_64_POSITION
		#can_move = false
	#await get_tree().create_timer(0.5).timeout
	#can_zoom = true

func snap_in_limit():
	#this code only works correctly when "Camera2D.anchor_mode" is Drag Center.
	
	#scaled center of the viewport 
	var viewport_half_x = get_viewport_rect().size.x/2 * (1 / zoom.x)
	var viewport_half_y = get_viewport_rect().size.y/2 * (1 / zoom.y)
	
	#we offset the limits to acount for the viewport size
	var new_limit_left = limit_left+viewport_half_x
	var new_limit_top = limit_top+viewport_half_y
	var new_limit_right = limit_right-viewport_half_x
	var new_limit_bottom = limit_bottom-viewport_half_y
	
	#clamp the Camera2D's global_position between the new limits.
	var new_x = clamp(global_position.x, new_limit_left,new_limit_right)
	var new_y = clamp(global_position.y, new_limit_top,new_limit_bottom)
	
	global_position = Vector2(new_x,new_y)
