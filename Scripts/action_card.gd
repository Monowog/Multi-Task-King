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
		SignalManager.action_clicked.emit(self, cardName)
		queue_free()

func _on_click_box_mouse_entered() -> void:
	SignalManager.action_hovered.emit(self)

func _on_click_box_mouse_exited() -> void:
	SignalManager.action_unhovered.emit(self)
