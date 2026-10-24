class_name Goal
extends Area2D
@export_file("*.tscn") var next_scene: String
func _ready():
	body_entered.connect(func(b):
		if b is Player:
			Audio.play("win")
			get_tree().change_scene_to_file.call_deferred(next_scene))
