extends RigidBody2D

var can_explode : bool = true

func _ready() -> void:
	$PatateEnFeu.play()

	


func _on_detection_max_degat_body_entered(body: Node2D) -> void:
	if can_explode == true:
		$ExplosionPatateEtGrenade.play()
		linear_velocity = Vector2.ZERO
		can_explode = false
		print(body.name)
		# On récupère le terrain (nom exact: "Terrain1") depuis le parent ou la scène
		var terrain = get_parent().get_node("DestructiblePolygon2D")
		
		var radius = 200
		var segments = 32
		var polygon = PackedVector2Array()
		for i in range(segments):
			var angle = TAU * i / segments
			polygon.append(Vector2(cos(angle), sin(angle)) * radius)
		
		# "Destruct" prend un polygone (forme du trou) et une position globale
		#var destroyed_area = terrain.destruct(polygon, global_position)
		#print("Destroyed area:", destroyed_area)
		
		await get_tree().create_timer(0.5).timeout
		$CollisionShape2D.disabled = true
		$Sprite2D.hide()
		for i in range($CPUParticles2D.amount):
			if $CPUParticles2D.amount == 0:
				return
			$CPUParticles2D.amount -= 1
			await get_tree().create_timer(0.1).timeout
		
		


func _on_explosion_patate_et_grenade_finished() -> void:
	queue_free()
