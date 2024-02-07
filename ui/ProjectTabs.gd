extends TabBar


var tabs: Array[Tab] = []


func _ready():
	ProjectManager.project_added.connect(_on_project_added)
	ProjectManager.project_removed.connect(_on_project_removed)
	ProjectManager.current_project_changed.connect(_on_current_project_changed)
	tab_close_pressed.connect(_close_tab)
	tab_clicked.connect(_tab_clicked)


func _tab_clicked(tab: int):
	ProjectManager.current_project = _get_tab_by_index(tab).project


func _close_tab(tab: int):
	ProjectManager.close_project(_get_tab_by_index(tab).project)


func _on_current_project_changed(project: Project):
	if project:
		current_tab = _get_tab_by_project(project).index


func _on_project_added(project: Project):
	var tab = Tab.new(project, tab_count)
	add_tab(project.title + "(*)")
	tabs += [tab]
	ProjectManager.current_project = project


func _on_project_removed(project: Project):
	var tab = _get_tab_by_project(project)
	tabs.erase(tab)
	remove_tab(tab.index)
	for t in tabs:
		if t.index > tab.index:
			t.index -= 1


func _get_tab_by_index(index: int) -> Tab:
	for tab in tabs:
		if tab.index == index:
			return tab
	return null


func _get_tab_by_project(project: Project) -> Tab:
	for tab in tabs:
		if tab.project == project:
			return tab
	return null


class Tab:
	var project: Project
	var index: int
	
	
	@warning_ignore('shadowed_variable')
	func _init(project: Project, index: int):
		self.project = project
		self.index = index
