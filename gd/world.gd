extends Node2D

func _ready() -> void:
	if has_meta("secret") and get_meta("secret"):
		if SaveManager.save_game.unlocked_secrets.get(get_meta("world_id")[0]) == null: SaveManager.save_game.unlocked_secrets[get_meta("world_id")[0]] = []
		if not get_meta("world_id")[1] in SaveManager.save_game.unlocked_secrets[get_meta("world_id")[0]]:
			SaveManager.save_game.unlocked_secrets[get_meta("world_id")[0]].append(get_meta("world_id")[1])
			SaveManager.save()
	else:
		if SaveManager.save_game.unlocked_stages.get(get_meta("world_id")[0]) == null: SaveManager.save_game.unlocked_stages[get_meta("world_id")[0]] = []
		if not get_meta("world_id")[1] in SaveManager.save_game.unlocked_stages[get_meta("world_id")[0]]:
			SaveManager.save_game.unlocked_stages[get_meta("world_id")[0]].append(get_meta("world_id")[1])
			SaveManager.save()
	if has_meta("redirect"): get_tree().change_scene_to_file(get_meta("redirect"))
