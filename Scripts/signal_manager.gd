extends Node

@warning_ignore_start("unused_signal")

#Action Signals
signal action_hovered(emitter: Node)
signal action_unhovered(emitter: Node)
signal action_clicked(emitter: Node, actionName: String, duration: int, dopamine: int)

#(action) Highlight Signals
signal highlight_slot(index: int)
signal unhighlight_slot(index: int)

#Player Signals
signal update_player(activeIndex: int, newScore: int, newAttention: int)
signal update_player_slot(activeIndex: int)

#Game Signals
signal draw_card(cardName: String)
signal card_taken(duration: int, baseDopamine: int)
signal card_put_back(duration: int, baseDopamine: int)
signal reorder_players(startIndex: int)
signal end_turn()
