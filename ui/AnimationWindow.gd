extends VBoxContainer


#region components
@onready var animation_tree: Tree = $AnimationPanelContainer/HSplitContainer/PanelContainer/ScrollContainer/AnimationTree
@onready var key_tree: Tree = $AnimationPanelContainer/HSplitContainer/ScrollContainer/AnimationKeyTree
@onready var play_button := $HBoxContainer/Play
@onready var current_frame_edit := $HBoxContainer/CurrentFrame
@onready var animation_menu_button := $HBoxContainer/AnimationMenuButton
@onready var current_animation_option_button := $HBoxContainer/CurrentAnimation
@onready var framerate_edit := $HBoxContainer/Framerate
@onready var frame_before := $HBoxContainer/FrameBefore
@onready var frame_after := $HBoxContainer/FrameAfter
@onready var length_edit := $HBoxContainer/Length
@onready var key_popup_menu: PopupMenu = key_tree.get_node('KeyPopupMenu')
#endregion

var keyframe_icon := preload('res://Keyframe.png')
var animation_tree_scrolling = false
var key_tree_scrolling = false
var last_selected_keyframe: Keyframe
var selected_keyframes = []
var keyframes = []

enum KeyPopupMenu {
	DELETE
}


func _init():
	ProjectManager.animation_window = self


func _ready():
	hide()
#region signals
	ProjectManager.current_project_changed.connect(_on_current_project_changed)
	play_button.pressed.connect(_on_play_pressed)
	current_animation_option_button.item_selected.connect(_on_current_animation_option_selected)
	current_frame_edit.text_submitted.connect(_on_current_frame_edit_submitted)
	framerate_edit.text_submitted.connect(_on_framerate_edit_submitted)
	frame_before.pressed.connect(_on_frame_before_pressed)
	frame_after.pressed.connect(_on_frame_after_pressed)
	length_edit.text_submitted.connect(_on_length_text_submitted)
	
	key_tree.column_title_clicked.connect(_on_column_title_clicked)
	key_tree.gui_input.connect(_on_key_tree_gui_input)
	key_tree.item_mouse_selected.connect(_on_key_mouse_clicked)
	key_popup_menu.id_pressed.connect(_on_key_popup_menu_id_pressed)
#endregion
	
	animation_tree.set_column_title(0, "Track")

#region panel buttons
func _on_frame_before_pressed():
	ProjectManager.current_project.animation_position -= 1
	current_frame_edit.text = str(ProjectManager.current_project.animation_position)


func _on_frame_after_pressed():
	ProjectManager.current_project.animation_position += 1
	current_frame_edit.text = str(ProjectManager.current_project.animation_position)


func _on_framerate_edit_submitted(text: String):
	if not text.is_valid_int():
		framerate_edit.text = str(ProjectManager.current_project.animation_framerate)
		return
		
	var fps = mini(maxi(text.to_int(), 3), 20)
	ProjectManager.current_project.animation_framerate = fps


func _on_current_frame_edit_submitted(text: String):
	if not text.is_valid_int():
		current_frame_edit.text = str(ProjectManager.current_project.animation_position)
		return
		
	var pos = mini(maxi(text.to_int(), 0), int(ProjectManager.current_project.animation_library.get_animation(ProjectManager.current_project.current_animation).length))
	ProjectManager.current_project.animation_position = pos
	current_frame_edit.text = str(pos)


func _on_length_text_submitted(text: String):
	var animation = ProjectManager.current_project.animation_library.get_animation(ProjectManager.current_project.current_animation)
	if not text.is_valid_int():
		length_edit.text = str(animation.length)
		return
	
	animation.length = maxi(text.to_int(), 3)
	length_edit.text = str(int(animation.length))

	
func _on_play_pressed():
	if ProjectManager.current_project and ProjectManager.current_project.current_animation:
		ProjectManager.current_project.animation_position = 0
		ProjectManager.current_project.play_animation()
#endregion

