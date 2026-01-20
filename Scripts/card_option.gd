extends MarginContainer

@export var action : PackedScene

@onready var actionSlot = $"BGPanel/ActionMargin/HBoxContainer/ActionMargin"
@onready var numText = $"BGPanel/ActionMargin/HBoxContainer/NumberText"

var cardName : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var actionScene = action.instantiate()
	cardName = actionScene.card_data.cardName
	update_text()
	actionSlot.add_child(actionScene)

func update_text():
	numText.text = str(GlobalData.deck_dict[cardName])

func _on_less_button_pressed() -> void:
	if GlobalData.deck_dict[cardName] > 0 and GlobalData.deckSize > 6:
		GlobalData.deck_dict[cardName] -= 1
		GlobalData.deckSize -= 1
		update_text()

func _on_more_button_pressed() -> void:
	GlobalData.deck_dict[cardName] += 1
	GlobalData.deckSize += 1
	update_text()
