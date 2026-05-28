extends Control

func _ready() -> void:
	Global.destination = 0 # This is so testing can be done per scene when debugging
	Global.destination = 0
	Global.title_screen = true

func _on_start_pressed() -> void:
	Global.title_screen = false
	get_tree().change_scene_to_file("res://tscn/stages/world_selection.tscn")
func _on_quit_pressed() -> void: get_tree().quit()
