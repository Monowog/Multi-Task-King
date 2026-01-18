extends Control

const PLAYER_SCENE = preload("res://Scenes/Player.tscn")

@onready var playerController = $"PlayspaceMargin/PlayerMargin/PlayerController"
@onready var actionOptions = $"PlayspaceMargin/PlayMargin/PlaymatMargin/ActionMargin/MarginContainer/ActionOptions"
@onready var hand = $"HandMargin/HandSubmargin/HandCards"
@onready var turnText = $"PlayspaceMargin/Buttons/TurnPanel/Turn"
@onready var nextButton = $"PlayspaceMargin/PlayerMargin/PlayerController/NextButton"

#turn text box
@onready var playerTurnPanel = $"PlayspaceMargin/PlayMargin/TurnTextContainer/TurnTextPanel"
@onready var playerTurnText = $"PlayspaceMargin/PlayMargin/TurnTextContainer/TurnTextPanel/TurnText"

#attention
@onready var attentionText = $"HandMargin/HandStats/StatsBackground/MarginContainer/DurationStats"
@onready var attentionPanel = $"HandMargin/HandStats/StatsBackground"

#tooltip
@onready var tooltip = $"PlayspaceMargin/TooltipContainer"
@onready var tooltipStats = $"PlayspaceMargin/TooltipContainer/TooltipMargin/StatContainer"
@onready var tooltipBackground = $"PlayspaceMargin/TooltipContainer/TooltipMargin/NameColorRect"
@onready var tooltipName = $"PlayspaceMargin/TooltipContainer/TooltipMargin/NameColorRect/NameText"
@onready var tooltipEffect = $"PlayspaceMargin/TooltipContainer/TooltipMargin/EffectText"
@onready var tooltipDuration =$"PlayspaceMargin/TooltipContainer/TooltipMargin/StatContainer/DuraVbox/DurationIcon/DurationText"
@onready var tooltipDopamine =$"PlayspaceMargin/TooltipContainer/TooltipMargin/StatContainer/AmiVBox/DopamineIcon/DopamineText"

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

@export var attentionColors : Array[Color]

func _ready() -> void:
	SignalManager.action_clicked.connect(_on_action_clicked)
	SignalManager.reorder_players.connect(_reorder_players)
	SignalManager.show_tooltip.connect(_show_tooltip)
	SignalManager.hide_tooltip.connect(_hide_tooltip)
	
	GlobalData.actionsEnabled = true
	
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
		SignalManager.update_attention.emit(x,5)
	
	for x in range(6): #draw 6 cards to start
		SignalManager.draw_card.emit(draw_card())
	
	attentionPanel.get_theme_stylebox("panel").bg_color = attentionColors[0]
	update_player_turn_text(GlobalData.player_names[0], GlobalData.player_colors[0])
	
	if GlobalData.computer_players[0]:
		nextButton.visible = false
		computer_turn()
		await SignalManager.computer_turn_over
		nextButton.visible = true

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
	next_player()

