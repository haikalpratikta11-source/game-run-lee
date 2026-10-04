extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var taken := false

func _ready() -> void:
	anim.play("spin")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if taken or not (body is CharacterBody2D):
		return
	taken = true
	Game.coins += 1          
	Fx.burst(global_position, Color(1.0, 0.85, 0.3), 14, 140.0, 0.5, Vector2.UP, 180.0, 3.0, 300.0)
	anim.play("collect")
	await anim.animation_finished
	queue_free()
