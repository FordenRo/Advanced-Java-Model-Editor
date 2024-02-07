extends TabContainer


@onready var elementsTab = $Elements
@onready var displayTab = $Display


func _ready():
	ProjectManager.current_project_changed.connect(_on_current_project_changed)
	tab_changed.connect(_on_tab_changed)
	set_tab_disabled(1, true)


func _on_current_project_changed(project: Project):
	set_tab_disabled(1, project == null)
	if not project and current_tab == 1:
		current_tab = 0


func _on_tab_changed(tab: int):
	ProjectManager.mode = ProjectManager.Mode.Edit if tab == 0 else ProjectManager.Mode.Display if tab == 1 else ProjectManager.mode
