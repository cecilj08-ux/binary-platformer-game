extends StaticBody2D

@export var one_shot := false
@export var activates: Node2D
@onready var sprite := $Sprite2D
var pressed := false
var total_collisions := 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Player and body.new_scale >= scale) or (body is CharacterBody2D or RigidBody2D and body.scale >= scale):
		total_collisions += 1
		sprite.frame = 1
		pressed = true
		set_collision_layer_value(1, false)
		set_collision_layer_value(6, false)
		if one_shot:
			if activates is Door: activates.open()
			await get_tree().create_timer(1.5).timeout
			queue_free()
		else:
			if activates is Door: activates.open()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D or RigidBody2D and pressed and not one_shot:
		total_collisions -= 1
		if total_collisions > 0: return
		sprite.frame = 0
		pressed = false
		set_collision_layer_value(1, true)
		set_collision_layer_value(6, true)
		if not one_shot:
			if activates is Door: activates.close()
			
