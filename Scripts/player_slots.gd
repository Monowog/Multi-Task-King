extends VBoxContainer

@onready var playerSlots : Array[PanelContainer] 

func _ready() -> void:
	playerSlots.append($PlayerSlot1)
	playerSlots.append($PlayerSlot2)
	playerSlots.append($PlayerSlot3)
	playerSlots.append($PlayerSlot4)
	for x in range(GlobalData.num_players):
		playerSlots[x].visible = true
