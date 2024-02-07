extends SubViewportContainer


const SPEED = 10.0
const SHIFT = 25.0

@onready var camera := $SubViewport/Camera3D


func _process(delta):
	if not get_viewport().gui_get_focus_owner() == self:
		return
		
	var speed = SHIFT if Input.is_action_pressed('move_faster') else SPEED
	var input_dir = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_back')
	var direction = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		camera.position += direction * speed * delta
		
	var input_axis = Input.get_axis('move_down', 'move_up')
	if input_axis:
		camera.position += (camera.transform.basis * Vector3(0, input_axis, 0)).normalized() * speed * delta


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE
			grab_focus()
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			camera.rotate(Vector3.DOWN, event.relative.x * 0.001)
			camera.rotate_object_local(Vector3.LEFT, event.relative.y * 0.001)
