extends Node

@export var num_players = 4
@export var num_turns = 10
@export var player_names = ["Player1","Player2","Player3","Player4"]
@export var player_colors : Array[Color]

@export var sfx_list : Array[AudioStream]


@export var card_list: Dictionary[String, PackedScene] = {
	"Check Socials": preload("res://Assets/Cards/CheckSocials.tscn"),
	"Scroll Shorts": preload("res://Assets/Cards/ScrollShorts.tscn"),
	"Listen to Music": preload("res://Assets/Cards/ListenToMusic.tscn"),
	"Take a Hike": preload("res://Assets/Cards/TakeAHike.tscn"),
	"Watch a Film": preload("res://Assets/Cards/WatchAFilm.tscn"),
	"Read a Book": preload("res://Assets/Cards/ReadABook.tscn"),
	"Check Notifications": preload("res://Assets/Cards/CheckNotifications.tscn"),
	"See a Concert": preload("res://Assets/Cards/SeeAConcert.tscn"),
	"Smoke Up": preload("res://Assets/Cards/SmokeUp.tscn"),
	"Read a Comic": preload("res://Assets/Cards/ReadAComic.tscn"),
	"Daydream": preload("res://Assets/Cards/Daydream.tscn"),
	"Get a Massage": preload("res://Assets/Cards/GetAMassage.tscn")
}

@export var deck_dict: Dictionary[String, int] = {
	"Check Socials": 10,
	"Scroll Shorts": 8,
	"Listen to Music": 8,
	"Take a Hike": 6,
	"Watch a Film": 6,
	"Read a Book": 6,
	"Check Notifications": 4,
	"See a Concert": 4,
	"Smoke Up": 6,
	"Read a Comic": 4,
	"Daydream": 6,
	"Get a Massage": 4
}

@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer

var rng = RandomNumberGenerator.new()

var winners : Array[String]
var winningScores : Array[int]
var winningColors : Array[Color]

var curr_turn = 1

func _ready():
	SignalManager.play_action_noise.connect(_play_action_noise)
	rng.randomize()
	music_player.play()
	
func _play_action_noise(index: int):
	
	sfx_player.stream = sfx_list[index]
	sfx_player.play()
	
func delete_player(index : int) -> void:
	num_players -= 1
	player_names.remove_at(index)
	player_colors.remove_at(index)

func add_player(playerName : String) -> void:
	num_players += 1
	player_names.append(playerName)
	player_colors.append(Color.DIM_GRAY)
