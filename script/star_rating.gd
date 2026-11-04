class_name StarRating
extends Control

@export var stars: int = 0:
	set = set_stars
@export var max_stars: int = 3
@export var star_size: float = 26.0

const GAP := 6.0
const FILLED := Color(1.0, 0.85, 0.3)
const EMPTY := Color(0.25, 0.28, 0.42)

func _ready() -> void:
	custom_minimum_size = Vector2(max_stars * star_size + (max_stars - 1) * GAP, star_size)

func set_stars(value: int) -> void:
	stars = value
	queue_redraw()

func _draw() -> void:
	for i in max_stars:
		var center := Vector2(star_size * 0.5 + i * (star_size + GAP), star_size * 0.5)
		var color := FILLED if i < stars else EMPTY
		draw_colored_polygon(_star_points(center, star_size * 0.5), color)

func _star_points(center: Vector2, outer: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for k in 10:
		var radius := outer if k % 2 == 0 else outer * 0.45
		var angle := -PI / 2.0 + k * PI / 5.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	return points
