extends ItemList
"""
A l'ouverture de l'inventaire, itération dans le dictionnaire plant_data (importData.gd). Si une plante
est disponible (available), le bouton associé devient visible
"""

func _ready():
	make_inventory()

func make_inventory():
	for key in ImportData.plant_data:
		if ImportData.plant_data[key].Available == 1:
			create_item(key)

func create_item(plante):
	var texture = load("res://Assets/UI/Inv/%s" %"icon"+ImportData.plant_data[plante].Name+".png")
	add_item(ImportData.plant_data[plante].Name, texture)


func return_selected_item():
	if is_anything_selected():
		var array = []
		array = get_selected_items()
		return get_item_text(array[0])
	else: 
		return

func add_graine(plante):
	ImportData.plant_data[plante].Available = 1
	create_item(plante)



	
