extends ColorRect
signal transition_over
var waitForClick = false

func ready():
	visible = true

func animation(anim):
	#transition_in : transparent vers noir
	#transition_out : noir vers transparent
	#transition_in_out : in + out
	
	$AnimationPlayer.play(anim)
	

func _on_AnimationPlayer_animation_finished(anim):
	if anim == "transition_in":
		emit_signal("transition_over", "transition_in")
	if anim == "transition_out":
		emit_signal("transition_over", "transition_out")


func _on_Transition_gui_input(event):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_left_mouse")&& waitForClick == true):
		animation("transition_out")
		waitForClick = false
