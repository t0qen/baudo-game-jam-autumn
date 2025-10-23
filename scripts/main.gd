extends Node2D

# IMPORTANT
# quand je dis "mob" je sous entends "bidule"

@onready var camera_2d: Camera2D = $Camera2D

#var nb_errants: int = 4
#var nb_gardes: int = 4

var errants = preload("res://scenes/errants.tscn")
var gardes = preload("res://scenes/gardes.tscn")

@onready var partie_timer: Timer = $partie

enum TEAM {
	A,
	B
}
var current_playing_team : TEAM = TEAM.A
var team_a_mobs = []
var team_b_mobs = []
# index de quel mob a jouer la derniere fois pour chaque equipe 
var prev_playing_mob_a : int = -1
var prev_playing_mob_b : int = -1
# index de quel mob doit jouer pour envoyer au BiduleManager
var current_paying_mob_a 
var current_paying_mob_b 

var winner_team : TEAM = TEAM.A
var current_timer_time = VarBidules.duree_tour_sec

func _ready() -> void:
	BiduleManager.set_main(self)
	$partie.wait_time = current_timer_time
	initialize_ui()
	start()
	# TODO faire un system de spawn -> besoin de la map avant
	# plus set_current() 

func update_partie_duree_pb():
	$UI/ProgressBar.value = $partie.time_left
	
func initialize_ui():
	$UI/ProgressBar.max_value = current_timer_time
	$UI/ProgressBar.value = current_timer_time
	$UI/Label.text = "TEAM QUI JOUE : LES GARDES"
	
func _process(delta: float) -> void:
	update_partie_duree_pb()
	print($partie.time_left)
	
func _physics_process(delta: float) -> void:
	pass
	#update_mob_array() # TODO optimiser, update quand il y a un mob qui meurt

func update_mob_array(): # actualise les errants et les gardes dans le tableau 
	team_a_mobs = []
	for mob_a in $team_container/team_errants.get_children():
		team_a_mobs.append(mob_a)
	print("Errants : ", team_a_mobs)
	team_b_mobs = []
	for mob_b in $team_container/team_gardes.get_children():
		team_b_mobs.append(mob_b)
	print("Gardes : ", team_a_mobs)
	
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
		print("----------------- team b's turn !")
		current_playing_team = TEAM.B
		$UI/Label.text = "TEAM QUI JOUE : LES ERRANTS"
	else:
		print("----------------- team a's turn !")
		current_playing_team = TEAM.A 
		$UI/Label.text = "TEAM QUI JOUE : LES GARDES"

func select_mob(): # on regarde quel bidule doit jouer
	if current_playing_team == TEAM.A:
		print("selecting mob to playfor team A")
		if (prev_playing_mob_a + 1) > len(team_a_mobs): # si la derniere fois qu'on a joue ct le dernier bidule : on recommence du debut
			current_paying_mob_a = team_a_mobs[0]
			print("restarted loop")
		else:
			current_paying_mob_a = team_a_mobs[prev_playing_mob_a + 1]
		prev_playing_mob_a = team_a_mobs.bsearch(current_paying_mob_a) # renvoie l'index de current playing mob
		print("Prev playing mob a : ", prev_playing_mob_a)
		print("current : ", current_paying_mob_a)
		BiduleManager.set_current(current_paying_mob_a)
	else:
		print("selecting mob to playfor team B")
		if (prev_playing_mob_b + 1) > len(team_b_mobs): # si la derniere fois qu'on a joue ct le dernier bidule : on recommence du debut
			current_paying_mob_b = team_b_mobs[0]
			print("restarted loop")
		else:
			current_paying_mob_b = team_b_mobs[prev_playing_mob_b + 1]
		prev_playing_mob_a = team_b_mobs.bsearch(current_paying_mob_b) # renvoie l'index de current playing mob
		print("Prev playing mob b : ", prev_playing_mob_b)
		print("current : ", current_paying_mob_b)
		BiduleManager.set_current(current_paying_mob_b)
	
	
func _on_partie_timeout() -> void:
	update_game() # quand le timer de la partie est finie on update -> changement de team
	
