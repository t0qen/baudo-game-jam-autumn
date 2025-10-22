extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	VarBidules.is_errant_winner = true
	if VarBidules.is_errant_winner == true:
		$Label.text = "Les errants ont gagnés !"
	else:
		$Label.text = "Les gardes ont gagnés !"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
