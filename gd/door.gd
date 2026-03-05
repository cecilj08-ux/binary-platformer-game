class_name Door extends Sprite2D

@export var destination_override: PackedScene
var keys_required := 0
var opened := false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and opened and body.new_scale <= scale:
		get_tree().paused = true
		await get_tree().create_timer(0.2).timeout
		get_tree().paused = false
		Global.stage += 1
		get_tree().change_scene_to_file("res://tscn/stages/stage_" + str(Global.stage) + ".tscn")

func open() -> void:
	keys_required = 0
	opened = true
	frame = 1
func close() -> void:
	opened = false
	frame = 0
