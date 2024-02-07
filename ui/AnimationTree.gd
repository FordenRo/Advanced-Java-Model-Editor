extends Tree


func _process(_delta):
	var item = get_root()
	if not item:
		return
		
	while item:
		if item.get_next_in_tree():
			item = item.get_next_in_tree()
		else:
			break
	
	var rect = get_item_area_rect(item, columns - 1)
	custom_minimum_size = Vector2(0, rect.position.y + rect.size.y + 30)
