extends PopupMenu


enum {
	RENAME,
	DELETE
}


func _ready():
	get_parent().item_right_clicked.connect(_on_item_right_clicked)
	id_pressed.connect(_on_id_pressed)


func _on_id_pressed(id: int):
	if id == RENAME:
		get_parent().edit_selected(true)
	elif id == DELETE:
		get_parent().delete_selected()


func _on_item_right_clicked(item: TreeItem):
	if item == get_parent().get_root():
		return
	position = get_tree().root.get_mouse_position()
	show()
