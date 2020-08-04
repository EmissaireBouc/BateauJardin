extends Label
var PA


func PA_down(d):
	PA -= d
	PA_update()

func PA_up(d):
	PA += d
	PA_update()

func set_PA(d):
	PA = d
	PA_update()

func get_PA():
	return PA

func PA_update():
	text = "PA : "+str(PA)

