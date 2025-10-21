extends StaticBody2D

@onready var collision_shape = $CollisionPolygon2D
@onready var sprite2d = $Sprite2D

func clip(destruction_polygon):
	# Calculer le polygone avec offset (comme votre code actuel)
	var offset_polygon = []
	for point in destruction_polygon.polygon:
		offset_polygon.append(point + destruction_polygon.global_position)
	
	# Mettre à jour la collision (identique à votre code)
	var result = Geometry2D.clip_polygons(collision_shape.polygon, offset_polygon)
	if result.size() > 0:
		collision_shape.set_deferred("polygon", result[0])
	
	# Mettre à jour le masque du Sprite2D
	_update_sprite_mask(offset_polygon)

func _update_sprite_mask(destruction_polygon):
	var image = sprite2d.texture.get_image()
	
	# Convertir les coordonnées globales en coordonnées de texture
	var texture_polygon = []
	for point in destruction_polygon:
		var local_point = sprite2d.to_local(point)
		# Convertir en coordonnées de pixel de texture
		var texture_coord = (local_point + sprite2d.texture.get_size() / 2)
		texture_polygon.append(texture_coord)
	
# Dessiner le polygone en noir (ou transparent) pour masquer
# Utiliser des shaders ou manipulation directe de pixels