func _on_key_popup_menu_id_pressed(id: int):
	if id == KeyPopupMenu.DELETE:
		var animation = ProjectManager.current_project.animation_library.get_animation(ProjectManager.current_project.current_animation)
		var tracks_to_remove = []
		for keyframe in selected_keyframes:
			if animation.track_get_key_count(keyframe.track_idx) == 1:
				tracks_to_remove += [keyframe.track_idx]
			else:
				animation.track_remove_key(keyframe.track_idx, keyframe.key_idx)
		tracks_to_remove.sort_custom(func(a, b): return a > b)
		for track_idx in tracks_to_remove:
			animation.remove_track(track_idx)
		selected_keyframes.clear()



@warning_ignore('shadowed_variable_base_class')
func _on_key_mouse_clicked(position: Vector2, button_index: int):
	var item = key_tree.get_item_at_position(position)
	var column = key_tree.get_column_at_position(position)
	var keyframe = get_keyframe(item.get_index(), column)
	if button_index == 1:
		if Input.is_key_pressed(KEY_SHIFT):
			if keyframe:
				if keyframe in selected_keyframes:
					selected_keyframes.erase(keyframe)
					item.set_icon_modulate(column, Color.WHITE)
				else:
					selected_keyframes += [keyframe]
					item.set_icon_modulate(column, Color.DARK_SEA_GREEN)
				print(str(item.get_index()) + " " + str(column) + " " + ("true" if keyframe in selected_keyframes else "false"))
		else:
			#if last_selected_keyframe:
				#key_tree.get_root().get_child(last_selected_keyframe.index).set_icon_modulate(last_selected_keyframe.time, Color.WHITE)
				#last_selected_keyframe = null
			if not selected_keyframes.is_empty():
				for selected_keyframe in selected_keyframes:
					var selected_item = key_tree.get_root().get_children()[selected_keyframe.index]
					selected_item.set_icon_modulate(selected_keyframe.time, Color.WHITE)
				selected_keyframes.clear()
			
			ProjectManager.current_project.animation_position = key_tree.get_selected_column()
			current_frame_edit.text = str(key_tree.get_selected_column())
			
			if keyframe:
				item.set_icon_modulate(column, Color.DARK_SEA_GREEN)
				#last_selected_keyframe = keyframe
				selected_keyframes += [keyframe]
	elif button_index == 2:
		if keyframe:
			if selected_keyframes.is_empty():
				selected_keyframes += [keyframe]
				item.set_icon_modulate(column, Color.DARK_SEA_GREEN)
			key_popup_menu.position = get_tree().root.get_mouse_position()
			key_popup_menu.show()


func _on_column_title_clicked(column: int, button_index: int):
	if not ProjectManager.current_project:
		return
		
	if button_index == MOUSE_BUTTON_LEFT:
		ProjectManager.current_project.animation_position = column
		current_frame_edit.text = str(column)


func _on_current_project_changed(project: Project):
	current_animation_option_button.clear()
	
	if ProjectManager.current_project:
		ProjectManager.current_project.current_animation_changed.disconnect(_on_current_animation_changed)
		ProjectManager.current_project.animation_process.disconnect(_animation_process)
		ProjectManager.current_project.animation_library.animation_added.disconnect(_animation_added)
	if project:
		for animation_name in project.animation_library.get_animation_list():
			current_animation_option_button.add_item(animation_name)
		
		framerate_edit.text = str(project.animation_framerate)
		project.animation_library.animation_added.connect(_animation_added)
		project.current_animation_changed.connect(_on_current_animation_changed)
		project.animation_process.connect(_animation_process)
		_on_current_animation_changed(project.current_animation, project)


#region animation signals
@warning_ignore('shadowed_variable_base_class')
func _animation_added(name: String):
	current_animation_option_button.add_item(name)


func _on_current_animation_changed(animation: String, project: Project = ProjectManager.current_project):
	if ProjectManager.current_project and ProjectManager.current_project.current_animation:
		ProjectManager.current_project.animation_library.get_animation(ProjectManager.current_project.current_animation).changed.disconnect(_on_animation_changed)
	
	current_frame_edit.editable = not animation.is_empty()
	current_animation_option_button.disabled = animation.is_empty()
	play_button.disabled = animation.is_empty()
	frame_before.disabled = animation.is_empty()
	frame_after.disabled = animation.is_empty()
	length_edit.editable = not animation.is_empty()
	
	if animation.is_empty():
		animation_tree.clear()
		key_tree.clear()
		return
	
	var animation_instance = project.animation_library.get_animation(animation)
	if animation_instance:
		current_animation_option_button.select(project.animation_library.get_animation_list().find(animation))
		_on_animation_changed(animation, project)
		animation_instance.changed.connect(_on_animation_changed)


