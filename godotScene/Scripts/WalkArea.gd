extends Navigation2D

func _ready():
	update_navigation_polygon(get_parent().get_parent().get_node("Bateau/YSort/Cabine/Sprite/CollisionPolygon2D").get_global_transform(),get_parent().get_parent().get_node("Bateau/YSort/Cabine/Sprite/CollisionPolygon2D").get_polygon())
	

func update_navigation_polygon(t, p):
	#$Bateau/WalkArea/Area2D/CollisionPolygon2D.set_polygon($Bateau/WalkArea/NavigationPolygonInstance.navpoly.vertices)
	var newpolygon = PoolVector2Array()
	var polygon = $NavigationPolygonInstance.get_navigation_polygon()
#	var polygon_transform = get_parent().get_parent().get_node("YSort/Cabine/Sprite/Area2D/CollisionPolygon2D").get_global_transform()
#	var polygon_bp = get_parent().get_parent().get_node("YSort/Cabine/Sprite/Area2D/CollisionPolygon2D").get_polygon()
	var polygon_transform = t
	var polygon_bp = p
	for vertex in polygon_bp:
		newpolygon.append(polygon_transform.xform(vertex))
	polygon.add_outline(newpolygon)
	polygon.make_polygons_from_outlines()
	$NavigationPolygonInstance.set_navigation_polygon(polygon)
	get_node("NavigationPolygonInstance").enabled = false
	get_node("NavigationPolygonInstance").enabled = true

