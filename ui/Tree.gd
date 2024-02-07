extends Tree


signal item_right_clicked(item: TreeItem)


func _ready():
	ProjectManager.current_project_changed.connect(_on_current_project_changed)
	item_mouse_selected.connect(_on_item_mouse_selected)
	item_edited.connect(_on_item_edited)


func _on_item_edited():
	ProjectManager.current_project.model.elements[get_selected().get_index()].title = get_selected().get_text(0)


@warning_ignore('shadowed_variable_base_class')
func _on_item_mouse_selected(position: Vector2, button_index: int):
	if button_index == MOUSE_BUTTON_RIGHT:
		item_right_clicked.emit(get_item_at_position(position))


func _on_element_changed(idx: int):
	get_edited().set_text(0, ProjectManager.current_project.model.elements[idx].title)


func delete_selected():
	ProjectManager.current_project.model.elements[get_selected().get_index()].queue_free()
	get_selected().free()


func _on_current_project_changed(project: Project):
	clear()
	if ProjectManager.current_project and ProjectManager.current_project.model.element_changed.is_connected(_on_element_changed):
		ProjectManager.current_project.model.element_changed.disconnect(_on_element_changed)
	#for element: Element in ProjectManager.current_project.model.elements:
		#element.title_changed
	if not project:
		return
		
	project.model.element_changed.connect(_on_element_changed)
	
	create_item()
	get_root().set_text(0, project.title)
	for element in project.model.elements:
		var item = create_item(get_root())
		item.set_text(0, element.title)
