extends Node

@warning_ignore_start("unused_signal")

#Action Signals
signal action_hovered(emitter: Node)
signal action_unhovered(emitter: Node)
signal action_clicked(emitter: Node, actionName: String)

#(action) Highlight Signals
signal highlight_slot(index: int)
signal unhighlight_slot(index: int)

#Player Signals
signal update_players(activePlayer: int)

#Game Signals
signal end_turn()
