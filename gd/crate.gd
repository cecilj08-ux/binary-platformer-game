class_name Crate extends RigidBody2D

var cancel_velocity := false
@onready var left_ray := $leftRay
@onready var left_ray_2 := $leftRay2
@onready var left_ray_3 := $leftRay3
@onready var right_ray := $rightRay
@onready var right_ray_2 := $rightRay2
@onready var right_ray_3 := $rightRay3
@onready var top_collision = $topCollision
@onready var sprite := $sprite
@onready var ani := $sprite/AnimationPlayer
@export var frozen := false

func _ready() -> void:
	if frozen:
		ani.play("ice_ani")
		physics_material_override.friction = 0.1
	for i in get_children(): i.scale = scale
	left_ray.position.y = (4*scale.y) - 0.5
	left_ray_3.position.y = -(4*scale.y) + 0.5
	right_ray.position.y = (4*scale.y) - 0.5
	right_ray_3.position.y = -(4*scale.y) + 0.5

func _physics_process(_delta: float) -> void:
	if left_ray.get_collider() is TileMapLayer or right_ray.get_collider() is TileMapLayer: cancel_velocity = true
	elif left_ray.get_collider() is PhysicsBody2D and right_ray.get_collider() is PhysicsBody2D: cancel_velocity = true
	else: cancel_velocity = false
	if left_ray_2.get_collider() is TileMapLayer or right_ray_2.get_collider() is TileMapLayer: cancel_velocity = true
	elif left_ray_3.get_collider() is TileMapLayer or right_ray_3.get_collider() is TileMapLayer: cancel_velocity = true
	set_collision_layer_value(1, cancel_velocity)
	set_collision_mask_value(1, cancel_velocity)
	left_ray.target_position.x = linear_velocity.x/16 if linear_velocity.x < -64 else -4.0
	right_ray.target_position.x = linear_velocity.x/16 if linear_velocity.x > 64 else 4.0

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if cancel_velocity: linear_velocity.x = 0

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D: body.speed *= ((body.scale.x/top_collision.scale.x)*0.5) if body.scale.x <= top_collision.scale.x else 1
func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D: body.speed *= ((top_collision.scale.x/body.scale.x)*2) if body.scale.x <= top_collision.scale.x else 1
