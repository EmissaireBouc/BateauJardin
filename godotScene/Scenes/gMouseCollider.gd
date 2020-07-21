extends Area2D
var overlapObs

func initiate():
	visible = true
	if get_overlapping_areas().size() <= 2:
		overlapObs = false
		$Polygon2D.set_self_modulate(45)
	else:
		overlapObs = true
		$Polygon2D.set_self_modulate(130)

func _process(delta):
	global_position = get_global_mouse_position()
	$Polygon2D.global_position = get_global_mouse_position()
	$CollisionShape2D.global_position = get_global_mouse_position()


func _on_gMouseCollider_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.get_name() != "Jardin":
		overlapObs = true
		$Polygon2D.set_self_modulate(130)

func _on_gMouseCollider_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.get_name() != "Jardin" && get_overlapping_areas().size() <= 2:
		overlapObs = false
		$Polygon2D.set_self_modulate(45)
