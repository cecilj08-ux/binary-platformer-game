extends Node
var destination := 1
var title_screen := false
var can_pause := true
var p_scale := Vector2.ONE
const pause_menu_scene := preload("res://tscn/uis/pause_menu.tscn")
const player_scene := preload("res://tscn/elements/player.tscn")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var pause_menu := pause_menu_scene.instantiate()
	get_tree().current_scene.add_sibling.call_deferred(pause_menu)
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset") and not title_screen:
		get_tree().paused = false
		Global.can_pause = true
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("esc") and can_pause and not title_screen:
		get_tree().paused = not get_tree().paused
