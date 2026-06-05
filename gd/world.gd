extends Node2D

func _ready() -> void:
	if has_meta("attempt_counter") and get_meta("attempt_counter"):
		if SaveManager.save_game.attempts_list.get(get_meta("key")) == null: SaveManager.save_game.attempts_list[get_meta("key")] = 1
		if Global.key != get_meta("key"):
			Global.attempts = SaveManager.save_game.attempts_list.get(get_meta("key"))
			Global.key = get_meta("key")
		elif Global.attempts != SaveManager.save_game.attempts_list[get_meta("key")]: SaveManager.save_game.attempts_list[get_meta("key")] = Global.attempts
		SaveManager.save()
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
	if has_meta("redirect"): 
		if has_meta("end_time_trial"):
			if Global.time_taken <= Global.time_limit:
				var time: float
				time = (floor(Global.time_taken*100))/100
				SaveManager.save_game.trial_times [get_meta("world_id")[0]] = time
				SaveManager.save()
		get_tree().change_scene_to_file(get_meta("redirect"))
