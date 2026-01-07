extends Control

@export var card_data : action_resource

var cardName : String
var duration : int
var baseDopamine : int
var background : Color
var hasModifier : bool
var hasMultiplier : bool
var hasEffect : bool
var effectText : String
var currDopamine : int

func _ready() -> void:
	cardName = card_data.cardName
	duration = card_data.duration
	baseDopamine = card_data.baseDopamine
	background = card_data.background
	hasModifier = card_data.hasModifier
	hasMultiplier = card_data.hasMultiplier
	hasEffect = card_data.hasEffect
	effectText = card_data.effectText
	
	$"MarginContainer/CardStats/NameMargin/CardNameBG/NameLabel".text = cardName
	$"MarginContainer/CardStats/StatMargin/Duration/PanelContainer/DurationText".text = str(duration)
	$"MarginContainer/CardStats/StatMargin/Ami/PanelContainer/AmiText".text = str(baseDopamine)
	$"MarginContainer/CardStats/NameMargin/CardNameBG".get_theme_stylebox("panel").bg_color = background
	$"MarginContainer/CardStats/AdditionalText/TextureRect".visible = hasEffect
	currDopamine = baseDopamine
