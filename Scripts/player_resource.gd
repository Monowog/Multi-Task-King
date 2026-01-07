extends Resource
class_name player_resource

@export var name : String
@export var score : int
@export var attention : int
@export var maxAttention : int
@export var color : Color

func set_player_name(nm):
	name = nm
	
func get_player_name():
	return name
	
func set_score(sc):
	score = sc
	
func get_score():
	return score
	
func set_attention(at):
	attention = at
	
func get_attention():
	return attention
	
func set_max_attention(at):
	maxAttention = at
	
func get_max_attention():
	return maxAttention
	
func set_color(cl):
	color = cl
	
func get_color():
	return color
