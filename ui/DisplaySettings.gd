extends VBoxContainer


@onready var translation_settings = $TranslationDisplaySettings
@onready var rotation_settings = $RotationDisplaySettings


func _ready():
	ProjectManager.mode_changed.connect(func():
		if ProjectManager.mode == ProjectManager.Mode.Display:
			var display = ProjectManager.current_project.model.display.firstperson_righthand
			translation_settings.value = display.translation
			rotation_settings.value = display.rotation
	)
	ProjectManager.current_project_changed.connect(_current_project_changed)


func _current_project_changed(project: Project):
	if ProjectManager.current_project:
		ProjectManager.current_project.model.display.firstperson_righthand.changed.disconnect(_display_changed)
	if project:
		var display = project.model.display.firstperson_righthand
		display.changed.connect(_display_changed)
		translation_settings.value = display.translation
		rotation_settings.value = display.rotation


func _display_changed():
	var display = ProjectManager.current_project.model.display.firstperson_righthand
	if ProjectManager.mode == ProjectManager.Mode.Display:
		translation_settings.value = display.translation
		rotation_settings.value = display.rotation
