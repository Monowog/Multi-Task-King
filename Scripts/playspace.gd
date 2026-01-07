extends Control

func _ready() -> void:
	$"MarginContainer/Buttons/Turn".text = "Turn " + str(GlobalData.curr_turn) + "/" + str(GlobalData.num_turns)

func _on_next_button_pressed() -> void:
	pass

func _on_back_button_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")

func _on_how_to_play_pressed() -> void:
	$"MarginContainer/HelpPanel".visible = true
