extends RigidBody2D

@export var is_selected : bool = false
@export var damage_pompe : int = 10

# NODES
@onready var jump_timer: Timer = $jump_timer
var grenade_scene = preload("res://scenes/projectiles/grenade.tscn")
var rocket_scene = preload("res://scenes/projectiles/rocket.tscn")

@export var grenarde_velocity : int = 6000
# BOOLEAN
var can_jump : bool = true
var is_on_ground : bool = true
# VIE
#@export var base_life : int = 100
var current_life : int = VarBidules.base_life
var is_alive : bool = true
# MOVEMENTS VARS
@export var speed : int = 2000
var jump_force : int = 1000
@export var max_h_speed : int = 400

# INPUTS VARS
var wanna_jump : bool
var wanna_left : bool
var wanna_right : bool
var wanna_bomb : bool
var wanna_pompe : bool
var wanna_rocket : bool
var wanna_aim_left : bool
var wanna_aim_right : bool
var direction : int = 0

var can_bombe : bool = true
var can_rocket : bool = true
var can_pompe : bool = true

var prev_dir : int = direction
var last_dir_nozero : int = direction

enum MOB_POSSIBILITY {
	GARDE,
	ERRANT
}
var current : MOB_POSSIBILITY = MOB_POSSIBILITY.ERRANT


	
func update_life_bar():
	$ui/ProgressBar.value = current_life
	
	
func set_current(current_choosed):
	if current_choosed == "garde":
		print("GARDE")
		current = MOB_POSSIBILITY.GARDE
		$ui/Label.text = "GARDE"
	else:
		current = MOB_POSSIBILITY.ERRANT
		$ui/Label.text = "ERRANT"
	
func get_inputs():
	wanna_jump = Input.is_action_just_pressed("jump")
	wanna_left = Input.is_action_pressed("left")
	wanna_right = Input.is_action_pressed("right")
	wanna_bomb = Input.is_action_just_pressed("bomb")
	wanna_rocket = Input.is_action_just_pressed("rocket")
	wanna_pompe = Input.is_action_just_pressed("pompe")
	
	wanna_aim_left = Input.is_action_pressed("aim_left")
	wanna_aim_right = Input.is_action_pressed("aim_right")
	
	
func _ready() -> void:
	VarEnd.body_can_move = true
	$ui/ProgressBar.max_value = VarBidules.base_life
	update_life_bar()
	change_state(STATE.CONTROL)
	BiduleManager.selected_mob_changed.connect(_on_selected_bidule_changed)

func _on_selected_bidule_changed(new_bidule):
	if new_bidule == self:
		is_selected = true
		$ui/Label2.show()
		change_state(STATE.IDLE)
	else:
		is_selected = false
		$ui/Label2.hide()
		change_state(STATE.IDLE)
		


func _physics_process(delta: float) -> void:
	if is_selected:
		get_inputs()
		update_state()

func take_damage(amount : int):
	current_life = current_life - amount
	update_life_bar()
	if current_life < 1:
		is_alive = false
		die()

func aim():
	if wanna_aim_left:
		$aim_droite.rotation_degrees -= 2.5
		$aim_gauche.rotation_degrees -= 2.5
		$pivot2.rotation_degrees -= 2.5
		
	elif wanna_aim_right:
		$aim_droite.rotation_degrees += 2.5
		$aim_gauche.rotation_degrees += 2.5
		$pivot2.rotation_degrees += 2.5
	
	if last_dir_nozero == 1:
		if $aim_droite.rotation_degrees < -100:
			$aim_droite.rotation_degrees = -100
			$aim_gauche.rotation_degrees = -100
			$pivot2.rotation_degrees = -100
		if $aim_droite.rotation_degrees > 40:
			$aim_droite.rotation_degrees = 40
			$aim_gauche.rotation_degrees = 40
			$pivot2.rotation_degrees = 40
	elif last_dir_nozero == -1:
		if $aim_droite.rotation_degrees > 100:
			$aim_droite.rotation_degrees = 100
			$aim_gauche.rotation_degrees = 100
			$pivot2.rotation_degrees = 100
		if $aim_droite.rotation_degrees < -40:
			$aim_droite.rotation_degrees = -40
			$aim_gauche.rotation_degrees = -40
			$pivot2.rotation_degrees = -40
			
