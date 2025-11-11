extends Camera2D

const MIN_ZOOM := Vector2(1.0, 1.0)
const MAX_ZOOM := Vector2(3.0, 3.0)

@export var camera_home_position := Vector2(128, 128)
@export var move_speed := 160
@export var zoom_speed := 0.75

var can_zoom: bool = true
var zoom_speed_vector: Vector2
var zoom_target: Vector2

var can_move: bool = true
var direction: Vector2

var camera_stream = LogStream.new("Camera")


func _init() -> void:
	# Create a vector based on the exported zoom_speed
	zoom_speed_vector = Vector2(zoom_speed, zoom_speed)
	zoom_target = zoom
	position = camera_home_position


func _process(delta: float) -> void:
	if can_move:
		global_position = global_position + direction * move_speed * delta

	if can_zoom:
		zoom = zoom.lerp(zoom_target, 1 * delta)

	snap_in_limit()


func snap_in_limit():
	## this code only works correctly when "Camera2D.anchor_mode" is Drag Center.

	# scaled center of the viewport
	var viewport_half_x = get_viewport_rect().size.x / 2 * (1 / zoom.x)
	var viewport_half_y = get_viewport_rect().size.y / 2 * (1 / zoom.y)

	# offset the limits to acount for the viewport size
	var new_limit_left = limit_left + viewport_half_x
	var new_limit_top = limit_top + viewport_half_y
	var new_limit_right = limit_right - viewport_half_x
	var new_limit_bottom = limit_bottom - viewport_half_y

	# clamp the Camera2D's global_position between the new limits.
	var new_x = clamp(global_position.x, new_limit_left, new_limit_right)
	var new_y = clamp(global_position.y, new_limit_top, new_limit_bottom)

	global_position = Vector2(new_x, new_y)


func _unhandled_input(event: InputEvent) -> void:
	# set zoom_direction to either 1.0 or -1.0 depending on zoom in or out
	if event.is_action_pressed("camera_zoom_in") or event.is_action_pressed("camera_zoom_out"):
		var zoom_direction := Input.get_axis("camera_zoom_out", "camera_zoom_in")
		zoom_target = zoom + (zoom_speed_vector * zoom_direction)
		camera_stream.info("zoom_target before clamp: " + str(zoom_target))
		zoom_target = clamp(zoom_target, MIN_ZOOM, MAX_ZOOM)
		camera_stream.info("zoom_target after clamp: " + str(zoom_target))

	## Get camera move direction
	var x_direction := Input.get_axis("camera_left", "camera_right")
	var y_direction := Input.get_axis("camera_up", "camera_down")
	direction = Vector2(x_direction, y_direction)
