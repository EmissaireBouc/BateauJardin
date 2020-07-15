extends ColorRect


func _ready():
	$AnimationPlayer.play("transition_out")
	
	
func _process(delta):
	pass


func _on_AnimationPlayer_animation_finished(transition_out):
	queue_free()
	pass
