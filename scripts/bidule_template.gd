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
	wanna_aim_left = Input.is_action_just_pressed("aim_left")
	wanna_aim_right = Input.is_action_just_pressed("aim_right")
	
func _ready() -> void:
	change_state(STATE.CONTROL)
	BiduleManager.selected_mob_changed.connect(_on_selected_bidule_changed)

func _on_selected_bidule_changed(new_bidule):
	if new_bidule == self:
		print("SELECTED !!!!!!!!!!!")
		is_selected = true
		modulate = Color(0, 1, 1, 1)
		change_state(STATE.CONTROL)
	else:
		print("UNSELECTED !!!!!!!!!!!")
		is_selected = false
		modulate = Color(1, 1, 1, 1)
		
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
	pass

func die():
	queue_free()
	BiduleManager.ask_to_update_mob_array()
	
func play_animation(animation):
	
	if current == MOB_POSSIBILITY.GARDE:
		$sprites.play("garde_" + animation)
	else:
		$sprites.play("errant_" + animation)
		
		
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
			play_animation("idle")
		STATE.CONTROL:
			play_animation("control")
		STATE.ROCKET:
			pass
		STATE.GRENADE:
			pass
		STATE.POMPE:
			pass

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
		STATE.CONTROL:
			direction = 0
			if wanna_left:
				direction = -1
				$sprites.flip_h = true
			elif wanna_right:
				direction = 1
				$sprites.flip_h = false

			if direction != 0:
				print("ok dir")
				apply_central_force(Vector2(direction * speed, 0))
			else:
				change_state(STATE.IDLE)
				
			#limite la vitesse, sinon c exponentiel
			if linear_velocity.x > max_h_speed:
				linear_velocity.x = max_h_speed
			elif linear_velocity.x < -max_h_speed:
				linear_velocity.x = -max_h_speed

			if wanna_bomb:
				change_state(STATE.GRENADE)
			if wanna_pompe:
				change_state(STATE.POMPE)
			if wanna_rocket:
				change_state(STATE.ROCKET)
				
			if wanna_jump and can_jump:
				play_animation("jump")
				can_jump = false
				jump_timer.start()
				apply_central_impulse(Vector2(0, -jump_force))
			
		STATE.ROCKET:
			if wanna_left || wanna_right || wanna_jump:
				change_state(STATE.CONTROL)
			aim()
		STATE.GRENADE:
			if wanna_left || wanna_right || wanna_jump:
				change_state(STATE.CONTROL)
			aim()
		STATE.POMPE:
			if wanna_left || wanna_right || wanna_jump:
				change_state(STATE.CONTROL)
			aim()
#endregion


func _on_jump_timer_timeout() -> void:
	can_jump = true
