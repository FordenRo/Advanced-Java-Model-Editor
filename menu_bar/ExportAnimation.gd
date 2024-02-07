extends PopupMenu


@onready var text_popup = $TextPopup
var selected_animation: String
var parent: String


func _ready():
	index_pressed.connect(_on_index_pressed)
	about_to_popup.connect(_on_show)
	text_popup.submitted.connect(_on_text_popup_submitted)


func _on_show():
	clear()
	for animation: String in ProjectManager.current_project.animation_library.get_animation_list():
		add_item(animation)


func _on_index_pressed(index: int):
	selected_animation = ProjectManager.current_project.animation_library.get_animation_list()[index]
	text_popup.show()


@warning_ignore('shadowed_variable')
func _on_text_popup_submitted(text: String):
	parent = text
	
	var dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.use_native_dialog = true
	dialog.dir_selected.connect(_dir_selected)
	dialog.show()


func _dir_selected(path: String):
	var animation = ProjectManager.current_project.animation_library.get_animation(selected_animation)
	var old_pos = ProjectManager.current_project.animation_position
	ProjectManager.current_project.animation_position = 0
	
	for i in range(int(animation.length) + 1):
		var json = {}
		json.parent = parent
		json.display = ProjectManager.current_project.model.display.to_json()
		
		var file = FileAccess.open(path + "\\" + selected_animation + "_" + str(i) + ".json", FileAccess.WRITE)
		file.store_string(JSON.stringify(json, "", false))
		file.close()
		
		ProjectManager.current_project.animation_position += 1
	
	ProjectManager.current_project.animation_position = old_pos
