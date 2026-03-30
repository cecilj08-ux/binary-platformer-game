extends Enemy

@onready var left_ray := $leftRay
@onready var right_ray := $rightRay
@onready var detection := $detection/CollisionShape2D

var direction := 0.0
var lerpWeight : = 0.0
var acceleration := 5
var friction := 6

var jump_sprite := preload("res://resources/1bit slime platformer/alpha_bg/slime2_jump_a.png")

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
# Animation
	ani.speed_scale = 1+abs(velocity.x)*0.075
	if is_on_floor(): ani.play("walk" if target else "idle")
	elif not is_on_floor():
		ani.stop()
		sprite.texture = jump_sprite
		if velocity.y < -100: sprite.frame = 1
		elif velocity.y < 100: sprite.frame = 2
		elif velocity.y > 100: sprite.frame = 3
# Movement
	if target:
		aggressive = target.new_scale < scale
		sprite.flip_h = target.position.x < position.x
		if position.distance_to(target.position) < detection.shape.radius*0.6 and target.position.y+(8*scale.y) < position.y and can_jump and aggressive: velocity.y = -jump_power
		elif position.distance_to(target.position) < detection.shape.radius and (left_ray.is_colliding() or right_ray.is_colliding()) and can_jump: velocity.y = -jump_power
	can_jump = is_on_floor()
	if target: direction = -1 if target.position < position else 1
	else: direction = 0
	if not aggressive: direction *= -1
	lerpWeight = delta*(acceleration if direction else friction)
	velocity.x = lerp(velocity.x, direction*speed, lerpWeight)
	move_and_slide()
