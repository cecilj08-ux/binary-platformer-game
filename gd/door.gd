class_name Door extends Sprite2D

@export var door_id := 1
@export var destination_id: int
@export_file_path("*.tscn") var destination
var keys_required := 0
var has_activator := false
var opened := false

func open() -> void:
	keys_required = 0
	opened = true
	frame = 1
func close() -> void:
	opened = false
	frame = 0

func _ready() -> void:
	if snappedf(scale.x*scale.y,0.01) == ceil(scale.x*scale.y):
		scale.x = sqrt(snappedf(scale.x*scale.y,0.01))
		scale.y = sqrt(snappedf(scale.y*scale.y,0.01))
	if door_id != 0:
		if door_id == Global.destination:
			var player = Global.player_scene.instantiate()
			player.position = position
			player.new_scale = Global.p_scale
			player.scale = Global.p_scale
			get_tree().current_scene.add_child.call_deferred(player) # HACK: Is there a less redundant way to put it at the bottom of the scene tree?
		if keys_required == 0 and destination and not has_activator:
			await get_tree().create_timer(0.5).timeout
			open()

func _on_enter_box_body_entered(body: Node2D) -> void:
	if body is Player and opened and body.new_scale <= scale and body.new_scale > Vector2(0.25,0.25):
		Global.can_pause = false
		get_tree().paused = true
		Global.destination = destination_id
		Global.p_scale = body.new_scale if get_tree().current_scene.has_meta("world_id") else Vector2.ONE
		await get_tree().create_timer(0.2).timeout
		get_tree().paused = false
		Global.can_pause = true
		if get_tree().current_scene.scene_file_path == destination:
			for i in get_parent().get_children():
				if Global.destination == i.door_id:
					i.close()
					body.position = i.position
					body.velocity = Vector2.ZERO
					if i.destination != null:
						await get_tree().create_timer(0.5).timeout # Maybe replace this
						i.open()
					break
		else: get_tree().change_scene_to_file(destination)
