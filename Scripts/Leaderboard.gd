extends Control

@export var fontSizes : Array[int]

@onready var scoreText = $"ScoresMargin/Scores/LeaderboardText"
@onready var scoreboard = $"ScoresMargin/Scores/ScorePanel/ScoreVBox"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(GlobalData.num_players):
		var newLabel = scoreText.duplicate()
		newLabel.text = str(x+1) + ") " + GlobalData.winners[x] + " with " + str(GlobalData.winningScores[x]) + " ami"
		newLabel.add_theme_font_size_override("font_size", fontSizes[x])
		newLabel.add_theme_color_override("font_color", GlobalData.winningColors[x])
		scoreboard.add_child(newLabel)


func _on_button_pressed() -> void:
	GlobalData.winners.clear()
	GlobalData.winningScores.clear()
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")
