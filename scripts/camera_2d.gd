extends Camera2D

@export var deplacement : float = 20
@export var zoomForce : float = 2

var base_zoom : Vector2 = Vector2(0.2, 0.2)
var current_zoom : Vector2 
var cameraoffsetx : float = 0
var cameraoffsety : float = 0
var cameraglobal : Vector2 = Vector2(0, 0)
var isfocus : bool = true

func _ready() -> void:
	pass
	
func reset_zoom():
	zoom.x = 0.2
	zoom.y = 0.2
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var movementsVect : Vector2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
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
