extends Node3D

class_name JavaModel


signal element_changed(idx: int)

var elements = []
var display: Display
var textures = {}
var gui_light: String
var groups: Array


@warning_ignore('shadowed_variable')
func _init(display: Display = Display.new()):
	self.display = display
	name = "JavaModel"
	
	display.firstperson_righthand.changed.connect(_on_display_changed)
	ProjectManager.mode_changed.connect(_on_project_mode_changed)


func _on_display_changed():
	if ProjectManager.mode == ProjectManager.Mode.Display:
		update_display()


func _on_project_mode_changed():
	if ProjectManager.mode == ProjectManager.Mode.Display:
		update_display()
	else:
		reset_display()


func add_element(element: Element) -> int:
	elements += [element]
	add_child(element)
	element.changed.connect(func(): element_changed.emit(elements.find(element)))
	element.tree_exiting.connect(func(): elements.erase(element))
	return elements.find(element)


func update_display():
	rotation_degrees = display.firstperson_righthand.rotation
	rotation.x = 0
	rotate(Vector3.RIGHT, deg_to_rad(display.firstperson_righthand.rotation.x))
	position = display.firstperson_righthand.translation
	scale = display.firstperson_righthand.scale


func reset_display():
	rotation_degrees = Vector3.ZERO
	position = Vector3.ZERO
	scale = Vector3.ONE


@warning_ignore('shadowed_variable')
static func from_json(json) -> JavaModel:
	var display = Display.new()
	if 'display' in json:
		display = Display.from_json(json.display)
		
	var model = JavaModel.new(display)
	if 'textures' in json:
		model.textures = json.textures
	if 'gui_light' in json:
		model.gui_light = json.gui_light
	if 'groups' in json:
		model.groups = json.groups
		
	for json_element in json.elements:
		var element = Element.from_json(json_element)
		model.add_element(element)
		
	return model


func to_json() -> Dictionary:
	var json = {}
	json.credits = "Advanced Java Model Editor"
	json.elements = []
	for element in elements:
		json.elements += [element.to_json()]
	if gui_light:
		json.gui_light = gui_light
	json.display = display.to_json()
	if groups:
		json.groups = groups
	return json
