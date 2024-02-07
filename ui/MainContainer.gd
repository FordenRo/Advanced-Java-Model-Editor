extends Control


@onready var displayContainer = $DisplayViewportContainer
@onready var editContainer = $EditViewportContainer


func _ready():
	ProjectManager.mode_changed.connect(_on_mode_changed)


func _on_mode_changed():
	editContainer.visible = ProjectManager.mode == ProjectManager.Mode.Edit
	displayContainer.visible = ProjectManager.mode == ProjectManager.Mode.Display
