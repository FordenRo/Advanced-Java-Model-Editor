extends HBoxContainer

class_name DisplaySettingSlider


signal value_changed
signal add_keyframe

@onready var slider := $HSlider
@onready var edit := $LineEdit
@onready var add_keyframe_button := $AddKeyframe

@export var value := 0.0 :
	set(val):
		if edit:
			edit.text = str(val)
		if slider:
			slider.value = val
		value = val
@export var max_value := 100.0
@export var min_value := 0.0

@export_category("Slider")
@export var slider_max_value := 100.0 :
	set(value):
		slider_max_value = value
		if slider:
			slider.max_value = value
@export var slider_min_value := 0.0 :
	set(value):
		slider_min_value = value
		if slider:
			slider.min_value = value
@export var step := 1.0 :
	set(value):
		step = value
		if slider:
			slider.step = value


var slider_timer: Timer


func _ready():
	slider.max_value = slider_max_value
	slider.min_value = slider_min_value
	slider.value = value
	slider.step = step
	
	add_keyframe_button.pressed.connect(func(): add_keyframe.emit())
	ProjectManager.current_project_changed.connect(_on_current_project_changed)
	ProjectManager.animation_window.visibility_changed.connect(_on_animation_window_visibility_changed)
	
	slider.drag_started.connect(_slider_drag_started)
	slider.drag_ended.connect(_slider_drag_ended)
	edit.text_submitted.connect(_edit_text_changed)
	
	slider_timer = Timer.new()
	slider_timer.timeout.connect(_slider_timer_timeout)
	slider_timer.wait_time = 1.0 / 60
	add_child(slider_timer)


func _on_animation_window_visibility_changed():
	add_keyframe_button.visible = ProjectManager.animation_window.visible


func _on_current_project_changed(project: Project):
	if ProjectManager.current_project:
		ProjectManager.current_project.current_animation_changed.disconnect(_on_current_animation_changed)
	if project:
		project.current_animation_changed.connect(_on_current_animation_changed)
		_on_current_animation_changed(project.current_animation)


func _on_current_animation_changed(animation: String):
	add_keyframe_button.disabled = animation.is_empty()


func _slider_timer_timeout():
	value = slider.value
	value_changed.emit()


func _slider_drag_started():
	slider_timer.start()


func _slider_drag_ended(_b: bool):
	slider_timer.stop()
	value = slider.value
	value_changed.emit()


func _edit_text_changed(text: String):
	if not text.is_valid_float():
		edit.text = str(value)
		return
	value = minf(maxf(text.to_float(), min_value), max_value)
	value_changed.emit()
