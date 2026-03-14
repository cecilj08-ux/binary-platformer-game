class_name Player extends CharacterBody2D

@onready var sprite := $playerSprite
@onready var ani := $playerSprite/AnimationPlayer
@onready var coyoteTime := $coyoteTimer
@onready var eatingParticles := $eatingParticles
@onready var oobParticles := $oobParticles
@onready var camera := $Camera2D
@onready var new_scale := scale # NOTE: Use this instead of scale unless its visual-related

const jump_power := 220
const acceleration := 5
const friction := 6
const fallspeed_cap := 600

var speed := 120.0
var direction := 0.0
var lerpWeight := 0.0
var can_walk := true
var can_jump := false
var was_on_wall := false

var jump_sprite := preload("res://resources/1bit slime platformer/hybrid_bg/slime_jump_h.png")
var walk_sprite := preload("res://resources/1bit slime platformer/hybrid_bg/slime_walk_h.png")
# TODO: make the sprite change when hanging on a wall
var flipped_walk_sprite := preload("res://resources/1bit slime platformer/hybrid_bg/slime_walk_h_flipped.png")

func death() -> void:
	set_collision_layer_value(5, false)
	$playerHitbox.set_collision_mask_value(5,false)
	sprite.visible = false
	can_walk = false
	can_jump = false
	velocity = Vector2.ZERO
	oobParticles.amount = round(8*scale.x)
	oobParticles.initial_velocity_min /= scale.x
	oobParticles.initial_velocity_max /= scale.x
	oobParticles.restart()
	await get_tree().create_timer(2.5).timeout
	get_tree().reload_current_scene.call_deferred()

func _ready() -> void: camera.limit_bottom = %oob.position.y-(new_scale.y*8)

func _physics_process(delta: float) -> void:
# Gravity
	if (not is_on_floor()) and (not is_on_wall()): velocity += get_gravity() * (delta if Input.is_action_pressed("up") else delta*3)
	elif is_on_wall_only():
		velocity.y = 30 if Input.is_action_pressed("down") else 0
		was_on_wall = true
	elif is_on_floor(): was_on_wall = false
	if velocity.y > fallspeed_cap: velocity.y = fallspeed_cap
# Coyote Timing
	if is_on_floor() or is_on_wall(): coyoteTime.start()
	can_jump = coyoteTime.time_left != 0 and velocity.y >= 0 and sprite.visible
# Jump
	if Input.is_action_just_pressed("up") and can_jump:
		if is_on_wall_only():
			sprite.flip_h = not sprite.flip_h
			velocity += Vector2(-120 if sprite.flip_h else 120, -jump_power*0.66)
		elif was_on_wall: velocity += Vector2(-120 if sprite.flip_h else 120, -(jump_power*0.66) - velocity.y)
		else: velocity.y = -jump_power
# Movement
	direction = Input.get_axis("left", "right") if can_walk else 0.0
	lerpWeight = delta*(acceleration if direction else friction)
	velocity.x = lerp(velocity.x, direction*speed, lerpWeight)
	move_and_slide()
# Animation
	if velocity.x < 0 and not is_on_wall(): sprite.flip_h = true
	elif velocity.x > 0 and not is_on_wall(): sprite.flip_h = false
	ani.speed_scale = 1+abs(velocity.x)*0.075
	if (velocity.x < 10 and velocity.x > -10) and is_on_floor(): ani.play("idle")
	else:
	# Midair Animation
		if not is_on_floor():
			ani.stop()
			sprite.texture = jump_sprite
			if velocity.y < -100: sprite.frame = 1
			elif velocity.y < 100: sprite.frame = 2
			elif velocity.y > 100: sprite.frame = 3
		elif direction: ani.play("walk")
# Size scaling
	if new_scale != scale:
		scale = lerp(scale, new_scale, delta*4)
	# TODO: See if this can be done in a less hacky way
		if scale + Vector2(0.000001,0.000001) == new_scale: scale += Vector2(0.000001,0.000001)

func _on_coyote_timer_timeout() -> void: was_on_wall = false

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if new_scale >= body.scale:
			if new_scale: new_scale += body.scale/2
			else: new_scale = scale + body.scale/2
			speed /= new_scale.x * 0.8
			camera.limit_bottom = %oob.position.y-(new_scale.y*8)
			eatingParticles.restart()
			body.queue_free()
		else:
			camera.reparent(body)
			death()

func _on_crate_detection_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.set_collision_layer_value(1, true)
		body.set_collision_mask_value(1, true)
func _on_crate_detection_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		body.set_collision_layer_value(1, false)
		body.set_collision_mask_value(1, false)
