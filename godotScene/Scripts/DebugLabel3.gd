extends Label



func _on_gMouseCollider_debug(nom, pv, lvl, xp):
	text = "Nom : " + nom + "\nPv : " + str(pv) + "\nLvl : " + str(lvl) + "\nXp : " + str(xp)
