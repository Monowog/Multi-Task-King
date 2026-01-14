extends Control

@export var card_data : action_resource

@onready var cardName : String = card_data.cardName
@onready var duration : int = card_data.duration
@onready var baseDopamine : int = card_data.baseDopamine
@onready var background : Color = card_data.background
@onready var hasModifier : bool = card_data.hasModifier
@onready var hasMultiplier : bool = card_data.hasMultiplier
@onready var hasEffect : bool = card_data.hasEffect
@onready var effectText : String = card_data.effectText
@onready var currDopamine : int = baseDopamine

func _ready() -> void:
	$"MarginContainer/CardStats/NameMargin/CardNameBG/NameLabel".text = cardName
	$"MarginContainer/CardStats/StatMargin/Duration/PanelContainer/DurationText".text = str(duration)
	$"MarginContainer/CardStats/StatMargin/Ami/PanelContainer/AmiText".text = str(baseDopamine)
	$"MarginContainer/CardStats/NameMargin/CardNameBG".get_theme_stylebox("panel").bg_color = background
	$"MarginContainer/CardStats/AdditionalText/TextureRect".visible = hasEffect

func _on_click_box_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			SignalManager.action_clicked.emit(self, cardName, duration, currDopamine)
			queue_free()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			SignalManager.show_tooltip.emit(cardName, effectText, background, true, duration, baseDopamine)

func _on_click_box_mouse_entered() -> void:
	SignalManager.action_hovered.emit(self)

func _on_click_box_mouse_exited() -> void:
	SignalManager.hide_tooltip.emit()
	SignalManager.action_unhovered.emit(self)

func _update_action_stats(dopamine: int) -> void:
	pass
