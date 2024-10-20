extends Node

const TEST_SIZE : Vector2i = Vector2i(512,512)

var camera_speeds = {
	"SLOW": 64,
	"MEDIUM": 128,
	"FAST": 192,
}

# MAIN MENU SETTINGS
var crt_shader : bool = true
var blood : bool = true
var camera_speed : float = camera_speeds["FAST"]

# SCENE CONTROL
var master_scene : Node
var pause_label : Label

func _ready():
	if OS.is_debug_build():
		testing_window(TEST_SIZE)


func testing_window(new_size) -> void:
	get_window().size = new_size
