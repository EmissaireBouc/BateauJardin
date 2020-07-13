extends Node2D

# enum est une énumération des différentes actions que le personnage peut effectuer
enum{IDLE, MOVE}

# Le mot clé "onready" permet d'assigner une valeur à une variable dès l'exécution du script. Remplace func _ready()
# Navigation2D est un noeud qui permet le pathfinding depuis une aire de navigation (NavigationPolygon)
onready var nav2D : Navigation2D = $Bateau/WalkArea
# Line2D trace une ligne (débug)
onready var Line2D : Line2D = $YSort/Line2D
onready var Player : AnimatedSprite = $YSort/Player


# _unhandled_input(event) récupère l'input souris DANS la scène active (normalement doit permettre de distinguer des inputs qui ont lieu dans le HUD) 
func _unhandled_input(event):
	if !Input.is_action_pressed("ui_left_mouse"):
		return
	
	# Création du chemin entre la position du personnage et le mouse(x,y)
	var new_path = nav2D.get_simple_path(Player.get_global_position(), get_global_mouse_position())
		
	Line2D.points = new_path
	Player.path = new_path
	Player.change_state(MOVE)

# Ouverture du menu contextuel	
func _input(event):
	if Input.is_action_pressed("ui_right_mouse"):
		var MenuInteractions = load("res://Scenes/Menu_interactions.tscn").instance()
		add_child(MenuInteractions)


	
