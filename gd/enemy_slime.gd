extends Enemy

var jump_sprite := preload("res://resources/1bit slime platformer/alpha_bg/slime2_jump_a.png")

func _physics_process(delta: float) -> void:
	gravitation(delta)
# Animation
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
		sprite.flip_h = true if target.position.x < position.x else false
		position.x = move_toward(position.x, target.position.x, delta*(speed if aggressive else -speed))
	# Jumping. I wish this if statement wasn't so long...
		if position.distance_to(target.position) < 40 and target.position.y+10 < position.y and can_jump and aggressive: velocity.y = -jump_power
	can_jump = is_on_floor_only()
	move_and_slide()
