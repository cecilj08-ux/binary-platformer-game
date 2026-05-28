extends Control

@onready var unpause: TextureButton = $texture/margin/buttonsHBox/unpause
@onready var restart: TextureButton = $texture/margin/buttonsHBox/restart
@onready var settings: TextureButton = $texture/margin/buttonsHBox/settings
@onready var exit: TextureButton = $texture/margin/buttonsHBox/exit

func _process(_delta: float) -> void: get_parent().visible = get_tree().paused and Global.can_pause

func _on_unpause_pressed() -> void: get_tree().paused = false
func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
func _on_settings_pressed() -> void:
	pass
func _on_exit_pressed() -> void:
	get_tree().paused = false
	Global.title_screen = true
	get_tree().change_scene_to_file("res://tscn/uis/menu.tscn")
