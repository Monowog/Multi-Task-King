extends Control

func _ready() -> void:
	$"MarginContainer/StatMargin/Stats/NameInput".text = GlobalData.player_names[self.get_index()]

func _on_remove_button_pressed() -> void:
	if GlobalData.num_players > 2:
		GlobalData.delete_player(self.get_index())
		queue_free()
	else:
		print("Min Players Reached")
