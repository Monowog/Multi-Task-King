extends VBoxContainer

@export var defaultBackground : Color
@export var activeBackground : Color

@onready var playerSlots : Array[PanelContainer] 

func _ready() -> void:
	SignalManager.update_player_slot.connect(_update_backgrounds)
	playerSlots.append($PlayerSlot1)
	playerSlots.append($PlayerSlot2)
	playerSlots.append($PlayerSlot3)
	playerSlots.append($PlayerSlot4)
	for x in range(GlobalData.num_players):
		if x == 0:
			playerSlots[x].get_theme_stylebox("panel").bg_color = activeBackground
		else:
			playerSlots[x].get_theme_stylebox("panel").bg_color = defaultBackground
		playerSlots[x].visible = true

func _update_backgrounds(activePlayer: int):
	if activePlayer == 0:
		playerSlots[GlobalData.num_players-1].get_theme_stylebox("panel").bg_color = defaultBackground
	else:
		playerSlots[activePlayer-1].get_theme_stylebox("panel").bg_color = defaultBackground
	playerSlots[activePlayer].get_theme_stylebox("panel").bg_color = activeBackground
	
