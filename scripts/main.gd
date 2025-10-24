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

var est_mort_avant = false

func _ready() -> void:
	
	VarEnd.has_game_ended = false
	duree_totale_timer.wait_time = VarBidules.duree_partie_sec
	duree_totale_timer.start()
	BiduleManager.set_main(self)
	$partie.wait_time = current_timer_time
	VarBidules.joueur_tjr_en_vie = true
	spawn_mobs()
	initialize_ui()
	start()
	
	# TODO faire un system de spawn -> besoin de la map avant
	# TODO base life mob
	# plus set_current() 

func spawn_mobs():
	#errants
	var errants_spawn_points = []
	for i in $"spawns-points/errants".get_children():
		errants_spawn_points.append(i)
	errants_spawn_points.shuffle()
	var selected_errant_sp = errants_spawn_points.slice(0, VarBidules.nbr_errants)
	for current_sp in selected_errant_sp:
		var current_errant = errants.instantiate()
		current_errant.global_position = current_sp.global_position
		current_errant.set_current("errant")
		$team_container/team_errants.add_child(current_errant)
		current_errant.connect("died", Callable(self, "_on_mob_died"))
		
	#garde
	var gardes_spawn_points = []
	for i in $"spawns-points/gardes".get_children():
		gardes_spawn_points.append(i)
	gardes_spawn_points.shuffle()
	var selected_gardes_sp = gardes_spawn_points.slice(0, VarBidules.nbr_gardes)
	for current_sp in selected_gardes_sp:
		var current_garde = gardes.instantiate()
		current_garde.global_position = current_sp.global_position
		current_garde.set_current("garde")
		$team_container/team_gardes.add_child(current_garde)
		current_garde.connect("died", Callable(self, "_on_mob_died"))
		
	#for i in range(VarBidules.nbr_errants):
		#var current_sp = $"spawns-points/errants".get_child(randi_range(0, 9))
		#if current_sp in errants_taken_sp:
			#while current_sp in errants_taken_sp:
				#print("nonon")
				#current_sp = $"spawns-points/errants".get_child(randi_range(0, 9))
		#errants_taken_sp.append(current_sp)
		#var current_errant = errants.instantiate()
		#current_errant.global_position = current_sp.global_position
		#current_errant.set_current(1)
		#$team_container/team_errants.add_child(current_errant)
		
	#gardes
	#var gardes_spawn_points = []
	#for i in $"spawns-points/gardes".get_children():
		#gardes_spawn_points.append(i)
	#var gardes_taken_sp = []
#
	#for i in range(VarBidules.nbr_gardes):
		#var current_sp = $"spawns-points/gardes".get_child(randi_range(0, 9))
		#if current_sp in gardes_taken_sp:
			#while current_sp in gardes_taken_sp:
				#print("nonon")
				#current_sp = $"spawns-points/gardes".get_child(randi_range(0, 9))
		#gardes_taken_sp.append(current_sp)
		#var current_gardes = gardes.instantiate()
		#current_gardes.global_position = current_sp.global_position
		#current_gardes.set_current(0)
		#$team_container/team_gardes.add_child(current_gardes)
	#print("FINISHED")

func update_mob_action(action):
	$CanvasLayer/UI/armes/pompe.modulate = Color("white")
	$CanvasLayer/UI/armes/control.modulate = Color("white")
	$CanvasLayer/UI/armes/patator.modulate = Color("white")
	$CanvasLayer/UI/armes/grenade.modulate = Color("white")
	$CanvasLayer/UI/armes/jump.modulate = Color("white")
	$CanvasLayer/UI/armes/aim.modulate = Color("white")
	match action:
		"aim":
			$CanvasLayer/UI/armes/aim.modulate = Color("green")
		"jump":
			$CanvasLayer/UI/armes/jump.modulate = Color("green")
		"pompe":
			$CanvasLayer/UI/armes/pompe.modulate = Color("green")
		"control":
			$CanvasLayer/UI/armes/control.modulate = Color("green")
		"patator":
			$CanvasLayer/UI/armes/patator.modulate = Color("green")
		"grenade":
			$CanvasLayer/UI/armes/grenade.modulate = Color("green")
	
	pass
	
func update_partie_duree_pb():
	$CanvasLayer/UI/ProgressBar.value = $partie.time_left
	
