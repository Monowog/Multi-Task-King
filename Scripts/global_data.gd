extends Node

@export var num_players = 4
@export var num_turns = 10

@export var player_names = ["Player1","Player2","Player3","Player4"]
@export var player_colors : Array[Color]

@export var deck_dict = {
	"CheckSocials": 10,
	"ScrollShorts": 8,
	"ListenToMusic": 8,
	"TakeAHike": 6,
	"WatchAFilm": 6,
	"ReadABook": 6
}

var curr_turn = 1

func _ready():
	pass
	
func delete_player(index : int) -> void:
	num_players -= 1
	player_names.remove_at(index)
	player_colors.remove_at(index)

func add_player(playerName : String) -> void:
	num_players += 1
	player_names.append(playerName)
	player_colors.append(Color.BEIGE)
