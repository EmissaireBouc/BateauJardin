extends MarginContainer

func is_open():
	if visible:
		return true
	else:
		return false

func open():
	if !visible:
		visible = true

func close():
	if visible:
		visible = false
