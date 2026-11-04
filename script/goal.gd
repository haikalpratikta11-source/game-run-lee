class_name Goal
extends Area2D

var _done := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if _done or not (body is Player):
		return
	_done = true
	Game.complete_level()
	Audio.play("win")
	Fx.burst(global_position, Color(0.49, 1.0, 0.69), 24, 220.0, 0.6, Vector2.UP, 180.0, 4.0, 500.0)
	get_tree().change_scene_to_file.call_deferred("res://scenes/victory.tscn")
