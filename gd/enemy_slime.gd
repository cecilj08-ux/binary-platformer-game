extends Enemy

@onready var left_ray := $leftRay
@onready var right_ray := $rightRay
@onready var down_ray := $downRay
@onready var detection := $detection/CollisionShape2D
@onready var eatParticles := $eatParticles
@onready var bleedParticles := $bleedParticles
@onready var fallParticles := $fallParticles

var direction := 0.0
var lerpWeight : = 0.0
var acceleration := 5
var friction := 6

var jump_sprite := preload("res://resources/1bit slime platformer/alpha_bg/slime2_jump_a.png")

func emit_particle(particle: GPUParticles2D) -> void:
	var emitted_particles := particle.duplicate()
	emitted_particles.position = position
	get_parent().add_child(emitted_particles)
	emitted_particles.restart()
	await emitted_particles.finished
	emitted_particles.queue_free()

func _ready() -> void:
	detection.shape.radius = detection_range

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
# Targeting
	if target:
		aggressive = target.new_scale < scale
		sprite.flip_h = target.position.x < position.x
	# Jumping and dropping
		if can_jump:
			if position.distance_to(target.position) < detection.shape.radius*0.6 and target.position.y+(8*scale.y) < position.y and aggressive: velocity.y = -(jump_power + (scale.x-1)*25)
			elif position.distance_to(target.position) < detection.shape.radius and (left_ray.is_colliding() or right_ray.is_colliding()): velocity.y = -(jump_power + (scale.x-1)*25)
			elif not down_ray.is_colliding(): velocity.y = -(jump_power + (scale.x-1)*25)
		if aggressive: set_collision_mask_value(4, not(position.distance_to(target.position) < detection.shape.radius and target.position.y-1 > position.y))
		else: set_collision_mask_value(4, not(position.distance_to(target.position) < detection.shape.radius*0.6 and target.position.y+(scale.y*8) < position.y))
	can_jump = is_on_floor()
	if target: direction = -1 if target.position < position else 1
	else: direction = 0
	if not aggressive: direction *= -1
# Movement
	lerpWeight = delta*(acceleration if direction else friction)
	velocity.x = lerp(velocity.x, direction*speed, lerpWeight)
	move_and_slide()

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body is TileMapLayer and body.name == "spikes":
		emit_particle(eatParticles)
func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body is TileMapLayer and body.name == "spikes":
		emit_particle(bleedParticles)
