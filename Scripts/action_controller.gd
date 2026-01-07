extends GridContainer

@export var actionCard : PackedScene

func _ready() -> void:
	SignalManager.hovered.connect(_on_action_hovered)
	SignalManager.unhovered.connect(_on_action_unhovered)
	SignalManager.clicked.connect(_on_action_clicked)
	if actionCard:
		for x in range(6):
			var newAction = actionCard.instantiate()
			self.add_child(newAction)


func _on_action_hovered(action: Node) -> void:
	print("child " + str(action.get_index()) + " of parent " + str(action.get_parent().name) +" hovered")

func _on_action_unhovered(action: Node) -> void:
	print("child " + str(action.get_index()) + " of parent " + str(action.get_parent().name) +" unhovered")

func _on_action_clicked(action: Node) -> void:
	print("child " + str(action.get_index()) + " of parent " + str(action.get_parent().name) +" clicked")
