extends Node

var num_players : int
var num_rounds : int
var board_size : Vector2
var player_names : Array[String]

func delete_player(index : int) -> void:
	num_players -= 1
	player_names.remove_at(index)

func add_player(name : String) -> void:
	num_players += 1
	player_names.append(name)
