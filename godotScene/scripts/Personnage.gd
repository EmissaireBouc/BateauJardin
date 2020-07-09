#extends Node2D
#
#
#var mousePosition = Vector2(0,0)
#
#
#
#func _ready():
#	# Mettre ici fonction Walk par défaut
#	pass 
#
#
#
#func _process(delta):
#	if mousePosition != Vector2(0,0):
#		_walk(mousePosition)
#
#func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.pressed:
#			print("Left button was clicked at ", event.position)
#			mousePosition = event.position
#
#		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
#			print("Wheel up")
#
#func _walk(mousePosition):
#	global_translate(mousePosition)
#	print($sprPJ.position)
#	print(mousePosition)
