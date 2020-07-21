extends Node2D

var nPlante #Noeud à instancier
var pv
var xp
var lvl

func init(plant):

	if plant == "Myosotis": nPlante = preload("res://Scenes/PlanteScene/Myosotis.tscn").instance()
	if plant == "Cactus": nPlante = preload("res://Scenes/PlanteScene/Cactus.tscn").instance()
	if plant == "Cosmos": nPlante = preload("res://Scenes/PlanteScene/Cosmos.tscn").instance()
	add_child(nPlante)
	pv = ImportData.plant_data["2"].PlantePV
	xp = ImportData.plant_data["2"].PlanteXP
	lvl = ImportData.plant_data["2"].PlanteLVL
	
	get_child(0).play("apparition")

func LVL_up():
	lvl += 1
	get_child(0).play("lvl"+str(lvl))
	print("lvl UP !")

func fane():
	get_child(0).play("fane")

