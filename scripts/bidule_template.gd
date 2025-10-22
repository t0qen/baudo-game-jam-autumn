extends RigidBody2D

@export var is_selected : bool = false

# NODES
@onready var jump_timer: Timer = $jump_timer


# BOOLEAN
var can_jump : bool = true

# VIE
#@export var base_life : int = 100
var current_life : int = VarBidules.base_life

# MOVEMENTS VARS
@export var speed : int = 800
@export var jump_force : int = 1200
@export var max_h_speed : int = 300

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

var prev_dir : int = direction

enum MOB_POSSIBILITY {
	GARDE,
	ERRANT
}
var current : MOB_POSSIBILITY = MOB_POSSIBILITY.GARDE

func set_current(current : MOB_POSSIBILITY):
	current = current
	
	
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
	change_state(STATE.CONTROL)
	BiduleManager.selected_mob_changed.connect(_on_selected_bidule_changed)

func _on_selected_bidule_changed(new_bidule):
	if new_bidule == self:
		print("SELECTED !!!!!!!!!!!")
		is_selected = true
		change_state(STATE.CONTROL)
	else:
		print("UNSELECTED !!!!!!!!!!!")
		is_selected = false
		change_state(STATE.IDLE)
		
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_selected:
		get_inputs()
		update_state()

func take_damage(amount : int):
	current_life = current_life - amount
	if current_life < 1:
		print("Died")
		die()

func aim():
	print("aim")
	if wanna_aim_left:
		$aim_droite.rotation_degrees += 5
		$aim_gauche.rotation_degrees += 5
	elif wanna_aim_right:
		$aim_droite.rotation_degrees -= 5
		$aim_gauche.rotation_degrees -= 5
func die():
	queue_free()
	BiduleManager.ask_to_update_mob_array()
	
func play_bras_animation(animation):
	if current == MOB_POSSIBILITY.GARDE:
		match animation:
			"grenade":
				$aim_droite/bras_droite.play("garde_idle")
				$aim_gauche/bras_gauche.play("garde_grenade")
			"pompe":
				$aim_droite/bras_droite.play("garde_idle")
				$aim_gauche/bras_gauche.play("garde_pompe")
			"idle":
				$aim_droite/bras_droite.play("garde_idle")
				$aim_gauche/bras_gauche.play("garde_grenade")
			"patator":
				$aim_droite/bras_droite.play("garde_patator")
				$aim_gauche/bras_gauche.play("garde_patator")
	else:
		match animation:
			"grenade":
				$aim_droite/bras_droite.play("errant_idle")
				$aim_gauche/bras_gauche.play("errant_grenade")
			"pompe":
				$aim_droite/bras_droite.play("errant_idle")
				$aim_gauche/bras_gauche.play("errant_pompe")
			"idle":
				$aim_droite/bras_droite.play("errant_idle")
				$aim_gauche/bras_gauche.play("errant_grenade")
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
	IDLE, # ne bouge pas 
	JUSTBEINGSELECTED, # viens juste d'etre selectionne, on sait pas encore ce quil veut faire
	CONTROL,
	ROCKET,
	GRENADE,
	POMPE
}
var current_state : STATE = STATE.IDLE

func change_state(new_state : STATE):
	#si le nouveau state est le meme que l'actuel alors on quitte pour ne pas rejouer enter_state et exit_state
	if new_state == current_state:
		return
	exit_state(current_state)
	current_state = new_state
	enter_state(current_state)

#quand on change de state, on va trigger cette fonction qui va determiner quel est le nouveau state
#et faire un truc genre jouer une animation par exemple... -> FAIT QUE UNE FOIS QUAND ON CHANGE DE STATE
func enter_state(new_state : STATE): 
	match new_state:
		STATE.IDLE:
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			play_animation("idle")
			play_bras_animation("idle")
		STATE.CONTROL:
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			play_animation("control")
			play_bras_animation("idle")
		STATE.ROCKET:
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			play_animation("idle")
			play_bras_animation("patator")
		STATE.GRENADE:
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			play_animation("idle")
			play_bras_animation("grenade")
		STATE.POMPE:
			linear_velocity.x = 0
			linear_velocity.x = 0
			$aim_gauche.rotation_degrees = 0
			$aim_droite.rotation_degrees = 0
			play_animation("idle")
			play_bras_animation("pompe")

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
			if wanna_left || wanna_right || wanna_jump:
				change_state(STATE.CONTROL)
			if wanna_bomb:
				change_state(STATE.GRENADE)
			if wanna_pompe:
				change_state(STATE.POMPE)
			if wanna_rocket:
				change_state(STATE.ROCKET)
			
		STATE.CONTROL:
			if wanna_bomb:
				change_state(STATE.GRENADE)
			if wanna_pompe:
				change_state(STATE.POMPE)
			if wanna_rocket:
				print("rocket")
				change_state(STATE.ROCKET)
				
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
					$aim_gauche.position.x = -35 
				elif direction == -1:
					$pivot.scale.x = 1
					$aim_droite.scale.x = 1
					$aim_droite.position.x = -35
					$aim_gauche.scale.x = 1
					$aim_gauche.position.x = 46 
			
			prev_dir = direction
			if direction != 0:
				apply_central_force(Vector2(direction * speed, 0))
			else:
				change_state(STATE.IDLE)
				
			#limite la vitesse, sinon c exponentiel
			if linear_velocity.x > max_h_speed:
				linear_velocity.x = max_h_speed
			elif linear_velocity.x < -max_h_speed:
				linear_velocity.x = -max_h_speed

			
				
			if wanna_jump and can_jump:
				play_animation("jump")
				can_jump = false
				jump_timer.start()
				apply_central_impulse(Vector2(0, -jump_force))
			
		STATE.ROCKET:
			print("ROCKET PRIME")
			if wanna_left || wanna_right || wanna_jump:
				change_state(STATE.CONTROL)
			if wanna_bomb:
				change_state(STATE.GRENADE)
			if wanna_pompe:
				change_state(STATE.POMPE)

			aim()
		STATE.GRENADE:
			if wanna_left || wanna_right || wanna_jump:
				change_state(STATE.CONTROL)
			if wanna_pompe:
				change_state(STATE.POMPE)
			if wanna_rocket:
				change_state(STATE.ROCKET)
			aim()
		STATE.POMPE:
			if wanna_left || wanna_right || wanna_jump:
				change_state(STATE.CONTROL)
			if wanna_bomb:
				change_state(STATE.GRENADE)
			if wanna_rocket:
				change_state(STATE.ROCKET)
			aim()
#endregion


func _on_jump_timer_timeout() -> void:
	can_jump = true
