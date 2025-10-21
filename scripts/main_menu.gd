extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PopUp.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $PopUp.visible == true:
		if Input.is_action_just_pressed("sortir"):
			$PopUp.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _on_start_pressed() -> void:
	$PopUp.show()

func _on_commencer_pressed() -> void:
	VarBidules.base_life = $"PopUp/Points de vie Button".get_item_id($"PopUp/Points de vie Button".selected)
	VarBidules.nbr_errants = $"PopUp/Errants Button".get_item_id($"PopUp/Errants Button".selected)
	VarBidules.nbr_gardes = $"PopUp/Gardes Button".get_item_id($"PopUp/Gardes Button".selected)
	VarBidules.duree_partie_sec = $"PopUp/Durée de la partie Button".get_item_id($"PopUp/Durée de la partie Button".selected)
	VarBidules.duree_tour_sec = $"PopUp/Durée du tour Button".get_item_id($"PopUp/Durée du tour Button".selected)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