func die():
	print("died")
	BiduleManager.ask_to_update_mob_array()
	BiduleManager.set_current_action("no")
	queue_free()
	
	
func play_bras_animation(animation):
	if current == MOB_POSSIBILITY.GARDE:
		match animation:
			"grenade":
				$aim_droite/bras_droite.play("garde_simple")
				$aim_gauche/bras_gauche.play("garde_grenade")
			"pompe":
				$aim_droite/bras_droite.play("garde_pompe")
				$aim_gauche/bras_gauche.play("garde_pompe")
			"pompe1":
				$aim_droite/bras_droite.play("garde_pompe")
				$aim_gauche/bras_gauche.play("garde_pompe_1")
			"idle":
				$aim_droite/bras_droite.play("garde_simple")
				$aim_gauche/bras_gauche.play("garde_simple")
			"patator":
				$aim_droite/bras_droite.play("garde_patator")
				$aim_gauche/bras_gauche.play("garde_patator")
			
	else:
		match animation:
			"grenade":
				$aim_droite/bras_droite.play("errant_simple")
				$aim_gauche/bras_gauche.play("errant_grenade")
			"pompe":
				$aim_droite/bras_droite.play("errant_pompe")
				$aim_gauche/bras_gauche.play("errant_pompe")
			"pompe1":
				$aim_droite/bras_droite.play("errant_pompe")
				$aim_gauche/bras_gauche.play("errant_pompe_1")
			"idle":
				$aim_droite/bras_droite.play("errant_simple")
				$aim_gauche/bras_gauche.play("errant_simple")
			"patator":
				$aim_droite/bras_droite.play("errant_patator")
				$aim_gauche/bras_gauche.play("errant_patator")
		
		
	#COMPO :
	#- grenade : idle 1 + grenade 2
	#- pomep : idle 1 + pompe 2
	#- patatator : patatator 1 + patatator 2
	#- idle : idle 1 + grenade 2

	
func play_animation(animation):
	
	if current == MOB_POSSIBILITY.GARDE:
		$pivot/sprites.play("garde_" + animation)
	else:
		$pivot/sprites.play("errant_" + animation)
		
		
#region STATE MACHINE
# -- STATE MACHINE --
enum STATE {
	JUMP,
	IDLE, # ne bouge pas 
	JUSTBEINGSELECTED, # viens juste d'etre selectionne, on sait pas encore ce quil veut faire
	CONTROL,
	ROCKET,
	GRENADE,
	POMPE
}
var current_state : STATE = STATE.IDLE

func change_state(new_state : STATE):
	#si le nouveau state est le meme que l'actuel alors on quitte pour ne pas rejouer _state et exit_state
	if new_state == current_state:
		return
	exit_state(current_state)
	current_state = new_state
	enter_state(current_state)

