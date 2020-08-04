extends Node2D

var nPlante #Noeud à instancier
var pv
var xp
var lvl

func init(plant):
#	nplante = preload ("res://Scenes/PlanteScene/%s" %plant).instance()
	if plant == "Myosotis": nPlante = preload("res://Scenes/PlanteScene/Myosotis.tscn").instance()
	if plant == "Cactus": nPlante = preload("res://Scenes/PlanteScene/Cactus.tscn").instance()
	if plant == "Cosmos": nPlante = preload("res://Scenes/PlanteScene/Cosmos.tscn").instance()
	if plant == "Pleureur": nPlante = preload("res://Scenes/PlanteScene/Pleureur.tscn").instance()
	if plant == "Arbuste": nPlante = preload("res://Scenes/PlanteScene/Arbuste.tscn").instance()
	if plant == "Bleuet": nPlante = preload("res://Scenes/PlanteScene/Bleuet.tscn").instance()
	if plant == "BuissonBlanc2": nPlante = preload("res://Scenes/PlanteScene/BuissonBlanc2.tscn").instance()
	if plant == "BuissonBlanc": nPlante = preload("res://Scenes/PlanteScene/BuissonBlanc.tscn").instance()
	if plant == "BuissonBleu": nPlante = preload("res://Scenes/PlanteScene/BuissonBleu.tscn").instance()
	if plant == "BuissonRose": nPlante = preload("res://Scenes/PlanteScene/BuissonRose.tscn").instance()
	if plant == "CactusOrange": nPlante = preload("res://Scenes/PlanteScene/CactusOrange.tscn").instance()
	if plant == "CactusRouge": nPlante = preload("res://Scenes/PlanteScene/CactusRouge.tscn").instance()
	if plant == "FeuillesVertRouge": nPlante = preload("res://Scenes/PlanteScene/FeuillesVertRouge.tscn").instance()
	if plant == "Flocons": nPlante = preload("res://Scenes/PlanteScene/Flocons.tscn").instance()
	if plant == "Glycines": nPlante = preload("res://Scenes/PlanteScene/Glycines.tscn").instance()
	if plant == "HautArbuste": nPlante = preload("res://Scenes/PlanteScene/HautArbuste.tscn").instance()
	if plant == "JaunesHautes": nPlante = preload("res://Scenes/PlanteScene/JaunesHautes.tscn").instance()
	if plant == "OrangeFines": nPlante = preload("res://Scenes/PlanteScene/OrangeFines.tscn").instance()
	if plant == "OreillesDeLapin": nPlante = preload("res://Scenes/PlanteScene/OreillesDeLapin.tscn").instance()
	if plant == "Pompom": nPlante = preload("res://Scenes/PlanteScene/Pompom.tscn").instance()
	if plant == "RosesPlates": nPlante = preload("res://Scenes/PlanteScene/RosesPlates.tscn").instance()
	if plant == "RoseTremiere": nPlante = preload("res://Scenes/PlanteScene/RoseTremiere.tscn").instance()
	if plant == "Rouge": nPlante = preload("res://Scenes/PlanteScene/Rouge.tscn").instance()
	
	add_child(nPlante)
	pv = ImportData.plant_data[plant].PV
	xp = ImportData.plant_data[plant].XP
	lvl = ImportData.plant_data[plant].LVL

	get_child(0).play("apparition")

func LVL_up():
	lvl += 1
	get_child(0).play("lvl"+str(lvl))

func fane():
	get_child(0).play("fane")


