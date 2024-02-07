class_name DisplayProperty


signal changed

var translation: Vector3 :
	set(value):
		translation = value
		changed.emit()
var rotation: Vector3 :
	set(value):
		rotation = value
		changed.emit()
var scale: Vector3 :
	set(value):
		scale = value
		changed.emit()


@warning_ignore('shadowed_variable')
func _init(translation: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, scale: Vector3 = Vector3.ONE):
	self.translation = translation
	self.rotation = rotation
	self.scale = scale


@warning_ignore('shadowed_variable')
static func from_json(json) -> DisplayProperty:
	var translation = Vector3.ZERO
	var rotation = Vector3.ZERO
	var scale = Vector3.ONE
	
	if 'translation' in json:
		translation = Vector3(
			json.translation[0],
			json.translation[1] - 10,
			json.translation[2]
		)
	if 'rotation' in json:
		rotation = Vector3(
			json.rotation[0],
			json.rotation[1],
			json.rotation[2]
		)
	if 'scale' in json:
		scale = Vector3(
			json.scale[0],
			json.scale[1],
			json.scale[2]
		)
		
	var display = DisplayProperty.new(translation, rotation, scale)
	return display


func _vector3_to_array(vector: Vector3) -> Array[float]:
	return [vector.x, vector.y, vector.z]


func is_default() -> bool:
	return translation == Vector3.ZERO and rotation == Vector3.ZERO and scale == Vector3.ONE


func to_json() -> Dictionary:
	var json = {}
	if translation != Vector3.ZERO:
		json.translation = _vector3_to_array(translation)
	if rotation != Vector3.ZERO:
		json.rotation = _vector3_to_array(rotation)
	if scale != Vector3.ONE:
		json.scale = _vector3_to_array(scale)
	return json
