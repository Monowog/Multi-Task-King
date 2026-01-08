extends Control

const PLAYER_SCENE = preload("res://Scenes/Player.tscn")

@onready var playerController = $"PlayspaceMargin/PlayerMargin/PlayerController"
@onready var hand = $HandMargin/HandSubmargin/HandCards

func _ready() -> void:
	SignalManager.action_clicked.connect(_on_action_clicked)
	$"PlayspaceMargin/Buttons/Turn".text = "Turn " + str(GlobalData.curr_turn) + "/" + str(GlobalData.num_turns)
	for x in range(GlobalData.num_players):
		var newPlayer = PLAYER_SCENE.instantiate()
		playerController.add_child(newPlayer)
		playerController.move_child(newPlayer, x)

func _on_next_button_pressed() -> void:
	pass

func _on_back_button_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")

func _on_how_to_play_pressed() -> void:
	$"PlayspaceMargin/HelpPanel".visible = true

func _on_action_clicked(action: Node, actionName: String):
	if action.get_parent().name == "ActionOptions":
		var newCard = GlobalData.card_list[actionName].instantiate()
		hand.add_child(newCard)
