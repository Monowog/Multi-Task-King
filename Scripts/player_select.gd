extends Control

@onready var background = $"MarginContainer/BackgroundPanel"

@onready var colorOption1 = $"MarginContainer/StatMargin/Stats/ColorOptions/ColorOption1"
@onready var colorOption2 = $"MarginContainer/StatMargin/Stats/ColorOptions/ColorOption2"
@onready var colorOption3 = $"MarginContainer/StatMargin/Stats/ColorOptions/ColorOption3"
@onready var colorOption4 = $"MarginContainer/StatMargin/Stats/ColorOptions/ColorOption4"
@onready var colorOption5 = $"MarginContainer/StatMargin/Stats/ColorOptions/ColorOption5"
@onready var colorOption6 = $"MarginContainer/StatMargin/Stats/ColorOptions/ColorOption6"

func _ready() -> void:	
	var original_stylebox: StyleBoxFlat = background.get_theme_stylebox("panel")
	var new_stylebox: StyleBoxFlat = original_stylebox.duplicate()
	
	$"MarginContainer/StatMargin/Stats/NameInput".text = GlobalData.player_names[self.get_index()]
	background.add_theme_stylebox_override("panel", new_stylebox)
	background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()]

func _on_remove_button_pressed() -> void:
	if GlobalData.num_players > 2:
		GlobalData.delete_player(self.get_index())
		queue_free()
	else:
		print("Min Players Reached")

func _on_name_input_text_changed(new_text: String) -> void:
	GlobalData.player_names[self.get_index()] = new_text

func _on_color_option_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		GlobalData.player_colors[self.get_index()] = colorOption1.get_theme_stylebox("panel").bg_color
		background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()]

func _on_color_option_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		GlobalData.player_colors[self.get_index()] = colorOption2.get_theme_stylebox("panel").bg_color
		background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()]

func _on_color_option_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		GlobalData.player_colors[self.get_index()] = colorOption3.get_theme_stylebox("panel").bg_color
		background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()]

func _on_color_option_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		GlobalData.player_colors[self.get_index()] = colorOption4.get_theme_stylebox("panel").bg_color
		background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()]

func _on_color_option_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		GlobalData.player_colors[self.get_index()] = colorOption5.get_theme_stylebox("panel").bg_color
		background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()]

func _on_color_option_6_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		GlobalData.player_colors[self.get_index()] = colorOption6.get_theme_stylebox("panel").bg_color
		background.get_theme_stylebox("panel").bg_color = GlobalData.player_colors[self.get_index()]
