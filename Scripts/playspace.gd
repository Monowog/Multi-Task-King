extends Control

const PLAYER_SCENE = preload("res://Scenes/Player.tscn")

@onready var playerController = $"PlayspaceMargin/PlayerMargin/PlayerController"
@onready var actionOptions = $"PlayspaceMargin/PlaymatMargin/ActionMargin/MarginContainer/ActionOptions"
@onready var hand = $"HandMargin/HandSubmargin/HandCards"
@onready var turnText = $"PlayspaceMargin/Buttons/TurnPanel/Turn"

var currTurn : int = 1
var activePlayer : int = 0 #index of playerOrder
var playerOrder : Array[int] = [] #keeps track of initial player indices (index = turn order, value = player)
var playerAttentions : Array[int] = []
var playerScores : Array[int] = [] #doesn't swap (access using VALUE of playerOrder)

var deckList : Array[String] = []
var discard : Array[String] = []

var currentDuration : int = 0
var currentDopamine : int = 0 #point value of current turn
var cardsTaken : int = 0

func _ready() -> void:
	SignalManager.action_clicked.connect(_on_action_clicked)
	SignalManager.reorder_players.connect(_reorder_players)
	
	for cardName in GlobalData.deck_dict: #for each card type
		for x in range(GlobalData.deck_dict[cardName]): #add x cards of that type to deck
			deckList.append(cardName)
	shuffle(3)
	
	turnText.text = "Turn " + str(GlobalData.curr_turn) + "/" + str(GlobalData.num_turns)
	for x in range(GlobalData.num_players): #create players
		var newPlayer = PLAYER_SCENE.instantiate()
		playerController.add_child(newPlayer)
		playerController.move_child(newPlayer, x)
		playerOrder.append(x)
		playerAttentions.append(5)
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
	discard.clear()
	for x in range(numShuffles):
		for card in deckList:
			swap_cards(GlobalData.rng.randi_range(0,deckList.size()-1), GlobalData.rng.randi_range(0,deckList.size()-1))

func draw_card() -> String:
	if deckList.size() == 0:
		shuffle(1)
	var topCard = deckList[0]
	deckList.pop_front()
	return topCard 

func _on_next_button_pressed() -> void:
	playerScores[playerOrder[activePlayer]] += currentDopamine
	playerAttentions[playerOrder[activePlayer]] += 2 - cardsTaken
	SignalManager.update_player.emit(activePlayer, playerScores[playerOrder[activePlayer]], playerAttentions[playerOrder[activePlayer]])
	
	cardsTaken = 0
	currentDopamine = 0
	
	if activePlayer < GlobalData.num_players - 1: #next player
		activePlayer += 1 
		SignalManager.update_player_slot.emit(activePlayer)
	else: #end turn, go to next turn
		activePlayer = 0
		currTurn += 1
		turnText.text = "Turn " + str(currTurn) + "/" + str(GlobalData.num_turns)
		SignalManager.reorder_players.emit(get_first_player())
		SignalManager.update_player_slot.emit(activePlayer)
		
	for card in hand.get_children(): #replace taken actions
		SignalManager.draw_card.emit(draw_card())
		discard.append(card.get_child(0).name)
		card.queue_free()


func get_first_player() -> int:
	var min = playerScores.min()
	return playerScores.find(min) #returns value of playerOrder

func _reorder_players(firstPlayer: int) -> void:
	if firstPlayer == playerOrder[0]:
		pass
	else:
		for x in range(GlobalData.num_players - playerOrder.find(firstPlayer)): #rotate array x times
			var temp = playerOrder.pop_back()
			playerOrder.push_front(temp)
			playerController.move_child(playerController.get_child(GlobalData.num_players-1), 0) #swap last player to first


func _on_back_button_pressed() -> void:
	SceneManager.change_scene_to("res://Scenes/MainMenu.tscn")

func _on_how_to_play_pressed() -> void:
	$"PlayspaceMargin/HelpPanel".visible = true

func _on_action_clicked(action: Node, actionName: String, duration: int, dopamine: int):
	if action.get_parent().name == "ActionOptions":
		cardsTaken += 1
		currentDopamine += dopamine
		currentDuration += duration
		var newCard = GlobalData.card_list[actionName].instantiate()
		hand.add_child(newCard)
	elif action.get_parent().name == "HandCards":
		cardsTaken -= 1
		currentDopamine -= dopamine
		currentDuration -= duration
		var newCard = GlobalData.card_list[actionName].instantiate()
		actionOptions.add_child(newCard)
