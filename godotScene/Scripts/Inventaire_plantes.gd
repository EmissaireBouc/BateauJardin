extends Control

signal item_selected
signal plant_abort

var itemID

onready var itemlist : ItemList = get_node("AnimationPlayer/TextureRect/ItemList")


func is_open():
	if visible:
		return true
	else:
		return false

func open():
	if !visible:
		itemlist.unselect_graine()
		visible = true
		$AnimationPlayer.play("Apparition")
		

func close():
	if visible:
		$AnimationPlayer.play("Fermeture")

func is_item_selected():
	if itemlist.return_selected_item() == null:
		return false
	else:
		return true

func get_selected_item():
	return itemlist.return_selected_item()

func _on_ItemList_item_selected(index):
	if itemID != index:
		itemlist.modulate_icon()
	itemID = index
	itemlist.set_item_icon_modulate(index, Color(1,1,1,1))




func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fermeture":
		visible = false


func _on_B_Valider_pressed():
	if is_item_selected():
		emit_signal("item_selected")
	else :
		pass


func _on_B_Annuler_pressed():
	close()
	emit_signal("plant_abort")
