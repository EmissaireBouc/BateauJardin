extends Button

func _on_Jouer_pressed():
	get_tree().change_scene("res://Scenes/Scene_Principale.tscn")
	pass # Replace with function body.


func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Options.tscn")
	pass # Replace with function body.


func _on_Quitter_pressed():
	get_tree().quit()
	pass # Replace with function body.
