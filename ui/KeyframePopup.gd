extends PopupPanel


signal submitted(parent: String, file_name: String)

@onready var _file_name_edit := $MarginContainer/VBoxContainer/FileName
@onready var _parent_edit := $MarginContainer/VBoxContainer/Parent
@onready var _submit := $MarginContainer/VBoxContainer/HBoxContainer/Submit
@onready var _cancel := $MarginContainer/VBoxContainer/HBoxContainer/Cancel


func _ready():
	_submit.pressed.connect(func():
		submitted.emit(_parent_edit.text, _file_name_edit.text)
		hide()
	)
	_cancel.pressed.connect(func():
		hide()
	)
	_parent_edit.text_submitted.connect(func(_text: String):
		_file_name_edit.grab_focus()
	)
	_file_name_edit.text_submitted.connect(func(text: String):
		submitted.emit(_parent_edit.text, text)
		hide()
	)
	position = get_tree().root.size / 2 - size / 2
