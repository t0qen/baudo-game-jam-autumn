extends RigidBody2D

@onready var destruction_polygon = $Area2D/CollisionPolygon2D

func _ready() -> void:
	$Timer.start()
	


func _on_timer_timeout() -> void:
	# On récupère le terrain (nom exact: "Terrain1") depuis le parent ou la scène
	var terrain = get_parent().get_node("Terrain1")
	if terrain != null:
		terrain.clip(destruction_polygon)
	queue_free()
