extends Camera2D

@export var deplacementenpx : float = 25
@export var zoomenpx : float = 0.01

var base_zoom : Vector2 = Vector2(0.2, 0.2)
var current_zoom : Vector2 
var cameraoffsetx : float = 0
var cameraoffsety : float = 0
var cameraglobal : Vector2 = Vector2(0, 0)

func _ready() -> void:
	pass
	#focus()
func reset_zoom():
	
	
	
	
func focus():
	global_position = BiduleManager.get_mob_position()
	reset_
	
func _process(delta: float) -> void:
	
#func _physics_process(delta: float) -> void:
	#if Input.is_action_pressed("camera_right"):
		#self.offset.x += deplacementenpx
		#update()
	#if Input.is_action_pressed("camera_left"):
		#self.offset.x -= deplacementenpx
		#update()
	#if Input.is_action_pressed("camera_down"):
		#self.offset.y += deplacementenpx
		#update()
	#if Input.is_action_pressed("camera_up"):
		#self.offset.y -= deplacementenpx
		#update()
	#if Input.is_action_pressed("camera_zoom_up"):
		#self.zoom.x += zoomenpx
		#self.zoom.y += zoomenpx
		#update()
	#if Input.is_action_pressed("camera_zoom_down"):
		#self.zoom.x -= zoomenpx
		#self.zoom.y -= zoomenpx
		#update()
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
