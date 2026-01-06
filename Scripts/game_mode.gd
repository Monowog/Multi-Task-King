extends Control

func _on_back_to_main_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")


func _on_start_button_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/Playspace.tscn")
