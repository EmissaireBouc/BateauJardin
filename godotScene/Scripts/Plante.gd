extends Node2D

var nPlante #Noeud à instancier
var pv
var xp
var lvl

func init(plant):
	#nplante = preload ("res://Scenes/PlanteScene/%s" %plant).instance()
	if plant == "Myosotis": nPlante = preload("res://Scenes/PlanteScene/Myosotis.tscn").instance()
	if plant == "Cactus": nPlante = preload("res://Scenes/PlanteScene/Cactus.tscn").instance()
	if plant == "Cosmos": nPlante = preload("res://Scenes/PlanteScene/Cosmos.tscn").instance()
	add_child(nPlante)
	pv = ImportData.plant_data[plant].PV
	xp = ImportData.plant_data[plant].XP
	lvl = ImportData.plant_data[plant].LVL
	
	
	get_child(0).play("apparition")

func LVL_up():
	lvl += 1
	get_child(0).play("lvl"+str(lvl))
	print("lvl UP !")

func fane():
	get_child(0).play("fane")

