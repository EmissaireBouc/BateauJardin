extends Node2D

# Load the custom images for the mouse cursor.
var default = load("res://Assets/UI/Curseur/Curs__0.png")
var planter = load("res://Assets/UI/Curseur/Curs__2.png")
var cursor = "default"
var posCursor

#Tableau des plantes
var aGarden = []

export (int) var day = 0
export (int) var pa = 5


# enum est une énumération des différentes actions que le personnage peut effectuer
enum{IDLE, MOVE, PLANT}

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
			moving_PJ()

# Ouverture du menu contextuel
func _input(event):
	if Input.is_action_pressed("ui_right_mouse"):
		if get_node_or_null("MenuInteractions") == null:
			#$CanvasLayer/Control/MenuInteractions.visible = true
			var MenuInteractions = load("res://Scenes/Menu_interactions.tscn").instance()
			add_child(MenuInteractions)
			cursor_mode("default")
		else:
			cursor_mode("planter")
			#$CanvasLayer/Control/MenuInteractions.visible = false
			#$MenuInteractions.queue_free()

func moving_PJ():
	var new_path = nav2D.get_simple_path(Player.get_global_position(), get_global_mouse_position())
	Line2D.points = new_path
	Player.path = new_path
	Player.change_state(MOVE)
	

func _ready():
	cursor_mode("default")
	fondu("transition_out")
	$CanvasLayer/Transition.visible = true
	$CanvasLayer/Transition/PA.PA_update(pa)



func cursor_mode(newMode):
	cursor = newMode
	if (newMode == "default"):
		Input.set_custom_mouse_cursor(default)
		$YSort/gMouseCollider.visible = false
		
	if (newMode == "planter"):
		Input.set_custom_mouse_cursor(planter)
		$YSort/gMouseCollider.initiate()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_left_mouse") && cursor == "planter" && $YSort/gMouseCollider.overlapObs == false):
		if pa > 0: action_planter()


func action_planter():
	posCursor = get_global_mouse_position()
	moving_PJ()

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

func _on_Porte_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_left_mouse")):
		fondu("transition_in")

func _on_Transition_transition_over(t):
	
	if t == "transition_in":
		a_day_pass()
	if t == "transition_out":
		$CanvasLayer/Transition/Jour.visible = false

func a_day_pass():
	day += 1
	pa = 5 
	$CanvasLayer/Transition/PA.PA_update(pa)
	$CanvasLayer/Transition/Jour.text = "Jour "+str(day)
	$CanvasLayer/Transition/Jour.visible = true
	$CanvasLayer/Transition.waitForClick = true
	plante_XP_up()
	plante_PV_down()

func plante_PV_down():
	for i in range(aGarden.size()):
		aGarden[i].pv -= 1
		if aGarden[i].pv <= 0:
			aGarden[i].fane()

func plante_XP_up():
	for i in range(aGarden.size()):
		aGarden[i].xp -= 1
		if aGarden[i].xp == 0:
			aGarden[i].LVL_up()

func fondu(animName):
	$CanvasLayer/Transition/AnimationPlayer.play(animName)


func _on_Player_walkover():
	if cursor == "planter":
		var planteName = "Cosmos"
		var plante = preload("res://Scenes/PlanteScene/Plante.tscn").instance()
		plante.init(planteName) # mettre une variable String avec le nom de la plante à créer
		$YSort.add_child(plante)
		aGarden.push_front(plante)
		aGarden[0].position = posCursor
		pa -= 1
		planteName = planteName + "/Area2D/CollisionPolygon2D"
		$Bateau/WalkArea.update_navigation_polygon(aGarden[0].get_node(planteName).get_global_transform(),aGarden[0].get_node(planteName).get_polygon())
		$CanvasLayer/Transition/PA.PA_update(pa)
		Player.change_state(PLANT)

