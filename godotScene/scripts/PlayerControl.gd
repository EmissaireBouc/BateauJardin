extends AnimatedSprite

export (int) var speed = 30
var move_direction = 30
var destination = Vector2()

enum{IDLE, MOVE}
var state
var path : PoolVector2Array

func _ready():
	destination = position

func _process(delta):
	var move_distance = speed * delta

	match state:
		IDLE:
			Animation_Loop("IDLE")
		MOVE:
			move_along_path(move_distance)
			Animation_Loop("WALK")



func move_along_path(distance):
	var starting_point : = position

	for i in range(path.size()):
		var distance_to_next : = starting_point.distance_to(path[0])
		move_direction = rad2deg(path[0].angle_to_point(position))
		
		if (distance <= distance_to_next):
			position = starting_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		path.remove(0)
		
		if(path.size() == 0):
			change_state(IDLE)


func change_state(newstate):
	state = newstate
	match state:
		IDLE:
			Animation_Loop("IDLE")
		MOVE:
			Animation_Loop("WALK")




func Animation_Loop(mode):

	var anim_direction = "S"
	var anim_mode = mode
	var animation

	if move_direction <= 60 and move_direction >= -60 :
		anim_direction = "E"
	elif move_direction <= 120 and move_direction >= 60 :
		anim_direction = "S"
	elif move_direction <= 180 and move_direction >= 120 :
		anim_direction = "W"
	elif move_direction <= -120 :
		anim_direction = "W"
	elif move_direction <= -60 and move_direction >= -120 :
		anim_direction = "N"

	animation = anim_mode + "_" + anim_direction
	self.play(animation) 


#func _unhandled_input(event):
#	#Si Clic de souris : target = Mouse(x,y)
#	if event.is_action_pressed('ui_left_mouse'):
#		moving = true
#		destination = get_global_mouse_position()

#func _walk(destination):
#	if moving == false:
#		speed = 30
#
#	movement = position.direction_to(destination) * speed
#	move_direction = rad2deg(destination.angle_to_point(position))
#
#
#	if position.distance_to(destination) > 5:
#		movement = move_and_slide(movement)
#	else: 
#		moving = false
#
#	#Joue animation marche si velocity != 0
#	if movement.length() > 0:
#		movement = movement.normalized()*speed
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()

#func _physics_process(delta):
#	
#	if cursorMode == 'walk':
#		_walk(destination)
			
#	if moving == true:
#		anim_mode = "Walk"
#	elif moving == false:
#		anim_mode = "Idle"
