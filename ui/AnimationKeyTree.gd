extends Tree


var last_position: int


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
	custom_minimum_size = rect.position + rect.size + Vector2(10, 30)
	if last_position != ProjectManager.current_project.animation_position:
		queue_redraw()
		last_position = ProjectManager.current_project.animation_position


#func _process(delta):
	#queue_redraw()
#
#
func _draw():
	if not ProjectManager.current_project or ProjectManager.current_project.current_animation.is_empty():
		return
	
	#if not get_root() or not get_root().get_first_child():
		#return
	#
	var x = (ProjectManager.current_project.animation_position + 0.5) / (ProjectManager.current_project.animation_library.get_animation(ProjectManager.current_project.current_animation).length + 1.0)
	var from = Vector2(size.x * x, 0)
	var to = Vector2(size.x * x, size.y)
	#var time = ProjectManager.current_project.animation_position
	#var rect = get_item_area_rect(get_root().get_first_child().get_next_in_tree(), time)
	#var x = rect.position.x + rect.size.x / 2 - get_scroll().x
	#var from = Vector2(x, 0)
	#var to = Vector2(x, size.y)
	draw_line(from, to, Color.CADET_BLUE, 3.0)
