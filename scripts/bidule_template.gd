extends RigidBody2D

@export var is_selected : bool = false

# NODES
@onready var jump_timer: Timer = $jump_timer


# BOOLEAN
var can_jump : bool = true

# MOVEMENTS VARS
@export var speed : int = 800
@export var jump_force : int = 1200
@export var max_h_speed : int = 300

# INPUTS VARS
var wanna_jump : bool
var wanna_left : bool
var wanna_right : bool
var direction : int = 0


func get_inputs():
	wanna_jump = Input.is_action_just_pressed("jump")
	wanna_left = Input.is_action_pressed("left")
	wanna_right = Input.is_action_pressed("right")
	
func _ready() -> void:
	change_state(STATE.CONTROL)
	
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_selected:
		get_inputs()
		update_state()

#region STATE MACHINE
# -- STATE MACHINE --
enum STATE {
	IDLE, # ne bouge pas 
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
			pass
		STATE.CONTROL:
			pass
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
			pass
		STATE.CONTROL:
			direction = 0
			if wanna_left:
				direction = -1
			elif wanna_right:
				direction = 1

			if direction != 0:
				print("ok dir")
				apply_central_force(Vector2(direction * speed, 0))
			
			#limite la vitesse, sinon c exponentiel
			if linear_velocity.x > max_h_speed:
				linear_velocity.x = max_h_speed
			elif linear_velocity.x < -max_h_speed:
				linear_velocity.x = -max_h_speed

			if wanna_jump and can_jump:
				can_jump = false
				jump_timer.start()
				apply_central_impulse(Vector2(0, -jump_force))

			
		STATE.ROCKET:
			pass
		STATE.GRENADE:
			pass
		STATE.POMPE:
			pass
#endregion


func _on_jump_timer_timeout() -> void:
	can_jump = true
