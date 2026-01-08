extends Control

const PLAYER_SCENE = preload("res://Scenes/Player.tscn")

@onready var playerController = $"PlayspaceMargin/PlayerMargin/PlayerController"
@onready var actionOptions = $"PlayspaceMargin/PlaymatMargin/ActionMargin/MarginContainer/ActionOptions"
@onready var hand = $"HandMargin/HandSubmargin/HandCards"
@onready var turnText = $"PlayspaceMargin/Buttons/Turn"

var currTurn : int = 1
var activePlayer : int = 0 #index of playerOrder
var currentTotal : int = 0 #point value of current turn
var playerOrder : Array[int] = [] #keeps track of initial player indices (index = turn order, value = player)
var playerScores : Array[int] = [] #doesn't swap (access using VALUE of playerOrder)

var deckList : Array[String] = []
var discard : Array[String] = []

func _ready() -> void:
	SignalManager.action_clicked.connect(_on_action_clicked)
	
	for cardName in GlobalData.deck_dict: #for each card type
		for x in range(GlobalData.deck_dict[cardName]): #add x cards of that type to deck
			deckList.append(cardName)
	shuffle(3)
	
	$"PlayspaceMargin/Buttons/Turn".text = "Turn " + str(GlobalData.curr_turn) + "/" + str(GlobalData.num_turns)
	for x in range(GlobalData.num_players): #create players
		var newPlayer = PLAYER_SCENE.instantiate()
		playerController.add_child(newPlayer)
		playerController.move_child(newPlayer, x)
		playerOrder.append(x)
		playerScores.append(0)
	
	for x in range(6): #draw 6 cards to start
		SignalManager.draw_card.emit(draw_card())

func swap_cards(index1 : int, index2 : int):
	var temp = deckList[index1]
	deckList[index1] = deckList[index2]
	deckList[index2] = temp

func shuffle(numShuffles : int) -> void:
	for card in discard:
		deckList.append(card)
	for x in range(numShuffles):
		for card in deckList:
			swap_cards(GlobalData.rng.randi_range(0,deckList.size()-1), GlobalData.rng.randi_range(0,deckList.size()-1))

func draw_card() -> String:
	var topCard = deckList[0]
	deckList.pop_front()
	return topCard 

func _on_next_button_pressed() -> void:
	if activePlayer < GlobalData.num_players - 1:
		activePlayer += 1 
		SignalManager.update_players.emit(activePlayer)
	else: #end the turn
		activePlayer = 0
		currTurn += 1
		turnText.text = "Turn " + str(currTurn) + "/" + str(GlobalData.num_turns)
		SignalManager.update_players.emit(activePlayer)
	for card in hand.get_children():
		card.queue_free()

func _on_back_button_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")

func _on_how_to_play_pressed() -> void:
	$"PlayspaceMargin/HelpPanel".visible = true

func _on_action_clicked(action: Node, actionName: String):
	if action.get_parent().name == "ActionOptions":
		var newCard = GlobalData.card_list[actionName].instantiate()
		hand.add_child(newCard)
	elif action.get_parent().name == "HandCards":
		var newCard = GlobalData.card_list[actionName].instantiate()
		actionOptions.add_child(newCard)
