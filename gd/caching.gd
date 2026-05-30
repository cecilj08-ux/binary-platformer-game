extends Node2D

@onready var player := $player
@onready var label := $Label
@onready var cache_queue := [player.fallParticles, player.eatParticles, player.bleedParticles, player.chargeParticles]
func _ready() -> void:
	Global.destination = 0
	Global.title_screen = true
	for i in cache_queue:
		label.text = "Caching \"" + i.name + "\"..."
		i.restart()
	get_tree().change_scene_to_file.call_deferred("res://tscn/uis/menu.tscn")
