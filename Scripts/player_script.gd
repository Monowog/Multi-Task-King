extends Control 

@export var score : int = 0
@export var attention : int = 5

@onready var background = $Background

func _ready():
	var original_stylebox: StyleBoxFlat = background.get_theme_stylebox("panel")
	var new_stylebox: StyleBoxFlat = original_stylebox.duplicate()
	
	background.add_theme_stylebox_override("panel", new_stylebox)
	background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()-1]
	background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()-1]
	
	$"Background/MarginContainer/PlayerStats/PlayerName".text = GlobalData.player_names[self.get_index()-1]

func change_color():
	pass
