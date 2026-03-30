extends RigidBody2D

var collisionU := false
var collisionD := false
var collisionL := false
var collisionR := false

var normal
var cancel_velocity := false

@onready var left_ray := $leftRay
@onready var right_ray := $rightRay
@onready var player := %player

func _physics_process(_delta: float) -> void:
	cancel_velocity = left_ray.is_colliding() and right_ray.is_colliding()
	player.set_collision_mask_value(6, cancel_velocity)

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if cancel_velocity: linear_velocity = Vector2.ZERO
	#for i in state.get_contact_count():
		#normal = state.get_contact_local_normal(i)
		#if normal.dot(Vector2.UP) > 0.5:
			#print("floor")
			#collisionU = true
		#elif normal.dot(Vector2.DOWN) > 0.5:
			#print("roof")
			#collisionD = true
		#elif normal.dot(Vector2.LEFT) > 0.5:
			#print("right wall")
			#collisionL = true
		#elif normal.dot(Vector2.RIGHT) > 0.5:
			#print("left wall")
			#collisionR = true
