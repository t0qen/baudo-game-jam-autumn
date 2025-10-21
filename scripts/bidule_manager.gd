extends Node

var current_bidule = null
var current_main = null 

signal selected_mob_changed(new_mob) # signal evoye a tous les bidules 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_main(main):
	current_main = main
	
func set_current(bidule):
	current_bidule = bidule
	selected_mob_changed.emit(current_bidule)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
