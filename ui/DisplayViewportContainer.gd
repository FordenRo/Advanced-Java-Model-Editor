extends AspectRatioContainer


enum {
	LOAD_IMAGE,
	LOAD_VIDEO,
}

@onready var popup := $PopupMenu
@onready var texture_rect := $TextureRect


func _ready():
	popup.id_pressed.connect(_on_popup_id_pressed)


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if not event.pressed:
				popup.show()


func _on_popup_id_pressed(id: int):
	if id == LOAD_IMAGE:
		var dialog = FileDialog.new()
		dialog.access = FileDialog.ACCESS_FILESYSTEM
		dialog.use_native_dialog = true
		dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		dialog.file_selected.connect(_on_dialog_file_selected)
		dialog.show()


func _on_dialog_file_selected(path: String):
	texture_rect.texture = ImageTexture.create_from_image(Image.load_from_file(path))
