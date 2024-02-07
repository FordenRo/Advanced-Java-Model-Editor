extends VSplitContainer


@onready var animation_window := $BottomPanelContainer/MarginContainer/VBoxContainer/AnimationWindow
@onready var animation_tab := $BottomPanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AnimationTab


func _ready():
	ProjectManager.current_project_changed.connect(_on_current_project_changed)
	animation_tab.toggled.connect(tab_switch)


func _on_current_project_changed(project: Project):
	if not project:
		animation_tab.button_pressed = false
	animation_tab.disabled = project == null


func tab_switch(state: bool):
	animation_window.visible = state
	collapsed = not state
	dragger_visibility = SplitContainer.DRAGGER_VISIBLE if state else SplitContainer.DRAGGER_HIDDEN
