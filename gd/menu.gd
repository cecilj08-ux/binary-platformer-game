extends Control

@onready var start := $buttons/Start
@onready var quit := $buttons/Quit

func _ready() -> void:
	Global.destination = 0
	Global.title_screen = true
	quit.disabled = OS.get_name() == "Web"

func _on_start_pressed() -> void:
	Global.title_screen = false
	get_tree().change_scene_to_file("res://tscn/stages/world_selection.tscn")
func _on_quit_pressed() -> void: get_tree().quit()
