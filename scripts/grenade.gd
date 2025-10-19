extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_explode() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _explode():
	var terrain = get_parent().get_node("Terrain 1")
	terrain.destroy_area(global_position, 50.0)
