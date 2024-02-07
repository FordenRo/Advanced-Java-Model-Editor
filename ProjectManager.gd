extends Node
## Manages projects


## Emits when the current project has been changed
signal current_project_changed(project: Project)
## Emits when a new project is created or opened
signal project_added(project: Project)
## Emits when the project is closed or deleted
signal project_removed(project: Project)
## Emits when mode is changed
signal mode_changed

enum Mode {
	Edit,
	Display
}

var mode: Mode = Mode.Edit :
	set(value):
		mode = value
		mode_changed.emit()
var node3D: Node3D
## Opened projects
var projects: Array[Project] = []
## Current Project
var current_project: Project :
	set(value):
		if current_project and current_project != value:
			current_project.hide()
		if value:
			value.show()
		current_project_changed.emit(value)
		current_project = value
var animation_window: Control


## Add new project
func add_project(project: Project):
	projects += [project]
	add_child(project)
	project_added.emit(project)


## Close existing project
func close_project(project: Project):
	projects.erase(project)
	project.queue_free()
	project_removed.emit(project)
	current_project = projects[0] if projects.size() > 0 else null
