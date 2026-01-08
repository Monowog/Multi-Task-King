extends GridContainer

@export var defaultColor : Color = Color.DARK_GRAY
@export var highlightColor : Color = Color.AQUAMARINE

@onready var slotArray: Array[PanelContainer]

func _ready() -> void:
	for x in range(self.get_child_count()):
		slotArray.append(self.get_child(x))
		
	SignalManager.highlight_slot.connect(_highlight_slot)
	SignalManager.unhighlight_slot.connect(_unhighlight_slot)

func _highlight_slot(index: int) -> void:
	var slot = self.get_child(index)
	slotArray[index].get_theme_stylebox("panel").bg_color = highlightColor

func _unhighlight_slot(index: int) -> void:
	var slot = self.get_child(index)
	slotArray[index].get_theme_stylebox("panel").bg_color = defaultColor
