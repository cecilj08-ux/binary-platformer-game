extends Collectible

@export var activates: Door

func _ready() -> void: activates.keys_required += 1
func collect() -> void:
	activates.keys_required -= 1 if activates.keys_required > 0 else 0
	activates.opened = true if activates.keys_required == 0 else false
	activates.frame = 1 if activates.opened else 0
	queue_free()
