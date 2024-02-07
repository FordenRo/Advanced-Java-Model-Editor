extends Node3D

class_name Project


signal current_animation_changed(animation: String)
signal animation_process

## Project title
var title: String
## The path of the project file
var file_path: String
## Project elements
var model: JavaModel
## Selected animation
var current_animation: String :
	set(value):
		current_animation_changed.emit(value)
		animation_player.assigned_animation = "library/" + value
		animation_player.current_animation = "library/" + value
		current_animation = value
## Animation player
var animation_player: AnimationPlayer
## Animation library
var animation_library: AnimationLibrary
## Animation Timer
var animation_timer: Timer
var animation_position: int:
	set(value):
		animation_player.advance(value - animation_position)
	get:
		if not current_animation:
			return 0
		return int(animation_player.current_animation_position)
var animation_framerate := 20


@warning_ignore('shadowed_variable')
func _init(model: JavaModel):
	animation_timer = Timer.new()
	animation_timer.timeout.connect(_animation_timer_timeout)
	add_child(animation_timer)
	
	animation_player = AnimationPlayer.new()
	animation_player.set_process_callback(AnimationPlayer.ANIMATION_PROCESS_MANUAL)
	animation_library = AnimationLibrary.new()
	animation_player.add_animation_library("library", animation_library)
	add_child(animation_player)
	self.model = model
	add_child(model)


static func from_json(json) -> Project:
	var project = Project.new(JavaModel.from_json(json.model))
	project.animation_library = str_to_var(json.animation_library)
	project.animation_player.remove_animation_library("library")
	project.animation_player.add_animation_library("library", project.animation_library)
	project.current_animation = json.current_animation
	return project


func to_json() -> Dictionary:
	var json = {}
	json.model = model.to_json()
	json.animation_library = var_to_str(animation_library)
	json.current_animation = current_animation
	return json


@warning_ignore('shadowed_variable_base_class')
func create_animation(name: String) -> Animation:
	var animation = Animation.new()
	animation_library.add_animation(name, animation)
	animation.length = 20
	current_animation = name
	return animation


func _animation_timer_timeout():
	animation_player.advance(1.0)
	animation_process.emit()
	if animation_player.current_animation_position == animation_player.current_animation_length:
		animation_timer.stop()


func play_animation():
	animation_timer.wait_time = 1.0 / animation_framerate
	animation_timer.start()
