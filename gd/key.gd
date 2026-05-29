extends Collectible

@export var activates: Node2D

func _ready() -> void: if activates is Door: activates.keys_required += 1
func collect() -> void:
	if activates is Door:
		activates.keys_required -= 1 if activates.keys_required > 0 else 0
		activates.opened = true if activates.keys_required == 0 else false
		activates.frame = 1 if activates.opened else 0
	elif activates is Gate: activates.opening = true
	queue_free()
