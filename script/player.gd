class_name Player
extends CharacterBody2D

const SPEED := 230.0
const GRAVITY := 1800.0
const MAX_FALL := 900.0
const JUMP_V := -620.0
const AIR_JUMP_V := -560.0
const DASH_SPEED := 520.0

const PURPLE := Color(0.62, 0.40, 0.90)   
const WHITE := Color(1.0, 1.0, 1.0, 0.9)  
const RED := Color(1.0, 0.35, 0.42)       

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var coyote := 0.0
var buffer := 0.0
var jumps := 0
var dash_t := 0.0
var dash_cd := 0.0
var trail_t := 0.0
var step_t := 0.0
var face := 1
var dead := false
var spawn_pos: Vector2

func _ready() -> void:
	spawn_pos = global_position
	anim.play("idle")

func _feet() -> Vector2:
	return global_position + Vector2(0, 14)

func _physics_process(delta: float) -> void:
	if dead:
		return

	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0.0:
		face = int(sign(dir))

	dash_cd -= delta
	if Input.is_action_just_pressed("dash") and dash_cd <= 0.0:
		dash_t = 0.15
		dash_cd = 0.6
		Fx.burst(global_position, PURPLE, 12, 140.0, 0.3, Vector2(-face, 0), 40.0, 4.0, 0.0)
		Audio.play("dash")

	if dash_t > 0.0:
		dash_t -= delta
		velocity = Vector2(face * DASH_SPEED, 0.0)
		trail_t -= delta
		if trail_t <= 0.0:                         
			trail_t = 0.03
			Fx.burst(global_position, WHITE, 3, 20.0, 0.25, Vector2.UP, 180.0, 5.0, 0.0)
	else:
		var accel := 4000.0 if is_on_floor() else 2200.0
		velocity.x = move_toward(velocity.x, dir * SPEED, accel * delta)
		velocity.y = min(velocity.y + GRAVITY * delta, MAX_FALL)

	if is_on_floor():
		coyote = 0.1
		jumps = 0
	else:
		coyote -= delta
		if coyote <= 0.0 and jumps == 0:
			jumps = 1

	if Input.is_action_just_pressed("jump"):
		buffer = 0.12
	buffer -= delta

	if buffer > 0.0:
		if coyote > 0.0:
			velocity.y = JUMP_V
			jumps = 1
			buffer = 0.0
			coyote = 0.0
			Fx.burst(_feet(), PURPLE, 8, 90.0, 0.35, Vector2.UP, 70.0, 4.0, 300.0)
			Audio.play("jump")
		elif jumps < 2:
			velocity.y = AIR_JUMP_V
			jumps = 2
			buffer = 0.0
			Fx.burst(_feet(), WHITE, 14, 120.0, 0.4, Vector2.DOWN, 90.0, 4.0, 200.0)
			Audio.play("double_jump")

	if Input.is_action_just_released("jump") and velocity.y < -250.0:
		velocity.y = -250.0

	if is_on_floor() and abs(velocity.x) > 20.0:
		step_t -= delta
		if step_t <= 0.0:
			step_t = 0.25
			Fx.burst(_feet(), PURPLE, 3, 40.0, 0.3, Vector2(-face, -0.5), 40.0, 3.0, 200.0)

	var was_on_floor := is_on_floor()
	var vy_before := velocity.y
	move_and_slide()

	if is_on_floor() and not was_on_floor and vy_before > 300.0:
		Fx.burst(_feet(), PURPLE, 10, 110.0, 0.4, Vector2.UP, 80.0, 4.0, 300.0)
		Audio.play("land")

	_update_animation()

	if global_position.y > 800.0:
		die()

func _update_animation() -> void:
	anim.flip_h = (face < 0)
	if dash_t > 0.0:
		anim.play("dash")
	elif not is_on_floor():
		anim.play("jump" if velocity.y < 0.0 else "fall")
	elif abs(velocity.x) > 20.0:
		anim.play("walk")
	else:
		anim.play("idle")

func die() -> void:
	if dead:
		return
	dead = true
	Game.deaths += 1
	Fx.burst(global_position, RED, 30, 260.0, 0.7, Vector2.UP, 180.0, 4.0, 600.0)
	Audio.play("die")
	visible = false
	await get_tree().create_timer(0.6).timeout
	if Game.deaths >= Game.MAX_DEATHS:                  # (2) baru
		get_tree().change_scene_to_file.call_deferred("res://scenes/lose.tscn")
		return
	global_position = spawn_pos
	velocity = Vector2.ZERO
	visible = true
	dead = false
