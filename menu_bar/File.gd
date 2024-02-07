extends PopupMenu


enum {
	NEW_PROJECT = 1,
	OPEN_PROJECT,
	SAVE,
	SAVE_AS,
	IMPORT,
	EXPORT,
	CLOSE_PROJECT,
	EXIT
}


func _ready():
	id_pressed.connect(_id_pressed)
	ProjectManager.current_project_changed.connect(_on_current_project_changed)
	set_item_submenu(get_item_index(EXPORT), "Export")


func _id_pressed(id: int):
	if id == NEW_PROJECT:
		var dialog = FileDialog.new()
		dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		dialog.title = "Open a new project's model"
		dialog.add_filter("*.json", "Java Minecraft Model")
		dialog.access = FileDialog.ACCESS_FILESYSTEM
		dialog.use_native_dialog = true
		dialog.file_selected.connect(_create_new_project_model_selected)
		dialog.show()
	elif id == OPEN_PROJECT:
		var dialog = FileDialog.new()
		dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		dialog.add_filter("*.jmepr", "Java Model Editor Project")
		#dialog.add_filter("*.json", "Java Minecraft Model")
		dialog.access = FileDialog.ACCESS_FILESYSTEM
		dialog.use_native_dialog = true
		dialog.file_selected.connect(_open_file)
		dialog.show()
	elif id == SAVE or id == SAVE_AS:
		if not ProjectManager.current_project.file_path or id == SAVE_AS:
			var dialog = FileDialog.new()
			dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
			dialog.add_filter("*.jmepr", "Java Model Editor Project")
			dialog.access = FileDialog.ACCESS_FILESYSTEM
			dialog.use_native_dialog = true
			dialog.file_selected.connect(_save_file)
			dialog.show()
		elif id == SAVE:
			_save_file(ProjectManager.current_project.file_path)
	elif id == CLOSE_PROJECT:
		ProjectManager.close_project(ProjectManager.current_project)
	elif id == EXIT:
		get_tree().quit()


func _save_file(path: String):
	var file = FileAccess.open(path + ".jmepr", FileAccess.WRITE)
	file.store_string(JSON.stringify(ProjectManager.current_project.to_json(), "", false))
	file.close()
	ProjectManager.current_project.file_path = path + ".jmepr"


@warning_ignore('shadowed_variable_base_class')
func _open_file(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var project: Project = Project.from_json(JSON.parse_string(file.get_as_text()))
	file.close()
	
	var title = path.split('\\')
	project.title = title[title.size() - 1]
	ProjectManager.add_project(project)


@warning_ignore('shadowed_variable_base_class')
func set_item_visibility(id: int, visible: bool):
	set_item_disabled(get_item_index(id), !visible)


@warning_ignore('shadowed_variable_base_class')
func _create_new_project_model_selected(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var model = JavaModel.from_json(JSON.parse_string(file.get_as_text()))
	file.close()
	
	var title = path.split('\\')
	var new_project := Project.new(model)
	new_project.title = title[title.size() - 1]
	ProjectManager.add_project(new_project)


func _on_current_project_changed(project: Project):
	var is_project_opened = project != null
	
	set_item_visibility(SAVE, is_project_opened)
	set_item_visibility(SAVE_AS, is_project_opened)
	set_item_visibility(EXPORT, is_project_opened)
	set_item_visibility(CLOSE_PROJECT, is_project_opened)
