extends GridContainer

func _ready() -> void:
	SignalManager.draw_card.connect(_add_card)
	SignalManager.action_hovered.connect(_on_action_hovered)
	SignalManager.action_unhovered.connect(_on_action_unhovered)

func _add_card(cardName: String):
	var newAction = GlobalData.card_list[cardName].instantiate()
	self.add_child(newAction)

func _on_action_hovered(action: Node) -> void:
	if action.get_parent().name == "ActionOptions":
		SignalManager.highlight_slot.emit(action.get_index())

func _on_action_unhovered(action: Node) -> void:
	if action.get_parent().name == "ActionOptions":
		SignalManager.unhighlight_slot.emit(action.get_index())
