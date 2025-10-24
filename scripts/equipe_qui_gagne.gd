extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Victoire.play()
	if VarBidules.is_errant_winner == true:
		$Label.text = "Les errants ont gagnés !"
		$mainerrant.scale.x = -1.2
		$mainerrant.scale.y = 1.2
		$errant.scale.x = -1.2
		$errant.scale.y = 1.2
	else:
		$Label.text = "Les gardes ont gagnés !"
		$maingarde.scale.x = 1.2
		$maingarde.scale.y = 1.2
		$garde.scale.x = 1.2
		$garde.scale.y = 1.2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_menu_pressed() -> void:
	pass # Replace with function body.
