extends PopupMenu


enum {
	MODEL,
	ANIMATION
}


func _ready():
	id_pressed.connect(_on_id_pressed)
	set_item_submenu(get_item_index(ANIMATION), "Animation")


func _on_id_pressed(id: int):
	if id == MODEL:
		var dialog = FileDialog.new()
		dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		dialog.add_filter("*.json", "Minecraft Java Model")
		dialog.access = FileDialog.ACCESS_FILESYSTEM
		dialog.use_native_dialog = true
		dialog.file_selected.connect(_export_model)
		dialog.show()


func _export_model(path: String):
	var file = FileAccess.open(path + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify(ProjectManager.current_project.model.to_json(), "", false))
	file.close()
