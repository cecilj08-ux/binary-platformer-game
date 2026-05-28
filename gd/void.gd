extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player: body.death("fall")
	elif body is Enemy:
		body.emit_particle(body.fallParticles)
		await get_tree().create_timer(3).timeout
		body.queue_free()
	else: body.queue_free()
