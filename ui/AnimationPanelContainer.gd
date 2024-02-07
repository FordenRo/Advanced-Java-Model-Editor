extends PanelContainer


@onready var animation_tree_scroll := $HSplitContainer/PanelContainer/ScrollContainer
@onready var key_tree_scroll := $HSplitContainer/ScrollContainer


func _ready():
	animation_tree_scroll.get_v_scroll_bar().scrolling.connect(_on_animation_tree_scrolling)
	key_tree_scroll.get_v_scroll_bar().scrolling.connect(_on_key_tree_scrolling)
	
	key_tree_scroll.gui_input.connect(_on_key_tree_gui_input)
	animation_tree_scroll.gui_input.connect(_on_animation_tree_gui_input)


func _on_animation_tree_scrolling():
	key_tree_scroll.scroll_vertical = animation_tree_scroll.scroll_vertical


func _on_key_tree_scrolling():
	animation_tree_scroll.scroll_vertical = key_tree_scroll.scroll_vertical


func _on_animation_tree_gui_input(input):
	if input is InputEventMouseButton:
		if input.button_index == MOUSE_BUTTON_WHEEL_DOWN or input.button_index == MOUSE_BUTTON_WHEEL_UP:
			_on_animation_tree_scrolling()


func _on_key_tree_gui_input(input):
	if input is InputEventMouseButton:
		if input.button_index == MOUSE_BUTTON_WHEEL_DOWN or input.button_index == MOUSE_BUTTON_WHEEL_UP:
			_on_key_tree_scrolling()
