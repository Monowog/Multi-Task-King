extends Node

@export var data : Resource

@export var num_players : int
@export var num_turns : int
@export var player_names : Array[String]

var curr_turn = 1

func _ready():
	if data:
		num_players = data.num_players
		num_turns = data.num_turns
	
func delete_player(index : int) -> void:
	num_players -= 1
	player_names.remove_at(index)

func add_player(name : String) -> void:
	num_players += 1
	player_names.append(name)
