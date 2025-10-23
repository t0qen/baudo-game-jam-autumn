extends Camera2D

@export var deplacement : float = 2
@export var zoomForce : float = 2

var base_zoom : Vector2 = Vector2(0.2, 0.2)
var current_zoom : Vector2 
var cameraoffsetx : float = 0
var cameraoffsety : float = 0
var cameraglobal : Vector2 = Vector2(0, 0)
var isfocus : bool = true

func _ready() -> void:
	pass
	await get_tree().create_timer(0.1).timeout
	focus()
	
func reset_zoom():
	zoom.x = 0.2
	zoom.y = 0.2
	
func focus():
	while isfocus == true:
		global_position = BiduleManager.get_mob_position()
		reset_zoom()
		await get_tree().create_timer(0.0001).timeout
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var movementsVect : Vector2 = Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	global_position += (movementsVect * deplacement)
	var zoomVar = Input.get_axis("camera_zoom_down", "camera_zoom_up")
	zoom += Vector2(zoomVar, zoomVar) * zoomForce
	if !zoomVar && !movementsVect:
		global_position = BiduleManager.get_mob_position()
	
	#if Input.is_action_pressed("camera_right"):
		#isfocus = false
		#global_position.x += deplacementenpx
	#if Input.is_action_pressed("camera_left"):
		#isfocus = false
		#global_position.x -= deplacementenpx
	#if Input.is_action_pressed("camera_down"):
		#isfocus = false
		#global_position.y += deplacementenpx
	#if Input.is_action_pressed("camera_up"):
		#isfocus = false
		#global_position.y -= deplacementenpx
	#if Input.is_action_pressed("camera_zoom_up"):
		#isfocus = false
		#zoom.x += zoomenpx
		#zoom.y += zoomenpx
	#if Input.is_action_pressed("camera_zoom_down"):
		#isfocus = false
		#zoom.x -= zoomenpx
		#zoom.y -= zoomenpx
	#if Input.is_action_just_pressed("camera_focus"):
		#isfocus = true
		#focus()
	
#
#func update():
	#cameraoffsetx = self.offset.x
	#camerazoomy = self.offset.y
	#camerazoomx = self.zoom.x
	#camerazoomy = self.zoom.y
#
#func focus():
	#self.global_position = BiduleManager.get_mob_position()
	#self.zoom.x = 0.2
	#self.zoom.y = 0.2
	#update()
