extends Node

@export var num_players = 4
@export var num_turns = 10
@export var player_names = ["Player1","Player2","Player3","Player4"]
@export var player_colors : Array[Color]

@export var card_list = {
	"Check Socials": preload("res://Assets/Cards/CheckSocials.tscn"),
	"Scroll Shorts": preload("res://Assets/Cards/ScrollShorts.tscn"),
	"Listen to Music": preload("res://Assets/Cards/ListenToMusic.tscn"),
	"Take a Hike": preload("res://Assets/Cards/TakeAHike.tscn"),
	"Watch a Film": preload("res://Assets/Cards/WatchAFilm.tscn"),
	"Read a Book": preload("res://Assets/Cards/ReadABook.tscn")
}

@export var deck_dict = {
	"Check Socials": 10,
	"Scroll Shorts": 8,
	"Listen to Music": 8,
	"Take a Hike": 6,
	"Watch a Film": 6,
	"Read a Book": 6
}

var rng = RandomNumberGenerator.new()

var winners : Array[String]
var winningScores : Array[int]

var curr_turn = 1

func _ready():
	rng.randomize()
	
func delete_player(index : int) -> void:
	num_players -= 1
	player_names.remove_at(index)
	player_colors.remove_at(index)

func add_player(playerName : String) -> void:
	num_players += 1
	player_names.append(playerName)
	player_colors.append(Color.DIM_GRAY)
