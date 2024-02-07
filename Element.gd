extends Node3D

class_name Element


signal changed

## Point from
var from: Vector3 :
	set(value):
		from = value
		if mesh:
			mesh.position = value
## Point to
var to: Vector3 :
	set(value):
		to = value
		if mesh:
			mesh.mesh.size = value - from
## Faces
var faces: Dictionary = {
	north = {uv = [0, 0, 0, 0], texture = "#missing"},
	east = {uv = [0, 0, 0, 0], texture = "#missing"},
	south = {uv = [0, 0, 0, 0], texture = "#missing"},
	west = {uv = [0, 0, 0, 0], texture = "#missing"},
	up = {uv = [0, 0, 0, 0], texture = "#missing"},
	down = {uv = [0, 0, 0, 0], texture = "#missing"},
}
var element_rotation: Dictionary
## Size
var size: Vector3 :
	set(value):
		to = from + value
	get:
		return to - from
## Title
var title := "cube" :
	set(value):
		title = value
		changed.emit()
## Mesh
var mesh: MeshInstance3D :
	set(value):
		if not value:
			mesh.queue_free()
		mesh = value


@warning_ignore('shadowed_variable')
func _init(from: Vector3, to: Vector3):
	self.from = from
	self.to = to
	
	var s_from = from - Vector3(7.5, 7.5, 7.5)
	mesh = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = size
	mesh.mesh = box_mesh
	mesh.position = s_from + size / 2
	add_child(mesh)


func _vector3_to_array(vector: Vector3) -> Array[float]:
	return [vector.x, vector.y, vector.z]


@warning_ignore('shadowed_variable')
static func from_json(json: Dictionary) -> Element:
	var from = Vector3(json.from[0], json.from[1], json.from[2])
	var to = Vector3(json.to[0], json.to[1], json.to[2])
	
	var element = Element.new(from, to)
	if 'name' in json:
		element.title = json.name
	if 'faces' in json:
		element.faces = json.faces
	else:
		element.faces = {}
	if 'rotation' in json:
		element.element_rotation = json.rotation
	return element


func to_json() -> Dictionary:
	var json = {}
	json.from = _vector3_to_array(from)
	json.to = _vector3_to_array(to)
	json.name = title
	json.faces = faces
	if element_rotation:
		json.rotation = element_rotation
	return json
