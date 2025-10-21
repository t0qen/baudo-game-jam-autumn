extends Node2D

var grenade = preload("res://scenes/projectiles/grenade.tscn")
var grenadeInstance = grenade.instantiate() 
var mouse_position
@onready var terrain = $DestructiblePolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Faire spawn bombe (pas définitif)"):
		spawn_enfant()

func spawn_enfant():
	# Créer une nouvelle instance de la scène
	var nouvelle_grenade = grenade.instantiate()
	
	# Ajouter l'instance comme enfant
	add_child(nouvelle_grenade)
	
	# Positionner l'instance à la position de la souris
	nouvelle_grenade.global_position = get_global_mouse_position()
