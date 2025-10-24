extends Camera2D

@export var deplacement : float = 80
@export var zoomForce : float = 0.03
@onready var timer: Timer = $Timer

var base_zoom : Vector2 = Vector2(0.2, 0.2)
var current_zoom : Vector2 
var cameraoffsetx : float = 0
var cameraoffsety : float = 0
var cameraglobal : Vector2 = Vector2(0, 0)
var isfocus : bool = true
var can_focus : bool = true
func _ready() -> void:
	pass
	
func reset_zoom():
	zoom.x = 0.2
	zoom.y = 0.2
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var movementsVect : Vector2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if movementsVect != Vector2.ZERO:
		global_position += (movementsVect * deplacement)
		can_focus = false
	else:
		if !timer.time_left > 0:
			timer.start()
	if can_focus && VarBidules.joueur_tjr_en_vie:
		global_position = BiduleManager.get_mob_position()
		
	if Input.is_action_pressed("camera_zoom_up"):
		zoom += Vector2(zoomForce, zoomForce)
		if zoom > Vector2(0.86, 0.86):
			zoom = Vector2(0.86, 0.86)
	if Input.is_action_pressed("camera_zoom_down"):
		zoom -= Vector2(zoomForce, zoomForce)
		if zoom < Vector2(0.05, 0.05):
			zoom = Vector2(0.05, 0.05)

func _on_timer_timeout() -> void:
	can_focus = true
