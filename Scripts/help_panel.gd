extends PanelContainer

func _ready() -> void:
	self.visible = false


func _on_help_texture_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		self.visible = false
