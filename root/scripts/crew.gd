extends Node

var crew_names = [
	"Andy", 
	"Brett", 
	"Larry", 
	"Natasha", 
	"Stephanie",
	"Carl",
	"Randy",
	"Tanya",
	]
var crew_killed = []
var crew_alive = []
var imposter_killed = []
var imposter_alive = []
var events = []
var total_crew = 0
var total_imposter = 0


func check_crew() -> void:
	if crew_killed.size() >= 8:
		Scenes.change_scene(Scenes.GAME_OVER)


func _ready() -> void:
	for event in get_tree().get_nodes_in_group("Events"):
		events.append(event)
