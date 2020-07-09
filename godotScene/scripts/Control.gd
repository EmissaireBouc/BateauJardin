extends Control

enum{IDLE, MOVE}

#onready var nav2D : Navigation2D = $Navigation2D
onready var Line2D : Line2D = $Line2D
onready var Player : AnimatedSprite = $Player
onready var nav2D = get_parent().get_node("Bateau/WalkArea")

func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if !Input.is_action_pressed("ui_left_mouse"):
		return
	var new_path = nav2D.get_simple_path(Player.get_global_position(), get_global_mouse_position())
	print(get_global_mouse_position())
	print(Player.get_global_position())
	
	Line2D.points = new_path
	Player.path = new_path
	Player.change_state(MOVE)
