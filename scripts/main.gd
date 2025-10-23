extends Node2D

# IMPORTANT
# quand je dis "mob" je sous entends "bidule"

@onready var camera_2d: Camera2D = $Camera2D

#var nb_errants: int = 4
#var nb_gardes: int = 4

var errants = preload("res://scenes/errants.tscn")
var gardes = preload("res://scenes/gardes.tscn")

@onready var partie_timer: Timer = $partie

@onready var duree_totale_timer: Timer = $duree_totale

enum TEAM {
	A,
	B
}
var current_playing_team : TEAM = TEAM.A
var team_a_mobs = []
var team_b_mobs = []
# index de quel mob a jouer la derniere fois pour chaque equipe 
var prev_playing_mob_a : int = 0
var prev_playing_mob_b : int = 0
# index de quel mob doit jouer pour envoyer au BiduleManager
var current_playing_mob_a 
var current_playing_mob_b 

var winner_team : TEAM = TEAM.A
var current_timer_time = VarBidules.duree_tour_sec

func _ready() -> void:
	duree_totale_timer.wait_time = VarBidules.duree_partie_sec
	duree_totale_timer.start()
	BiduleManager.set_main(self)
	$partie.wait_time = current_timer_time
	initialize_ui()
	start()
	# TODO faire un system de spawn -> besoin de la map avant
	# TODO base life mob
	# plus set_current() 

func update_mob_action(action):
	print("update action 2")
	$Camera2D/UI/armes/pompe.modulate = Color("white")
	$Camera2D/UI/armes/control.modulate = Color("white")
	$Camera2D/UI/armes/patator.modulate = Color("white")
	$Camera2D/UI/armes/grenade.modulate = Color("white")
	
	match action:
		"pompe":
			$Camera2D/UI/armes/pompe.modulate = Color("green")
		"control":
			$Camera2D/UI/armes/control.modulate = Color("green")
		"patator":
			$Camera2D/UI/armes/patator.modulate = Color("green")
		"grenade":
			$Camera2D/UI/armes/grenade.modulate = Color("green")
	
	
	
func update_partie_duree_pb():
	$Camera2D/UI/ProgressBar.value = $partie.time_left
	
func initialize_ui():
	$Camera2D/UI/ProgressBar.max_value = current_timer_time
	$Camera2D/UI/ProgressBar.value = $Camera2D/UI/ProgressBar.max_value 
	$Camera2D/UI/Label.text = "LES GARDES"
	
	$Camera2D/UI/gardes.max_value = VarBidules.base_life * VarBidules.nbr_gardes
	$Camera2D/UI/gardes.value = $Camera2D/UI/gardes.max_value
	$Camera2D/UI/errants.max_value = VarBidules.base_life * VarBidules.nbr_errants
	$Camera2D/UI/errants.value = $Camera2D/UI/errants.max_value
	
func update_total_life_pb():
	var total_life_gardes : int
	for i in $team_container/team_gardes.get_children():
		total_life_gardes = total_life_gardes + i.current_life
	$Camera2D/UI/gardes.value = total_life_gardes
	var total_life_errants : int
	for i in $team_container/team_errants.get_children():
		total_life_errants = total_life_errants + i.current_life
	$Camera2D/UI/errants.value = total_life_errants
	
func _process(delta: float) -> void:
	update_partie_duree_pb()
	update_total_life_pb()
	update_temps_restant()
	#update_mob_array()
	
func _physics_process(delta: float) -> void:
	pass

func update_temps_restant():
	$Camera2D/UI/Label6.text = str(int($duree_totale.time_left / 60)) + "mn " + str(int($duree_totale.time_left) % 60) + "s"
	
	
