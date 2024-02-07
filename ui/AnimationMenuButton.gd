extends MenuButton


enum {
	NEW
}

@onready var new_animation_popup: TextPopup = $NewAnimationPopup


func _ready():
	get_popup().id_pressed.connect(_on_id_pressed)
	new_animation_popup.submitted.connect(_new_animation_submit)


@warning_ignore('shadowed_variable_base_class')
func _new_animation_submit(name: String):
	ProjectManager.current_project.create_animation(name)


func _on_id_pressed(id: int):
	if id == NEW:
		new_animation_popup.show()
