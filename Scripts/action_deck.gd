extends Control

var deckList : Array[String] = []
var discard : Array[String] = []

func _ready() -> void:
	for cardName in GlobalData.deck_dict: #for each card type
		for x in range(GlobalData.deck_dict[cardName]): #add x cards of that type
			deckList.append(cardName)
	shuffle(3)

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
