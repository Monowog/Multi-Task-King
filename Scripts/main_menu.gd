extends Control

func _on_new_game_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/GameMode.tscn")

func _on_options_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/OptionMenu.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
