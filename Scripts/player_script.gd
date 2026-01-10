extends Control 

@export var score : int = 0
@export var attention : int = 5
@export var attentionColors : Array[Color]
@export var defaultColor : Color

@onready var background = $Background
@onready var dopamineText = $"Background/MarginContainer/PlayerStats/PointsMargin/Dopamine/PanelContainer/TotalAmi"
@onready var attentionBar = $"Background/MarginContainer/PlayerStats/AttnPanel/AttentionMargin/Attention"
@onready var attentionPanels : Array[PanelContainer]

func _ready():
	SignalManager.update_attention.connect(_update_attention)
	SignalManager.update_player.connect(_update_player)
	
	for x in range(10): #set to new stylebox so instances don't share
		attentionPanels.append(attentionBar.get_child(x))
		var original_stylebox: StyleBoxFlat = attentionPanels[x].get_theme_stylebox("panel")
		var new_stylebox: StyleBoxFlat = original_stylebox.duplicate()
		attentionPanels[x].add_theme_stylebox_override("panel", new_stylebox)
	
	var original_stylebox: StyleBoxFlat = background.get_theme_stylebox("panel")
	var new_stylebox: StyleBoxFlat = original_stylebox.duplicate()
	
	background.add_theme_stylebox_override("panel", new_stylebox)
	background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()-1]
	background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()-1]
	
	$"Background/MarginContainer/PlayerStats/PlayerName".text = GlobalData.player_names[self.get_index()-1]

func _update_player(activePlayer: int, newDopamine: int, newAttention: int) -> void:
	if self.get_index() == activePlayer:
		score = newDopamine
		dopamineText.text = str(score)
	else:
		pass

func _update_attention(activePlayer: int, attn : int):
	if self.get_index() == activePlayer:
		for x in range(10):
			if x < attn:
				attentionPanels[x].get_theme_stylebox("panel").bg_color = attentionColors[x]
			else:
				attentionPanels[x].get_theme_stylebox("panel").bg_color = defaultColor
