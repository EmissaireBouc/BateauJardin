extends Area2D

var overlapPlant
var areaName = ""
var aCollisionNode = []
var item_selected = false
signal debug

func initiate():
#	visible = true
	if get_overlapping_areas().size() <= 2:
		overlapPlant = false
		$Polygon2D.set_self_modulate(45)
	else:
		overlapPlant = true
		$Polygon2D.set_self_modulate(130)

"""
Configure la position des éléments du collision shape associés à la souris 
"""
func _process(delta):
	global_position = get_global_mouse_position()
	$Polygon2D.global_position = get_global_mouse_position()
	$CollisionShape2D.global_position = get_global_mouse_position()

func _unhandled_input(event):
	if Input.is_action_pressed("ui_right_mouse") && !item_selected && overlapPlant:
		item_selected = true
"""
Seules les plantes (layer : plante) sont concernées par les collisions de gMouseCollider.
"""
func _on_gMouseCollider_area_shape_entered(area_id, area, area_shape, self_shape):
	if item_selected == false:
		aCollisionNode.push_back(area)
		if aCollisionNode.size() == 1:
				select_plant(area)

func _on_gMouseCollider_area_shape_exited(area_id, area, area_shape, self_shape):
	if item_selected == false :
		#Si area est l'aire actuellement en surbrillance : deselectionne l'aire
		if area == aCollisionNode[0]:
			unselect_plant(area)
		#On supprime du tableau le noeud qui quitte l'aire d'influence de la souris
		aCollisionNode.remove(aCollisionNode.find(area))
		#S'il reste des elements dans le tableau, le premier element devient l'element selectionne
		if aCollisionNode.size() != 0:
			select_plant(aCollisionNode[0])

func select_plant(area):
	overlapPlant = true
	areaName = area.get_parent().get_parent().get_name()
	emit_signal("debug", area.get_parent().get_name(), area.get_parent().get_parent().pv, area.get_parent().get_parent().lvl, area.get_parent().get_parent().xp)
	area.get_parent().set_material(preload("res://Assets/Mask/Outline.tres"))
#	$Polygon2D.set_self_modulate(130)

func unselect_plant(area):
	overlapPlant = false
	areaName = ""
	area.get_parent().set_material(null)
#	$Polygon2D.set_self_modulate(45)

func clear_aCollisionNode():
	unselect_plant(aCollisionNode[0])
	aCollisionNode.clear()
	item_selected = false
	


