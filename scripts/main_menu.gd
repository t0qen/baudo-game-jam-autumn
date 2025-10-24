extends Node2D

@onready var input_button_scene = preload("res://scenes/input_button.tscn")
@onready var action_list = $PopUpOptions/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"jump": "Sauter",
	"left": "Gauche",
	"right": "Droite",
	"bomb": "Grenade",
	"rocket": "Patator",
	"pompe": "Fusil a pompe",
	"aim_left": "Viser en haut",
	"aim_right": "Viser en bas",
	"camera_left": "Camera a gauche",
	"camera_right": "Camera a droite",
	"camera_up": "Camera en haut",
	"camera_down": "Camera en bas",
	"camera_zoom_up": "Zoomer",
	"camera_zoom_down": "Dezoomer",
	"camera_focus": "Camera sur le joueur"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PopUpOptions.hide()
	$PopUp.hide()
	_create_action_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $PopUp.visible == true:
		if Input.is_action_just_pressed("sortir"):
			$PopUp.hide()
			
	if $PopUpOptions.visible == true:
		if Input.is_action_just_pressed("sortir"):
			$PopUpOptions.hide()

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


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/crédits.tscn")

func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")

		action_label.text = input_actions[action]

		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Presser une touche..."

func _input(event):
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)

			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			
func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix("( Physical)")


func _on_option_pressed() -> void:
	$PopUpOptions.show()
