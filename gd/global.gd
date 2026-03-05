extends Node
var stage := 0
var title_screen := true

func _ready() -> void: process_mode = Node.PROCESS_MODE_ALWAYS
func _physics_process(_delta: float) -> void:
# Temporary way to close the game. Change to the pause script below later on.
	if Input.is_action_just_pressed("esc"): get_tree().quit()
	#if Input.is_action_just_pressed("esc") and not title_screen: get_tree().paused = not get_tree().paused
# Oh yeah, decide what you'll do with this too
	#DisplayServer.window_set_title(str(Engine.get_frames_per_second()) + " FPS")
