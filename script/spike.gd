class_name spike
extends Area2D
func _ready():
	body_entered.connect(func(b): if b is Player: b.die())
