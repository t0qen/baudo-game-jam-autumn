extends Area2D

@onready var destruction_polygon = $CollisionPolygon2D

func _process(_delta):
	global_position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# On récupère le terrain (nom exact: "Terrain1") depuis le parent ou la scène
		var terrain = get_parent().get_node("Terrain1")
		if terrain != null:
			terrain.clip(destruction_polygon)
