extends RigidBody2D

@export var damage : int = 50

func _ready() -> void:
	VarEnd.can_end = false
	VarEnd.a_tire = true
	VarEnd.body_can_move = false
	self.show()
	$Timer.start()

func _physics_process(delta):
	pass

func _on_timer_timeout() -> void:
	
	# On récupère le terrain (nom exact: "Terrain1") depuis le parent ou la scène
	var terrain = get_parent().get_parent().get_node("DestructiblePolygon2D")
	
	var radius = 700.0
	var segments = 16
	var polygon = PackedVector2Array()
	for i in range(segments):
		var angle = TAU * i / segments
		polygon.append(Vector2(cos(angle), sin(angle)) * radius)
	
	# "Destruct" prend un polygone (forme du trou) et une position globale
	var destroyed_area = terrain.destruct(polygon, global_position)
	print("Destroyed area:", destroyed_area)
	$ExplosionPatateEtGrenade.play()
	var bodies = $mob_detection.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			print("damage")
			body.take_damage(damage)
			
		if body is RigidBody2D:
			var dir = (body.global_position - global_position).normalized()
			var distance = global_position.distance_to(body.global_position)
			var force = clamp(2000.0 / max(distance, 20.0), 200, 1200) # Force selon distance
			body.apply_impulse(dir * force)
	
	
	self.hide()
	


func _on_explosion_patate_et_grenade_finished() -> void:
	VarEnd.can_end = true
	VarEnd.a_tire = false
	await get_tree().create_timer(0.1).timeout
	VarEnd.body_can_move = true
	queue_free()


func _on_mob_detection_body_entered(body: RigidBody2D) -> void:
	pass
