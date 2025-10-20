extends Node2D

@onready var collision_shape = $StaticBody2D/CollisionPolygon2D
@onready var visual_polygon = $Polygon2D

func clip(destruction_polygon):
	var offset_polygon = []
	for point in destruction_polygon.polygon:
		offset_polygon.append(point + destruction_polygon.global_position)
	var result = Geometry2D.clip_polygons(collision_shape.polygon, offset_polygon)
	if result.size() > 0:
		collision_shape.set_deferred("polygon", result[0])
		visual_polygon.polygon = result[0]
		# Fix le positionnement :
		visual_polygon.position = Vector2.ZERO
		collision_shape.position = Vector2.ZERO
