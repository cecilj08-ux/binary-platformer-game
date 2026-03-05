@abstract class_name Collectible extends Sprite2D

func collect() -> void: self.queue_free()
func _on_area_2d_body_entered(body: Node2D) -> void: if body is Player: collect()