func next_player():
	if currentDuration > playerAttentions[playerOrder[activePlayer]]: #not enough attention
		SignalManager.play_action_noise.emit(7)
	else:
		SignalManager.play_action_noise.emit(8)
		attentionPanel.get_theme_stylebox("panel").bg_color = attentionColors[0]
		
		playerScores[playerOrder[activePlayer]] += get_total_dopamine() #add points to total
		if cardsTaken == 0 && playerAttentions[playerOrder[activePlayer]] <= 4: #bonus for skipping turn with low attention
			playerAttentions[playerOrder[activePlayer]] += 3
		else:
			playerAttentions[playerOrder[activePlayer]] += 2 - cardsTaken
		
		if playerAttentions[playerOrder[activePlayer]] > 10:
			playerAttentions[playerOrder[activePlayer]] = 10 #set max attention
		SignalManager.update_player.emit(activePlayer, playerScores[playerOrder[activePlayer]], playerAttentions[playerOrder[activePlayer]])
		SignalManager.update_attention.emit(activePlayer, playerAttentions[playerOrder[activePlayer]])
		
		cardsTaken = 0 #Reset player variables
		currentDuration = 0
		currentDopamine = 0
		GlobalData.actionsEnabled = true
		
		if activePlayer < GlobalData.num_players - 1: #next player
			activePlayer += 1 
			SignalManager.update_player_slot.emit(activePlayer)
		elif currTurn == GlobalData.num_turns: #end the game
			for x in range(GlobalData.num_players):
				GlobalData.winningScores.append(playerScores.max())
				GlobalData.winners.append( GlobalData.player_names[playerScores.find(playerScores.max())] )
				GlobalData.winningColors.append( GlobalData.player_colors[playerScores.find(playerScores.max())] )
				playerScores[playerScores.find(playerScores.max())] -= 10000
			SceneManager.change_scene_to("res://Scenes/Leaderboard.tscn")
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
		
		update_player_turn_text(GlobalData.player_names[playerOrder[activePlayer]], GlobalData.player_colors[playerOrder[activePlayer]])
		update_attention_text()
		
		if GlobalData.computer_players[playerOrder[activePlayer]]:
			nextButton.visible = false
			computer_turn()
			await SignalManager.computer_turn_over
			nextButton.visible = true

func get_first_player() -> int:
	var first = playerScores.min()
	return playerScores.find(first) #returns value of playerOrder

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
	if action.get_parent().name == "ActionOptions": #add to hand
		cardsTaken += 1
		
		add_to_hand(actionName)
		update_attention_text()
		
	elif action.get_parent().name == "HandCards": #add to action options
		cardsTaken -= 1
		currentDuration -= duration
		
		update_attention_text()
		add_to_options(actionName)
	
	update_actions()
	SignalManager.play_action_noise.emit(cardsTaken)

func add_to_hand(actionName: String):
	var newCard = GlobalData.card_list[actionName].instantiate()
	hand.add_child(newCard)
	currentDuration += newCard.duration

func add_to_options(actionName: String):
	var newCard = GlobalData.card_list[actionName].instantiate()
	actionOptions.add_child(newCard)

func update_attention_text():
	if currentDuration < playerAttentions[playerOrder[activePlayer]]:
		attentionPanel.get_theme_stylebox("panel").bg_color = attentionColors[0]
	elif currentDuration > playerAttentions[playerOrder[activePlayer]]:
		attentionPanel.get_theme_stylebox("panel").bg_color = attentionColors[1]
	elif currentDuration == playerAttentions[playerOrder[activePlayer]]:
		attentionPanel.get_theme_stylebox("panel").bg_color = attentionColors[2]
	attentionText.text = str(currentDuration) + " / " + str(playerAttentions[playerOrder[activePlayer]])

func _show_tooltip(cardName: String, effect: String, background: Color, isAction: bool, duration: int, baseDopamine: int):
	tooltipName.text = cardName
	tooltipBackground.get_theme_stylebox("panel").bg_color = background
	tooltipEffect.text = effect
	
	if not isAction:
		tooltipStats.visible = false
	else:
		tooltipDuration.text = str(duration)
		tooltipDopamine.text = str(baseDopamine)
	tooltip.visible = true

func _hide_tooltip():
	tooltip.visible = false
	
func update_player_turn_text(playerName: String, playerColor: Color):
	playerTurnPanel.get_theme_stylebox("panel").bg_color = playerColor
	playerTurnText.text = playerName + "'s Turn"

func update_actions():
	for card in hand.get_children(): #reset values
		card.currDopamine = card.card_data.baseDopamine
	
	for card in hand.get_children(): #apply dopamine modifiers
		match card.cardName:
			"Smoke Up":
				card.currDopamine += cardsTaken-1
			"Read a Comic":
				if activePlayer == 0:
					card.currDopamine += 2
			"Daydream":
				var mod = -1
				for c in hand.get_children():
					if c.duration <= 3 && c.duration != -1:
						mod += 1
				card.currDopamine += mod
			_:
				pass
	
	for card in hand.get_children(): #apply multipliers
		match card.cardName:
			"Get a Massage":
				for c in hand.get_children():
					c.currDopamine *= 2
			_:
				pass
	
	SignalManager.update_action_stats.emit()

