extends Control

@export var defaultPlayer : PackedScene

@onready var selectionContainer = $"MarginContainer/PlayerContainer/SelectionContainer"

func _ready() -> void:
	for x in range(GlobalData.num_players):
		var playerInstance = defaultPlayer.instantiate()
		selectionContainer.add_child(playerInstance)

func _on_back_to_main_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")

func _on_start_button_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/Playspace.tscn")

func _on_add_button_pressed() -> void:
	var playerInstance = defaultPlayer.instantiate()
	if GlobalData.num_players < 4:
		GlobalData.add_player("New Player")
		selectionContainer.add_child(playerInstance)
	else:
		print("Max Players Reached")
