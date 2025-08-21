extends Sprite2D

func sprite_to_polygon() -> void:
	var data = texture.get_data()
	
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(data)
	
	var polys = bitmap.opaque_to_polygons(
		Rect2(
			Vector2.ZERO,
			texture.get_size()
		),
		5
	)
