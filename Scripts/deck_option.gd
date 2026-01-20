extends PanelContainer

@export var cardOption = preload("res://Scenes/card_option.tscn")

@onready var contents = $"VBoxContainer/ActionScroller/ActionList"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for card in GlobalData.card_list:
		var newOption = cardOption.instantiate()
		newOption.action = GlobalData.card_list[card]
		contents.add_child(newOption)
