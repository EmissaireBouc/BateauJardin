extends AnimatedSprite


export (int) var speed = 30
var move_direction = 30 #prend un angle en degré
var state #défini l'état du personnage (marche, idle, interact)
var path : PoolVector2Array
var destination = Vector2()

enum{IDLE, MOVE}

func _ready():
	destination = position

func _process(delta):

	match state:
		IDLE:
			animation_loop("IDLE")
		MOVE:
			var move_distance = speed * delta
			move_along_path(move_distance)
			animation_loop("WALK")


func move_along_path(distance):
# Déplacement PJ sur le chemin tracé grâce à Navigation 2D
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
# Change l'état du PJ (marche, idle, plant...)
	state = newstate
	match state:
		IDLE:
			animation_loop("IDLE")
		MOVE:
			animation_loop("WALK")


func animation_loop(mode):
# gestion de l'animation du PJ
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


