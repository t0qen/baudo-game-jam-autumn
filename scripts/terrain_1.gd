
extends Node2D

@onready var poly: Polygon2D = $TerrainPolygon
@onready var collision: CollisionPolygon2D = $Destructible/TerrainCollision

func _ready():
	poly.polygon = [
		Vector2(0, 400),
		Vector2(200, 300),
		Vector2(400, 350),
		Vector2(600, 320),
		Vector2(800, 400),
		Vector2(800, 600),
		Vector2(0, 600),
	]
	collision.polygon = poly.polygon


func destroy_area(world_pos: Vector2, radius: float):
	var hole = create_circle(world_pos, radius)
	
	# Soustraction du trou du terrain
	var new_polys = Geometry2D.exclude_polygons(poly.polygon, hole)
	
	if new_polys.size() > 0:
		poly.polygon = new_polys[0]
		collision.polygon = new_polys[0]
	else:
		poly.polygon = PackedVector2Array() # tout détruit
		collision.polygon = PackedVector2Array()


func create_circle(center: Vector2, radius: float, segments: int = 24) -> PackedVector2Array:
	var pts: PackedVector2Array = []
	for i in range(segments):
		var angle = TAU * float(i) / float(segments)
		pts.append(center + Vector2(cos(angle), sin(angle)) * radius)
	return pts
