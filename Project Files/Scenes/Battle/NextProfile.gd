extends GridContainer

func resizeName():
	if get_node("Name").text.length() > 16:
		self.rect_min_size[0] = 420
		get_node("Name").autowrap = true
