extends Control

func _on_start_pressed() -> void:
	Global.title_screen = false
	get_tree().change_scene_to_file("res://tscn/stage_template.tscn")
func _on_quit_pressed() -> void: get_tree().quit()
