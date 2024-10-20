extends Node2D

@export var locked : bool

@onready var door = $CrewArea
@onready var click_area: Area2D = $ClickArea
@onready var anim = $AnimationPlayer
@onready var open_sfx = $OpenSFX
@onready var close_sfx = $CloseSFX
@onready var auto_close_delay: Timer = $AutoCloseDelay
@onready var open = false
@onready var lock_status: ColorRect = $Sprite2D/LockStatus

var crew_in_range : Array = []

func _process(_delta: float) -> void:
	if locked:
		lock_status.color = Color.RED
	else:
		lock_status.color = Color.GREEN

func _on_click(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("action") and !anim.is_playing():
		if open:
			_close()
		else:
			if !locked:
				_open()
			else:
				print("Door Locked")
	if Input.is_action_just_pressed("secondary_action"):
		if !open:
			if !locked:
				lock()
			else:
				unlock()

func _open() -> void:
	anim.play("open")
	open_sfx.play()
	print("Door opened.")
	open = true

func _close() -> void:
	anim.play_backwards("open")
	close_sfx.play()
	print("Door closed.")
	open = false

func lock():
	locked = true

func unlock():
	locked = false

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	var crew = body
	if crew.is_in_group("Crew"):
		crew_in_range.append(crew)
		if !locked:
			_open()
		else:
			crew.deny_entry()
			print("Door locked. Denied entry to " + str(body.name))


func _on_rigid_body_2d_body_exited(body: Node) -> void:
	if body.is_in_group("Crew"):
		print(str(body.name) + " leaving " + name + " range.")
		crew_in_range.erase(body)
	if crew_in_range.size() < 1 and auto_close_delay.is_stopped():
		auto_close_delay.start()


func _on_auto_close_delay_timeout() -> void:
	if crew_in_range.size() < 1:
		_close()
