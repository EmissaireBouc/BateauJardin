extends Node2D

# Load the custom images for the mouse cursor.
var default = load("res://Assets/UI/Curseur/curseur_normal.png")
var planter = load("res://Assets/UI/Curseur/curseur_normal.png")
var cursor = "default"
var posCursor
signal anim_over
var action

#Tableau des plantes
var aGarden = []

#Chaîne d'animation


export (int) var day = 0


# enum est une énumération des différentes animations que le personnage peut jouer
enum{IDLE, MOVE, PLANT, PLANT_BACK, OPEN_INV, SPRAY, CUT}
enum{DEFAULT, PLANTER, ENTRETENIR, ARROSER, COUPER, DORMIR, PARLER}


# Le mot clé "onready" permet d'assigner une valeur à une variable dès l'exécution du script. Remplace func _ready()
onready var nav2D : Navigation2D = $Bateau/WalkArea # Navigation2D est un noeud qui permet le pathfinding depuis une aire de navigation (NavigationPolygon)
onready var Line2D : Line2D = $Bateau/YSort/Line2D # Line2D trace une ligne (débug)
onready var Player : AnimatedSprite = $Bateau/YSort/Player
onready var MouseA : Area2D = get_node("Bateau/YSort/gMouseCollider")
onready var menuInventaire : Area2D = get_node("CanvasLayer/Control/Inventory")
onready var menuEntretenir : Area2D = get_node("CanvasLayer/Control/MenuInteractions")
onready var Cam : Camera2D = get_node("Bateau/YSort/Player/Camera2D")
onready var PA : Label = get_node("CanvasLayer/PA")

func _ready():
	change_action(DEFAULT)
	fondu("transition_out")
	cursor_mode("default")
	$CanvasLayer/Transition.visible = true
	PA.set_PA(5)
	
	$AudioStreamPlayer2D.play()


func _process(delta):
	$CanvasLayer/DebugLabel2.text = "Animation en cours : " + str(Player.state) + "\nAction en cours : " + str(action) + "\nZoom : x" + str(round(Cam.get_zoom().x*100)/100)


"""
Gestion du clic gauche :
	_unhandled_input(event) récupère l'input souris DANS la scène active 
	(distingue des inputs qui ont lieu dans le HUD)
	Gère le Clic gauche (par défaut : Marcher)
"""


func _unhandled_input(event):
	if !Input.is_action_pressed("ui_left_mouse"):
		return

	if Input.is_action_pressed("ui_left_mouse"):
		match action :
			DEFAULT :
				if !menuEntretenir.is_open():
					Player.change_state(MOVE)
				else:
					menuEntretenir.close()
					Cam.zoom_out()


"""
Gestion du clic droit :
	- Si une plante est en surbrillance (chevauchée par la souris) : ouvre le menu Entretenir
	- Si L'inventaire des graines n'est pas ouvert : ouvre le menu Graine
	- Sinon : fermeture du menu Graine et du menu Entretenir et retour sur le curseur par défaut
"""


func _input(event):
	if Input.is_action_pressed("ui_select"):
		get_node("CanvasLayer/Control/Inventory/ItemList").add_graine("Cactus")
		#get_tree().call_group("Plantes", "fane")

	if !Input.is_action_pressed("ui_right_mouse"):
		return

	if Input.is_action_pressed("ui_right_mouse"):
		match action:
			DEFAULT:
				if MouseA.overlapPlant && !menuInventaire.is_open():
					posCursor = get_node("Bateau/YSort/%s" %MouseA.areaName).get_global_position()
					menuEntretenir.open()

			PLANTER:
				change_action(DEFAULT)
				menuInventaire.close()

	#Debug fonction
	if Input.is_action_pressed("ui_select"):
		get_node("CanvasLayer/Control/Inventory/ItemList").add_graine("Cactus")
		#get_tree().call_group("Plantes", "fane")

func cursor_mode(newMode):
	cursor = newMode
	if (newMode == "default"):
		Input.set_custom_mouse_cursor(default)
		MouseA.visible = false

	if (newMode == "planter"):
		Input.set_custom_mouse_cursor(planter)
		MouseA.initiate()

func _on_Jardin_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_right_mouse") && !MouseA.overlapPlant):
		if PA.get_PA() > 0: 
			match action:
				DEFAULT:
					change_action(PLANTER)



"""
Gestion des actions du joueur :
	- change_action change l'action en cours et initie son développement. La première action que le PJ doit effectuer
	se réalise ici. 
	- Dès qu'une animation se termine, un signal est émis vers _on_Player_anim_over(). En fonction de l'action en cours
	et de l'animation (state) terminée, l'action suivante se joue.
	- Lorsque la suite d'une action n'est pas conditionnée par la fin d'une animation du PJ mais par autre chose
	(fermerture d'un menu, pression d'un bouton etc.), se référer aux autres signaux présents dans cette section
	 
"""
func change_action(newaction):
	action = newaction

	match action:
		DEFAULT:
			Player.change_state(IDLE)
		PLANTER:
			cursor_mode("planter")
			posCursor = get_global_mouse_position()
			Player.change_state(MOVE, Vector2(posCursor.x, posCursor.y-25))

		ARROSER:
			Player.change_state(MOVE, Vector2(posCursor.x, posCursor.y-25))
			menuEntretenir.close()

		COUPER:
			Player.change_state(MOVE, Vector2(posCursor.x, posCursor.y-25))
			menuEntretenir.close()
		DORMIR:
			posCursor = get_global_mouse_position()
			Player.change_state(MOVE, Vector2(posCursor.x, posCursor.y+25))


