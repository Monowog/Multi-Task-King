extends Resource
class_name action_resource

@export var name : String
@export var duration : int
@export var dopamine : int
@export var texture : ImageTexture
@export var hasEffect : bool
@export var effectText : String

func get_duration():
	return duration

func set_duration(dur):
	duration = dur

func get_dopamine():
	return dopamine

func set_dopamine(ami):
	dopamine = ami