#quand on change de state, on va trigger cette fonction qui va determiner quel est le nouveau state
#et faire un truc genre jouer une animation par exemple... -> FAIT QUE UNE FOIS QUAND ON CHANGE DE STATE
func enter_state(new_state : STATE): 
	match new_state:
		STATE.JUMP:
			BiduleManager.set_current_action("control")
			can_jump = false
			play_animation("saut")
			play_bras_animation("idle")
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			$pivot2.rotation_degrees = 0
			apply_central_impulse(Vector2(0, -jump_force))
			jump_timer.start()
		STATE.IDLE:
			BiduleManager.set_current_action("no")
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			$pivot2.rotation_degrees = 0
			play_animation("idle")
			play_bras_animation("idle")
		STATE.CONTROL:
			BiduleManager.set_current_action("control")
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			$pivot2.rotation_degrees = 0
			play_animation("control")
			play_bras_animation("idle")
		STATE.ROCKET:
			BiduleManager.set_current_action("patator")
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			$pivot2.rotation_degrees = 0
			play_animation("idle")
			play_bras_animation("patator")
		STATE.GRENADE:
			BiduleManager.set_current_action("grenade")
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			$pivot2.rotation_degrees = 0
			play_animation("idle")
			play_bras_animation("grenade")
		STATE.POMPE:
			BiduleManager.set_current_action("pompe")
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			$pivot2.rotation_degrees = 0
			play_animation("idle")
			play_bras_animation("pompe1")
			$RechargementPompe.play()

#pareil que enter_state sauf que la c quand on quitte un state
#ex: quand on quitte le state "falling" on joue l'animation d'atterrissage (landing)
func exit_state(last_state):
	match last_state:
		STATE.IDLE:
			pass
		STATE.CONTROL:
			pass
		STATE.ROCKET:
			pass
		STATE.GRENADE:
			pass
		STATE.POMPE:
			pass