func _on_current_animation_option_selected(id: int):
	ProjectManager.current_project.current_animation = ProjectManager.current_project.animation_library.get_animation_list()[id]


@warning_ignore('shadowed_variable')
func _animation_process():
	current_frame_edit.text = str(ProjectManager.current_project.animation_position)


@warning_ignore('shadowed_variable_base_class')
func _on_animation_changed(name: String = ProjectManager.current_project.current_animation, project: Project = ProjectManager.current_project):
	animation_tree.clear()
	key_tree.clear()
	keyframes.clear()
	
	animation_tree.create_item()
	key_tree.create_item()
	
	var animation = project.animation_library.get_animation(name)
	key_tree.columns = int(animation.length) + 1
	for column in key_tree.columns:
		key_tree.set_column_title(column, str(column))
		key_tree.set_column_title_alignment(column, HORIZONTAL_ALIGNMENT_CENTER)
		key_tree.set_column_custom_minimum_width(column, 30)
		key_tree.set_column_clip_content(column, true)
		
	for track_idx in range(animation.get_track_count()):
		var path = animation.track_get_path(track_idx)
		if not path:
			continue
			
		var animation_parent = animation_tree.get_root()
		var key_parent: TreeItem = key_tree.get_root()
		var key_item: TreeItem = key_parent.get_first_child()
		
		for subchild in path.get_concatenated_subnames().split(":"):
			var animation_item = animation_parent.get_first_child()
			key_item = key_parent.get_first_child()
			var exists = false
			
			while animation_item:
				if animation_item.get_text(0) == subchild:
					exists = true
					break
				animation_item = animation_item.get_next()
				key_item = key_item.get_next()
			if exists:
				animation_parent = animation_item
				#key_parent = key_item
				continue
			else:
				animation_parent = animation_tree.create_item(animation_parent)
				animation_parent.set_text(0, subchild)
				key_item = key_tree.create_item(key_parent)
				
		for key_idx in range(animation.track_get_key_count(track_idx)):
			var time = int(animation.track_get_key_time(track_idx, key_idx))
			keyframes += [Keyframe.new(key_item.get_index(), time, track_idx, key_idx)]
			key_item.set_icon(time, keyframe_icon)
			key_item.set_text_alignment(time, HORIZONTAL_ALIGNMENT_CENTER)
			
	for keyframe in selected_keyframes:
		key_tree.get_root().get_children()[keyframe.index].set_icon_modulate(keyframe.time, Color.DARK_SEA_GREEN)
#endregion


var _clicked_column
func _on_key_tree_gui_input(event):
	if selected_keyframes.is_empty():
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_clicked_column = key_tree.get_column_at_position(event.position)
				print(_clicked_column)
			else:
				_clicked_column = null
	if event is InputEventMouseMotion:
		if _clicked_column == null:
			return
			
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var column = key_tree.get_column_at_position(event.position)
			if _clicked_column != column:
				var animation = ProjectManager.current_project.animation_library.get_animation(ProjectManager.current_project.current_animation)
				for keyframe in selected_keyframes:
					keyframe.time += column - _clicked_column
					animation.track_set_key_time(keyframe.track_idx, keyframe.key_idx, keyframe.time)
				_on_animation_changed()
				_clicked_column = column

func get_keyframe(index: int, column: int) -> Keyframe:
	for keyframe in keyframes:
		if keyframe.index == index and keyframe.time == column:
			return keyframe
	return null


class Keyframe:
	var index: int
	var time: int
	var track_idx: int
	var key_idx: int
	
	
	func _init(index: int, time: int, track_idx: int, key_idx: int):
		self.index = index
		self.time = time
		self.track_idx = track_idx
		self.key_idx = key_idx
