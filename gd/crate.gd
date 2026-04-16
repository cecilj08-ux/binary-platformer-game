extends RigidBody2D

var cancel_velocity := false

@onready var left_ray := $leftRay
@onready var right_ray := $rightRay
@onready var player := %player

func _physics_process(_delta: float) -> void:
	if not $topDetection.overlaps_body(player):
		if left_ray.get_collider() is TileMapLayer or right_ray.get_collider() is TileMapLayer: cancel_velocity = true
		elif left_ray.get_collider() is PhysicsBody2D and right_ray.get_collider() is PhysicsBody2D: cancel_velocity = true
		else: cancel_velocity = false
	set_collision_layer_value(1, cancel_velocity)
	set_collision_mask_value(1, cancel_velocity)
	left_ray.target_position.x = -6 if abs(linear_velocity.x) > 1 else -4
	right_ray.target_position.x = 6 if abs(linear_velocity.x) > 1 else 4

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void: if cancel_velocity: linear_velocity.x = 0


func _on_top_detection_body_entered(body: Node2D) -> void:
	if body is Player: cancel_velocity = true
func _on_top_detection_body_exited(body: Node2D) -> void:
	if body is Player: cancel_velocity = false