#appele a chaque physic_process, fait l'action pour chaaque state
#ex: si le state est walk alors dans la partie walk on get_inputs() et on change velocity
func update_state():
	match current_state:
		STATE.IDLE:
			if VarEnd.body_can_move == true:
				if wanna_left || wanna_right:
					change_state(STATE.CONTROL)
				if wanna_bomb:
					change_state(STATE.GRENADE)
				if wanna_pompe:
					change_state(STATE.POMPE)
				if wanna_rocket:
					change_state(STATE.ROCKET)
				if wanna_jump && can_jump:
					change_state(STATE.JUMP)
			
		STATE.JUMP:
			if VarEnd.body_can_move == true:
				direction = 0
				if wanna_left:
					direction = -1

				elif wanna_right:
					direction = 1
				
				if prev_dir != direction && direction != 0:
					if direction == 1:
						$pivot.scale.x = -1
						$aim_droite.scale.x = -1
						$aim_droite.position.x = 46 
						$aim_gauche.scale.x = -1
						$pivot2.scale.x = -1
						$aim_gauche.position.x = -35 
					elif direction == -1:
						$pivot.scale.x = 1
						$aim_droite.scale.x = 1
						$aim_droite.position.x = -35
						$aim_gauche.scale.x = 1
						$pivot2.scale.x = 1
						$aim_gauche.position.x = 46 
				
				prev_dir = direction
				if direction != 0:
					last_dir_nozero = direction
				
				if linear_velocity.x > max_h_speed:
					linear_velocity.x = max_h_speed
				elif linear_velocity.x < -max_h_speed:
					linear_velocity.x = -max_h_speed
					
				if direction != 0:
					apply_central_force(Vector2(direction * (speed - 750), 0))
					
				if linear_velocity.y == 0:
					print("FINISHED JUMP")
					change_state(STATE.CONTROL)
				
		STATE.CONTROL:
			if VarEnd.body_can_move == true:
				if wanna_bomb:
					change_state(STATE.GRENADE)
				if wanna_pompe:
					change_state(STATE.POMPE)
				if wanna_rocket:
					change_state(STATE.ROCKET)
					
				direction = 0
				if wanna_left:
					direction = -1

				elif wanna_right:
					direction = 1
					
				if direction != 0:
					apply_central_force(Vector2(direction * speed, 0))
				else:
					change_state(STATE.IDLE)
					
				
					
				if prev_dir != direction && direction != 0:
					if direction == 1:
						$pivot.scale.x = -1
						$aim_droite.scale.x = -1
						$aim_droite.position.x = 46 
						$aim_gauche.scale.x = -1
						$pivot2.scale.x = -1
						$aim_gauche.position.x = -35 
					elif direction == -1:
						$pivot.scale.x = 1
						$aim_droite.scale.x = 1
						$aim_droite.position.x = -35
						$aim_gauche.scale.x = 1
						$pivot2.scale.x = 1
						$aim_gauche.position.x = 46 
				
				prev_dir = direction
				if direction != 0:
					last_dir_nozero = direction
					
				
					
				#limite la vitesse, sinon c exponentiel
				if linear_velocity.x > max_h_speed:
					linear_velocity.x = max_h_speed
				elif linear_velocity.x < -max_h_speed:
					linear_velocity.x = -max_h_speed

				if wanna_jump and can_jump:
					change_state(STATE.JUMP)

		STATE.ROCKET:
			if VarEnd.body_can_move == true:
				if wanna_jump and can_jump:
					change_state(STATE.JUMP)
				if wanna_left || wanna_right:
					change_state(STATE.CONTROL)
				if wanna_bomb:
					change_state(STATE.GRENADE)
				if wanna_pompe:
					change_state(STATE.POMPE)

				aim()
				
				if wanna_rocket && can_rocket:
					if VarEnd.a_tire == false:
						#launch grenade
						var rocket = rocket_scene.instantiate()
						rocket.global_position = $pivot2/depart_proj.global_position
						var direction = $pivot2/depart_proj.global_transform.x.normalized()
						get_parent().get_parent().get_parent().get_node("projectiles").add_child(rocket)
						$LancePatateLaunch.play()
						rocket.linear_velocity = direction * -3500
								
						get_tree().current_scene.add_child(rocket)
					

		STATE.GRENADE:
			if VarEnd.body_can_move == true:
				if wanna_jump and can_jump:
					change_state(STATE.JUMP)
				if wanna_left || wanna_right:
					change_state(STATE.CONTROL)
				if wanna_pompe:
					change_state(STATE.POMPE)
				if wanna_rocket:
					change_state(STATE.ROCKET)
				aim()
			
				if wanna_bomb && can_bombe:
					if VarEnd.a_tire == false:
						#launch grenade
						var grenade = grenade_scene.instantiate()
						grenade.global_position = $pivot2/depart_proj.global_position
						var direction = $pivot2/depart_proj.global_transform.x.normalized()
						get_parent().get_parent().get_parent().get_node("projectiles").add_child(grenade)
						$LancerGrenade.play()
						grenade.apply_central_impulse(direction * -2500)
								
						get_tree().current_scene.add_child(grenade)
						
				
				
		STATE.POMPE:
			if VarEnd.body_can_move == true:
				if wanna_jump and can_jump:
					change_state(STATE.JUMP)
				if wanna_left || wanna_right:
					change_state(STATE.CONTROL)
				if wanna_bomb:
					change_state(STATE.GRENADE)
				if wanna_rocket:
					change_state(STATE.ROCKET)
				aim()
				
				if wanna_pompe && can_pompe:
					if VarEnd.a_tire == false:
						VarEnd.can_end = false
						VarEnd.a_tire = true
						VarEnd.body_can_move = false
						play_bras_animation("pompe")
						$TirPompe.play()
						var bodies = $aim_gauche/Pompe.get_overlapping_bodies()
						print(bodies)
						for body in bodies:
							if body.has_method("take_damage"):
								body.take_damage(damage_pompe)
						await get_tree().create_timer(1).timeout
						VarEnd.a_tire = false
						VarEnd.body_can_move = true
						VarEnd.can_end = true


#endregion

	


func _on_ground_detection_body_entered(body: Node2D) -> void:
	if current_state == STATE.JUMP:
		change_state(STATE.CONTROL)


func _on_ground_detection_body_exited(body: Node2D) -> void:
	print(body.name)
	if body.get_parent().get_parent().name == "DestructiblePolygon2D":
		print("TRUE")
		#is_on_ground = false 



func _on_jump_timer_timeout() -> void:
	can_jump = true
