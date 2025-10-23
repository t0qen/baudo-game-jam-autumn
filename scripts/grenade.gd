extends RigidBody2D

@export var damage : int

func _ready() -> void:
	self.show()
	$Timer.start()

func _physics_process(delta):
	pass

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
	#var destroyed_area = terrain.destruct(polygon, global_position)
	#print("Destroyed area:", destroyed_area)
	$ExplosionPatateEtGrenade.play()
	var bodies = $mob_detection.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(damage)
	self.hide()
	


func _on_explosion_patate_et_grenade_finished() -> void:
	queue_free()


func _on_mob_detection_body_entered(body: RigidBody2D) -> void:
	pass
