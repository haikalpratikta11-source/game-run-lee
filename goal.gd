extends Area2D
@export_file("*.tscn") var next_scene: String
func _ready():
	body_entered.connect(func(b):
		if b is CharacterBody2D:
			get_tree().change_scene_to_file.call_deferred(next_scene))