func get_total_dopamine() -> int:
	currentDopamine = 0
	for card in hand.get_children():
		currentDopamine += card.currDopamine
	return currentDopamine

func computer_turn() -> void:
	GlobalData.actionsEnabled = false
	
	await get_tree().create_timer(0.7).timeout
	
	var playstyle : String
	
	if GlobalData.num_turns - currTurn < 2:
		playstyle = "aggressive"
	elif playerAttentions[playerOrder[activePlayer]] < 5:
		playstyle = "passTurn"
	else:
		var patientChance = 10 + (float(GlobalData.num_turns-currTurn)/GlobalData.num_turns) * 40
		if GlobalData.rng.randf()*100 < patientChance:
			playstyle = "patient"
		else:
			playstyle = "aggressive"
	
	var choices = find_choices(playstyle)
	
	for choice in choices:
		await get_tree().create_timer(0.40).timeout
		remove_from_options(choice)
		add_to_hand(choice)
		cardsTaken += 1
		SignalManager.play_action_noise.emit(cardsTaken)
		update_attention_text()
	
	update_actions()
	SignalManager.computer_turn_over.emit()

func find_choices(playstyle: String) -> Array[String]:
	var choices: Array[String] = []
	match playstyle:
		"aggressive":
			var max = 0
			for subset in get_all_subsets([0,1,2,3,4,5]):
				if max < evaluate(subset):
					max = evaluate(subset)
					choices.clear()
					for x in subset:
						choices.append(actionOptions.get_child(x).cardName)
				elif max == evaluate(subset) && subset.size() < choices.size():
					choices.clear()
					for x in subset:
						choices.append(actionOptions.get_child(x).cardName)
		"patient":
			var maxDuration = 0
			for card in actionOptions.get_children():
				if card.duration > maxDuration && card.duration <= playerAttentions[playerOrder[activePlayer]]:
					maxDuration = card.duration
					choices.clear()
					choices.append(card.card_data.cardName)
		"passTurn":
			pass
		_:
			pass
		
	return choices

func evaluate(subset: Array) -> int:
	var totalDopamine = 0
	var totalDuration = 0
	
	for x in subset: #check if viable subset
		totalDuration += actionOptions.get_child(x).card_data.duration
	
	if totalDuration > playerAttentions[playerOrder[activePlayer]]: #not enough attention
		return -1
	
	for x in subset: #add dopamine and modifiers
		totalDopamine += actionOptions.get_child(x).card_data.baseDopamine
		match actionOptions.get_child(x).cardName:
			"Smoke Up":
				totalDopamine += subset.size()-1
			"Read a Comic":
				if activePlayer == 0:
					totalDopamine += 2
			"Daydream":
				var mod = -1
				for y in subset:
					if actionOptions.get_child(y).duration <= 3:
						mod += 1
				totalDopamine += mod
			_:
				pass
	
	for x in subset: #apply multipliers
		match actionOptions.get_child(x).cardName:
			"Get a Massage":
				totalDopamine *= 2
			_:
				pass
				
	return totalDopamine
	

func get_all_subsets(items: Array[int]) -> Array[Array]:
	var all_subsets: Array[Array] = []
	var n: int = items.size()
	# Total combinations are 2^n. Iterate through all possible binary numbers
	# from 0 to 2^n - 1. Each number represents a combination.
	for i in range(1 << n):
		var current_subset: Array = []
		for j in range(n):
			# Check if the j-th bit is set in the current number 'i'
			if (i >> j) & 1:
				current_subset.append(items[j])
		all_subsets.append(current_subset)
	return all_subsets

func remove_from_options(actionName: String):
	for card in actionOptions.get_children():
		if card.card_data.cardName == actionName:
			card.queue_free()
			return
