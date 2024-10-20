extends PointLight2D

enum TYPE {PULSE, STROBE, STATIC}

@export var type : TYPE
@export_range(0.5,3.0) var energy_min : float = 0.5
@export_range(0.5,3.0) var energy_max : float = 1.5
@export_range(0.1,3.0) var anim_duration : float = 1.5

func _ready():
	if type == TYPE.PULSE:
		energy = energy_min

func _process(_delta: float) -> void:
	if energy == energy_min :
		var tween = create_tween()
		tween.tween_property(self,"energy",energy_max,anim_duration)
	elif energy == energy_max:
		var tween = create_tween()
		tween.tween_property(self,"energy",energy_min,anim_duration)
