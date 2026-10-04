extends Node

func burst(pos: Vector2, color: Color, amount: int = 10, speed: float = 80.0,
		life: float = 0.4, dir: Vector2 = Vector2.UP, spread: float = 60.0,
		size: float = 4.0, grav: float = 400.0) -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var p := CPUParticles2D.new()
	p.one_shot = true
	p.amount = amount
	p.lifetime = life
	p.explosiveness = 1.0
	p.direction = dir
	p.spread = spread
	p.initial_velocity_min = speed * 0.5
	p.initial_velocity_max = speed
	p.gravity = Vector2(0, grav)
	p.scale_amount_min = size * 0.6
	p.scale_amount_max = size
	var g := Gradient.new()                       
	g.set_color(0, color)
	g.set_color(1, Color(color.r, color.g, color.b, 0.0))
	p.color_ramp = g
	p.z_index = 10
	scene.add_child(p)
	p.global_position = pos
	p.emitting = true
	get_tree().create_timer(life + 0.3).timeout.connect(p.queue_free)
