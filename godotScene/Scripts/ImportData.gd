extends Node

var plant_data

func _ready():
	var plantdata_file = File.new()
	plantdata_file.open("res://Assets/Data/PlanteData.json",File.READ)
	var plantdata_json = JSON.parse(plantdata_file.get_as_text())
	plantdata_file.close()
	plant_data = plantdata_json.result
