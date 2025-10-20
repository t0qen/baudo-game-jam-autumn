extends Node2D

var nb_errants: int = 4
var nb_gardes: int = 4

var errants = preload("res://scenes/errants.tscn")
var gardes = preload("res://scenes/gardes.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(nb_errants):
		errants.instantiate()
	for i in range(nb_gardes):
		gardes.instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