func update_mob_array(): # actualise les errants et les gardes dans le tableau 
	team_a_mobs.clear()
	for mob_a in $team_container/team_errants.get_children():
		if mob_a.is_alive:
			team_a_mobs.append(mob_a)
	team_b_mobs.clear()
	for mob_b in $team_container/team_gardes.get_children():
		if mob_b.is_alive:
			team_b_mobs.append(mob_b)
	if team_a_mobs.is_empty():
		print("TEAM B GAGNE")
		get_tree().paused = true
		VarBidules.is_errant_winner = true
		await get_tree().create_timer(3).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/equipe_qui_gagne.tscn")
		
	elif team_b_mobs.is_empty():
		print("TEAM A GAGNE")
		get_tree().paused = true
		VarBidules.is_errant_winner = false
		await get_tree().create_timer(3).timeout
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/equipe_qui_gagne.tscn")
		
func start():
	print("GAME STARTS !!")
	update_mob_array()
	select_mob()
	partie_timer.start()
	
# TODO connecter un signal pour chaque mob comme ca quand il y en a un qui meurt main.gd le sait et update_mob_array()
func update_game():
	print("GAME UPDATED")
	change_playing_team()
	select_mob()
	
func change_playing_team(): # quelle team joue
	if current_playing_team == TEAM.A:
		current_playing_team = TEAM.B
		$Camera2D/UI/Label.text = "LES ERRANTS"
	else:
		current_playing_team = TEAM.A 
		$Camera2D/UI/Label.text = "GARDES"

func select_mob(): # on regarde quel bidule doit jouer
	update_mob_array()
	update_mob_action("no")
	
	var current_team = team_a_mobs if current_playing_team == TEAM.A else team_b_mobs
	var index_prev = prev_playing_mob_a if current_playing_team == TEAM.B else prev_playing_mob_b
	if current_team.size() > 0:
		var current_playing_mob = current_team[index_prev % current_team.size()]
		if current_playing_team == TEAM.A:
			prev_playing_mob_a += 1
		else:
			prev_playing_mob_b += 1
		BiduleManager.set_current(current_playing_mob)
		
		
	
	#if current_playing_team == TEAM.A:
		#print("selecting mob to playfor team A")
		#if (prev_playing_mob_a + 1) > len(team_a_mobs): # si la derniere fois qu'on a joue ct le dernier bidule : on recommence du debut
			#current_playing_mob_a = team_a_mobs[0]
			#print("restarted loop")
		#else:
			#current_playing_mob_a = team_a_mobs[prev_playing_mob_a + 1]
		#prev_playing_mob_a = team_a_mobs.bsearch(current_playing_mob_a) # renvoie l'index de current playing mob
		#print("Prev playing mob a : ", prev_playing_mob_a)
		#print("current : ", current_playing_mob_a)
		#BiduleManager.set_current(current_playing_mob_a)
	#else:
		#print("selecting mob to playfor team B")
		#if (prev_playing_mob_b + 1) > len(team_b_mobs): # si la derniere fois qu'on a joue ct le dernier bidule : on recommence du debut
			#current_playing_mob_b = team_b_mobs[0]
			#print("restarted loop")
		#else:
			#current_playing_mob_b = team_b_mobs[prev_playing_mob_b + 1]
		#prev_playing_mob_a = team_b_mobs.bsearch(current_playing_mob_b) # renvoie l'index de current playing mob
		#print("Prev playing mob b : ", prev_playing_mob_b)
		#print("current : ", current_playing_mob_b)
		#BiduleManager.set_current(current_playing_mob_b)
	
	
func _on_partie_timeout() -> void:
	update_game() # quand le timer de la partie est finie on update -> changement de team
	


func _on_focus_pressed() -> void:
	$Camera2D.focus()


func _on_duree_totale_timeout() -> void:
	get_tree().paused = true
	update_mob_array()
	if len(team_a_mobs) > len(team_b_mobs):
		VarBidules.is_errant_winner = false
	else:
		VarBidules.is_errant_winner = true
	
	
	await get_tree().create_timer(3).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/temps_ecoule.tscn")
