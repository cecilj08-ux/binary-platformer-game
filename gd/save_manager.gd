extends Node

const save_path := "user://savedata.tres"
var save_game: SaveGame = null

func save() -> void: ResourceSaver.save(save_game, save_path)

func _ready() -> void:
	if ResourceLoader.exists(save_path): save_game = ResourceLoader.load(save_path, "", ResourceLoader.CACHE_MODE_IGNORE)
	else: save_game = SaveGame.new()