func initialize_ui():
	$CanvasLayer/UI/ProgressBar.max_value = current_timer_time
	$CanvasLayer/UI/ProgressBar.value = $CanvasLayer/UI/ProgressBar.max_value 
	$CanvasLayer/UI/Label.text = "LES GARDES"
	
	$CanvasLayer/UI/gardes.max_value = VarBidules.base_life * VarBidules.nbr_gardes
	$CanvasLayer/UI/gardes.value = $CanvasLayer/UI/gardes.max_value
	$CanvasLayer/UI/errants.max_value = VarBidules.base_life * VarBidules.nbr_errants
	$CanvasLayer/UI/errants.value = $CanvasLayer/UI/errants.max_value
	
func update_total_life_pb():
	var total_life_gardes : int
	for i in $team_container/team_gardes.get_children():
		total_life_gardes = total_life_gardes + i.current_life
	$CanvasLayer/UI/gardes.value = total_life_gardes
	var total_life_errants : int
	for i in $team_container/team_errants.get_children():
		total_life_errants = total_life_errants + i.current_life
	$CanvasLayer/UI/errants.value = total_life_errants
	
func _process(delta: float) -> void:
	update_partie_duree_pb()
	update_total_life_pb()
	
	if VarEnd.body_can_move == false:
		$duree_totale.paused = true
	else:
		$duree_totale.paused = false
	update_temps_restant()
	#update_mob_array()
	
func _physics_process(delta: float) -> void:
	if VarEnd.a_tire == true:
		$partie.stop()
	if VarEnd.can_end == true && $partie.time_left <= 0:
		update_game()

func update_temps_restant():
	
	$CanvasLayer/UI/Label6.text = str(int($duree_totale.time_left / 60)) + "mn " + str(int($duree_totale.time_left) % 60) + "s"
	
func update_mob_array(): # actualise les errants et les gardes dans le tableau 
	team_a_mobs.clear()
	for mob_a in $team_container/team_gardes.get_children():
		if mob_a.is_alive:
			team_a_mobs.append(mob_a)
	team_b_mobs.clear()
	for mob_b in $team_container/team_errants.get_children():
		if mob_b.is_alive:
			team_b_mobs.append(mob_b)
	if team_a_mobs.is_empty():
		print("TEAM B GAGNE")
		VarEnd.the_end = true
		get_tree().paused = true
		VarBidules.is_errant_winner = true
		await get_tree().create_timer(3).timeout
		get_tree().paused = false
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/equipe_qui_gagne.tscn")
		
	elif team_b_mobs.is_empty():
		print("TEAM A GAGNE")
		VarEnd.the_end = true
		get_tree().paused = true
		VarBidules.is_errant_winner = false
		await get_tree().create_timer(3).timeout
		get_tree().paused = false
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/equipe_qui_gagne.tscn")
		
func start():
	print("GAME STARTS !!")
	update_mob_array()
	select_mob()
	partie_timer.start()
	VarEnd.has_game_ended = false
	
# TODO connecter un signal pour chaque mob comme ca quand il y en a un qui meurt main.gd le sait et update_mob_array()
func update_game():
	if VarEnd.has_game_ended:
		return
	VarEnd.has_game_ended = true
	if !VarEnd.the_end:
		print("GAME UPDATED")
		change_playing_team()
		select_mob()
		$CanvasLayer/UI/ColorRect.show()
		get_tree().paused = true
		VarEnd.can_end = false
		VarBidules.joueur_tjr_en_vie = true
		start()
	
func change_playing_team(): # quelle team joue
	if current_playing_team == TEAM.A:
		current_playing_team = TEAM.B
		$CanvasLayer/UI/Label.text = "LES ERRANTS"
	else:
		current_playing_team = TEAM.A 
		$CanvasLayer/UI/Label.text = "LES GARDES"

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
	if VarEnd.has_game_ended:
		return
	VarEnd.has_game_ended = true

	get_tree().paused = true
	update_mob_array()
	if len(team_a_mobs) > len(team_b_mobs):
		VarBidules.is_errant_winner = false
	else:
		VarBidules.is_errant_winner = true
	VarEnd.has_game_ended = false
	
	
	await get_tree().create_timer(3).timeout
	get_tree().paused = false
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/temps_ecoule.tscn")


func _on_button_pressed() -> void:
	$CanvasLayer/UI/ColorRect.hide()
	get_tree().paused = false


func _on_aide_toggled(toggled_on: bool) -> void:
	$"CanvasLayer/UI/aide-menu".visible = toggled_on
	get_tree().paused = toggled_on


func _on_fin_map_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(500000)

func _on_mob_died(dead_bidule):
	print("Signal reçu de:", dead_bidule.name)
	if dead_bidule.is_selected:
		print("Le joueur sélectionné est mort, on update la partie")
		VarBidules.joueur_tjr_en_vie = false
		update_game()
		
