extends Area2D
func _ready():
	body_entered.connect(func(b): if b.has_method("die"): b.die())
