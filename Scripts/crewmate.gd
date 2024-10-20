extends CharacterBody2D

enum {IDLE, BUSY}
enum {GOOD, BAD}

const NORM_SCALE = Vector2(1,1)
const DECAY_SCALE = Vector2(1,0.1)
const DECAY_Y_MOD = 4.75

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var name_label: Label = $ProgressBar/NameLabel
@onready var job_timer: Timer = $JobTimer
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var gib: CPUParticles2D = $CPUParticles2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_oughh: AudioStreamPlayer2D = $AudioStreamPlayer2D_Oughh
@onready var decay_timer: Timer = $DecayTimer
@onready var point_light_2d: PointLight2D = $PointLight2D

@export_category("Misc")
@export var is_menu_prop : bool = false
@export var sentient : bool = true
@export var movement_speed: float = 30
@export var random_colors : PackedColorArray
@export var dead_color: Color
@export var debug_good_and_bad_colors : bool

var movement_target_position: Vector2
var alive : bool = true
var state = IDLE
var style : int
var current_job
var working_on_job


func _ready():
	customize_crewmate()
	sprite.animation = "idle"
	if !sentient:
		return
	call_deferred("actor_setup")

func customize_crewmate():
	name = Crew.crew_names.pick_random()
	Crew.crew_names.erase(name)
	if name_label:
		name_label.text = name
	style = randi_range(GOOD,BAD)
	movement_speed = randi_range(20,30)
	if style == GOOD:
		Crew.crew_alive.append(self)
		Crew.total_crew = Crew.total_crew + 1
		if debug_good_and_bad_colors:
			sprite.modulate = Color.GREEN
		else:
			var new_color = randi_range(0,7)
			sprite.modulate = random_colors[new_color]
	elif style == BAD:
		Crew.imposter_alive.append(self)
		Crew.total_imposter = Crew.total_imposter + 1
		if debug_good_and_bad_colors:
			sprite.modulate = Color.RED
		else:
			var new_color = randi_range(0,7)
			sprite.modulate = random_colors[new_color]
	point_light_2d.color = sprite.modulate
	navigation_agent.debug_path_custom_color = modulate

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func _process(delta: float) -> void:
	progress_bar.value = job_timer.time_left


func _physics_process(_delta):
	#if navigation_agent.is_navigation_finished():
		#return
	
	if alive and sentient and current_job:
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		
		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		
		if velocity.x > 0:
			sprite.flip_h = false
		if velocity.x < 0:
			sprite.flip_h = true
		move_and_slide()

func set_movement_target(movement_target: Vector2):
	if alive and sentient:
		navigation_agent.target_position = movement_target
		sprite.animation = "walk"

func _on_navigation_agent_2d_target_reached() -> void:
	print(name + " 's Target Reached.")
	if current_job:
		start_work()

func give_job():
	print(name + " getting job")
	current_job = get_tree().get_nodes_in_group("Events").pick_random()
	set_movement_target(current_job.position)

#func check_for_job() -> Node:
	#var new_job
	#for job in get_tree().get_nodes_in_group("Events"):
		#if job.has_owner == false:
			#new_job.has_owner
			#return new_job
		#else:
			#return null
	#return new_job


func start_work():
	if style == GOOD:
		print(name + " fixing " + current_job.name)
	if style == BAD:
		print(name + " breaking " + current_job.name)
	job_timer.start()
	working_on_job = current_job
	current_job = null
	set_movement_target(position)


func _on_job_timer_timeout() -> void:
	print(name + " 's Job Timer expired.")
	if working_on_job:
		working_on_job.complete(style)
		working_on_job.has_owner = false
	if current_job:
		current_job = null
	working_on_job = null
	give_job()


func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("action") and alive:
		explode()


func explode() -> void:
	collision_layer = 0
	audio.play()
	await get_tree().create_timer(0.1).timeout
	sprite.animation = "death"
	alive = false
	if !Crew.crew_killed.has(self):
		Crew.crew_killed.append(self)
	if Crew.crew_alive.has(self):
		Crew.crew_alive.erase(self)
	if sentient:
		navigation_agent.queue_free()
	if Settings.blood:
		modulate = dead_color
		gib.emitting = true
	else:
		modulate = Color.DIM_GRAY
	audio_oughh.play()
	print_rich(name + "[color=red][b] died![/b][/color]")
	Crew.check_crew()
	if !is_menu_prop:
		decay_timer.start()


func deny_entry():
	if navigation_agent.is_target_reachable():
		set_movement_target(current_job.position)
	else: 
		print_debug(name + "'s target Not Reachable, getting new current_job")
		give_job()
	

func _on_decay_timer_timeout() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self,"modulate:a",0.0,2.0)
	#tween.tween_property(sprite,"global_position:y",global_position.y + DECAY_Y_MOD,2.0)
	#tween.tween_property(sprite,"scale",DECAY_SCALE,2.0)
	await get_tree().create_timer(2.0).timeout
	queue_free()