func _on_Player_anim_over(state):
	match action:
		DEFAULT:
			match state :
				MOVE:
					Player.change_state(IDLE)
		PLANTER:
			match state:
				MOVE : 
					menuInventaire.open()
					Player.change_state(OPEN_INV)
				PLANT:
					PA.PA_down(1)
					var planteName = menuInventaire.get_selected_item()
					var plante = preload("res://Scenes/PlanteScene/Plante.tscn").instance()
					plante.init(planteName) # mettre une variable String avec le nom de la plante à créer
					$Bateau/YSort.add_child(plante)
					aGarden.push_front(plante)
					aGarden[0].position = posCursor
					planteName = planteName + "/Area2D/CollisionPolygon2D"
					$Bateau/WalkArea.update_navigation_polygon(aGarden[0].get_node(planteName).get_global_transform(),aGarden[0].get_node(planteName).get_polygon())
					cursor_mode("default")
					print_garden()
					Player.change_state(PLANT_BACK)
				PLANT_BACK:
					change_action(DEFAULT)
		ARROSER:
			match state:
				MOVE:
					Player.change_state(SPRAY)
				SPRAY:
					PA.PA_down(1)
					plante_PV_up(MouseA.areaName)
					change_action(DEFAULT)
		COUPER:
			match state :
				MOVE:
					Player.change_state(CUT)
				CUT:
					PA.PA_down(1)
					plante_Remove(MouseA.areaName)
					change_action(DEFAULT)
		DORMIR:
			match state :
				MOVE:
					fondu("transition_in")
					change_action(DEFAULT)


func _on_Inventory_item_selected():
	match action:
		PLANTER:
			menuInventaire.close()
			Player.change_state(PLANT)

func _on_Inventory_plant_abort():
	change_action(DEFAULT)

func _on_Button_Cut_pressed():
	change_action(COUPER)

func _on_Button_Spray_pressed():
	change_action(ARROSER)

"""
Gestion des actions Entretenir :
	plante_PV_up(plant) : Augmente les pv de 5 et coûte 1PA
	plante_Remove(plant) : Retire une plante du tableau (Manque l'animation de 
	destruction)
"""

func plante_PV_up(plant):
	get_node("Bateau/YSort/%s" %plant).pv += 5
	MouseA.clear_aCollisionNode()

func plante_Remove(plant):
	for i in range(aGarden.size()-1):
		if aGarden[i] == get_node("Bateau/YSort/%s" %plant):
			aGarden.remove(i)
	get_node("Bateau/YSort/%s" %plant).queue_free()
	print_garden()
	MouseA.clear_aCollisionNode()

"""
Gestion du curseur de la souris :
	Pour le moment : aucune gestion
"""


func _on_Jardin_mouse_entered():
	if cursor == "planter":
		Input.set_custom_mouse_cursor(planter)

func _on_Jardin_mouse_exited():
	if cursor == "planter":
		var nplanter = load("res://Assets/UI/Curseur/curseur_normal.png")
		Input.set_custom_mouse_cursor(nplanter)

func _on_Area2D_mouse_entered():
	if cursor == "default":
		Input.set_custom_mouse_cursor(default)

func _on_Area2D_mouse_exited():
	if cursor == "default":
		var ndefault = load("res://Assets/UI/Curseur/curseur_normal.png")
		Input.set_custom_mouse_cursor(ndefault)


"""
Gestion de l'action Dormir :
	Lors clic sur porte de la cabine : 
	Player marche vers la porte -> animation entre dans la cabine -> transition_in -> actualisation du bateau
	-> texte : Un_Jour_Passe -> transition_out -> animation sort de la cabine
"""


func _on_Porte_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_left_mouse")):
		change_action(DORMIR)

func _on_Transition_transition_over(t):
	if t == "transition_in":
		a_day_pass()
	if t == "transition_out":
		$CanvasLayer/Transition/Jour.visible = false

func fondu(animName):
	$CanvasLayer/Transition/AnimationPlayer.play(animName)

func a_day_pass():
	day += 1
	PA.set_PA(5)
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
	for i in range(aGarden.size()-1):
		aGarden[i].xp -= 1
		if aGarden[i].xp == 0:
			aGarden[i].LVL_up()


"""
Gestion des fonctions Debug
"""
func print_garden():
	var array = ""
	for i in range(aGarden.size()):
		array += "\n[" + str(aGarden[i].get_name()) + "] : " + aGarden[i].get_child(0).get_name()
	$CanvasLayer/DebugLabel.text = "Jardin : " + array




