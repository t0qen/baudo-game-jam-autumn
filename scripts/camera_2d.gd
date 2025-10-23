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
	current_zoom = base_zoom
	
func focus():
	global_position = BiduleManager.get_mob_position()
	reset_zoom()
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("camera_right"):
		global_position.x += deplacementenpx
	if Input.is_action_pressed("camera_left"):
		global_position.x -= deplacementenpx
	if Input.is_action_pressed("camera_down"):
		global_position.y += deplacementenpx
	if Input.is_action_pressed("camera_up"):
		global_position.y -= deplacementenpx
	if Input.is_action_pressed("camera_zoom_up"):
		zoom.x += zoomenpx
		zoom.y += zoomenpx
	if Input.is_action_pressed("camera_zoom_down"):
		zoom.x -= zoomenpx
		zoom.y -= zoomenpx
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
