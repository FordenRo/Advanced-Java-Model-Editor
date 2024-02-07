extends VBoxContainer


#region axis vars
@onready var x:
	set(value):
		$X.value = value
	get:
		return $X.value
@onready var y:
	set(value):
		$Y.value = value
	get:
		return $Y.value
@onready var z:
	set(value):
		$Z.value = value
	get:
		return $Z.value
#endregion
@onready var value: Vector3 :
	set(v):
		x = v.x
		y = v.y
		z = v.z
	get:
		return Vector3(x, y, z)


func _ready():
#region value_changed signals
	$X.value_changed.connect(func():
		if not ProjectManager.current_project:
			return
		
		ProjectManager.current_project.model.display.firstperson_righthand.translation.x = x
	)
	$Y.value_changed.connect(func():
		if not ProjectManager.current_project:
			return
		
		ProjectManager.current_project.model.display.firstperson_righthand.translation.y = y
	)
	$Z.value_changed.connect(func():
		if not ProjectManager.current_project:
			return
		
		ProjectManager.current_project.model.display.firstperson_righthand.translation.z = z
	)
#endregion
#region add_keyframe signals
	$X.add_keyframe.connect(func():
		_add_keyframe('x')
	)
	$Y.add_keyframe.connect(func():
		_add_keyframe('y')
	)
	$Z.add_keyframe.connect(func():
		_add_keyframe('z')
	)
#endregion


@warning_ignore('shadowed_variable')
func _add_keyframe(axis: String):
	var project: Project = ProjectManager.current_project
		
	if not project or not ProjectManager.current_project.current_animation:
		return
	
	var animation: Animation = project.animation_library.get_animation(project.current_animation)
	var path = NodePath(project.get_path_to(project.model).get_concatenated_names() + ":display:firstperson_righthand:translation:" + axis)
	var track = animation.find_track(path, Animation.TYPE_VALUE)
	if track == -1:
		track = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(track, path)
	
	var display = project.model.display.firstperson_righthand
	var value
	match axis:
		'x':
			value = display.translation.x
		'y':
			value = display.translation.y
		'z':
			value = display.translation.z
	
	animation.track_insert_key(track, project.animation_position, value)
