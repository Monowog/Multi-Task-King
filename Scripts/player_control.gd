extends Control

@export var player_data : Resource 

func _ready():
	if player_data:
		$"Background/MarginContainer/PlayerStats/PlayerName".text = player_data.name
	else:
		pass
