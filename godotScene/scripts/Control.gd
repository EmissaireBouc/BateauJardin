extends Node2D

# Load the custom images for the mouse cursor.
var default = load("res://Assets/UI/Curseur/Curs__0.png")
var planter = load("res://Assets/UI/Curseur/Curs__2.png")

var cursor = "default"
var jardin = []




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

	if Input.is_action_pressed("ui_left_mouse"):
		if cursor == "default":
			# Création du chemin entre la position du personnage et le mouse(x,y)
			var new_path = nav2D.get_simple_path(Player.get_global_position(), get_global_mouse_position())
			Line2D.points = new_path
			Player.path = new_path
			Player.change_state(MOVE)


# Ouverture du menu contextuel
func _input(event):
	if Input.is_action_pressed("ui_right_mouse"): 
		if get_node_or_null("MenuInteractions") == null:
			var MenuInteractions = load("res://Scenes/Menu_interactions.tscn").instance()
			add_child(MenuInteractions)
			cursor_mode("default")
		else:
			cursor_mode("planter")
			$MenuInteractions.queue_free()




func _ready():
	cursor_mode("default")


#Ne fonctionne pas pour le moment
#func create_area2D():
#	$Bateau/WalkArea/Area2D/CollisionPolygon2D.set_polygon($Bateau/WalkArea/NavigationPolygonInstance.navpoly.vertices)


func cursor_mode(newMode):
	cursor = newMode
	if (newMode == "default"):
		Input.set_custom_mouse_cursor(default)
	if (newMode == "planter"):
		Input.set_custom_mouse_cursor(planter)



func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_left_mouse") && cursor == "planter"):
		var plante = preload("res://Scenes/Plante.tscn").instance()
		$YSort.add_child(plante)
		jardin.push_front(plante)
		jardin[0].position = get_global_mouse_position()


func _on_Jardin_mouse_entered():
	if cursor == "planter":
		Input.set_custom_mouse_cursor(planter)


func _on_Jardin_mouse_exited():
	if cursor == "planter":
		var nplanter = load("res://Assets/UI/Curseur/Curs__3.png")
		Input.set_custom_mouse_cursor(nplanter)


func _on_Area2D_mouse_entered():
	if cursor == "default":
		Input.set_custom_mouse_cursor(default)


func _on_Area2D_mouse_exited():
	if cursor == "default":
		var ndefault = load("res://Assets/UI/Curseur/Curs__1.png")
		Input.set_custom_mouse_cursor(ndefault)
