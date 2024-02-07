extends PopupPanel

class_name TextPopup


signal submitted(text: String)

@onready var _value_edit := $MarginContainer/VBoxContainer/Value
@onready var _submit := $MarginContainer/VBoxContainer/HBoxContainer/Submit
@onready var _cancel := $MarginContainer/VBoxContainer/HBoxContainer/Cancel

@export var placeholder: String :
	set(value):
		placeholder = value
		if _value_edit:
			_value_edit.placeholder_text = value


func _ready():
	_value_edit.placeholder_text = placeholder
	_submit.pressed.connect(func():
		submitted.emit(_value_edit.text)
		hide()
	)
	_cancel.pressed.connect(func():
		hide()
	)
	_value_edit.text_submitted.connect(func(text: String):
		submitted.emit(text)
		hide()
	)
	position = get_tree().root.size / 2 - size / 2
