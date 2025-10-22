extends RigidBody2D

func _ready() -> void:
	pass

func _on_detection_max_degat_area_entered(area: Area2D) -> void:
	# On récupère le terrain (nom exact: "Terrain1") depuis le parent ou la scène
	var terrain = get_parent().get_node("TestMap")
	
	var radius = 200
	var segments = 32
	var polygon = PackedVector2Array()
	for i in range(segments):
		var angle = TAU * i / segments
		polygon.append(Vector2(cos(angle), sin(angle)) * radius)
	
	# "Destruct" prend un polygone (forme du trou) et une position globale
	var destroyed_area = terrain.destruct(polygon, global_position)
	print("Destroyed area:", destroyed_area)
	queue_free()
