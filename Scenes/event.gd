extends Marker2D

enum {GOOD, BAD}
var burning : bool = false
var event_fire
var has_owner : bool = false
var destroyed : bool

@onready var event_timer: Timer = $EventTimer

func complete(style):
	match style:
		GOOD:
			if burning:
				if !event_timer.is_stopped():
					event_timer.stop()
				for node in get_children():
					if node.has_meta("Fire"):
						remove_child(node)
				burning = false
		BAD:
			if event_timer.is_stopped():
				event_timer.start()
			event_fire = Scenes.FIRE.instantiate()
			add_child(event_fire)
			burning = true

func _on_event_timer_timeout() -> void:
	print(name + " destroyed.")
	remove_from_group("Events")
	destroyed = true
	Scenes.destroyed_events.append(self)
	Scenes.check_events()
