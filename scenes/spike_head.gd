extends Node2D

@export var speed := 120.0

@onready var enemy: Node2D = $Spike
@onready var points_root: Node = $PathPoints

var astar := AStar2D.new()
var markers: Array = []
var path: PackedVector2Array = PackedVector2Array()
var path_index := 0
var current_id := 0
var target_id := 0

func _ready():
	markers = points_root.get_children()
	for i in markers.size():
		astar.add_point(i, markers[i].global_position)
	for i in range(markers.size() - 1):
		astar.connect_points(i, i+1)
	enemy.global_position = markers[0].global_position
	_choose_new_target()
	
func _choose_new_target():
	target_id = (markers.size() - 1) if current_id == 0 else 0
	path = astar.get_point_path(current_id, target_id)
	path_index = 0
	
func _physics_process(delta):
	if path_index >= path.size():
		current_id = target_id
		_choose_new_target()
		return
	var target := path[path_index]
	enemy.global_position = enemy.global_position.move_toward(target, speed*delta)
	if enemy.global_position.distance_to(target) < 1.0:
		path_index += 1
