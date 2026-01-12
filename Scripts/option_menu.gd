extends Control

func _on_back_to_main_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")

func _on_music_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value/50)
	
func _on_sfx_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value/50)
