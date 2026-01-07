extends Control

@export var player : PackedScene

@onready var playerController = $"PlayspaceMargin/PlayerController"

func _ready() -> void:
	$"PlayspaceMargin/Buttons/Turn".text = "Turn " + str(GlobalData.curr_turn) + "/" + str(GlobalData.num_turns)
	for x in range(GlobalData.num_players):
		var newPlayer = player.instantiate()
		playerController.add_child(newPlayer)
		playerController.move_child(newPlayer, x)

func _on_next_button_pressed() -> void:
	pass

func _on_back_button_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")

func _on_how_to_play_pressed() -> void:
	$"PlayspaceMargin/HelpPanel".visible = true
