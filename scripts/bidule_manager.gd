extends Node

var current_bidule = null
var current_main = null 

signal selected_mob_changed(new_mob) # signal evoye a tous les bidules 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_main(main):
	current_main = main
	
func ask_to_update_mob_array():
	print("UPDATED MOB ARRAY")
	current_main.update_mob_array()
	
func set_current(bidule):
	current_bidule = bidule
	selected_mob_changed.emit(current_bidule)
	
func get_mob_position():
	return current.global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
