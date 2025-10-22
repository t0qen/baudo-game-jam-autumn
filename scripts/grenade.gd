extends RigidBody2D

func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	# On récupère le terrain (nom exact: "Terrain1") depuis le parent ou la scène
	var terrain = get_parent().get_node("DestructiblePolygon2D")
	
	var radius = 100.0
	var segments = 32
	var polygon = PackedVector2Array()
	for i in range(segments):
		var angle = TAU * i / segments
		polygon.append(Vector2(cos(angle), sin(angle)) * radius)
	
	# "Destruct" prend un polygone (forme du trou) et une position globale
	var destroyed_area = terrain.destruct(polygon, global_position)
	print("Destroyed area:", destroyed_area)
	queue_free()
