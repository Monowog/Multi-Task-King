extends Control

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Board.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/OptionMenu.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
