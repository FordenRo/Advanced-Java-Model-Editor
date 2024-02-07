class_name Display

var firstperson_righthand: DisplayProperty = DisplayProperty.new()
var firstperson_lefthand: DisplayProperty = DisplayProperty.new()
var thirdperson_righthand: DisplayProperty = DisplayProperty.new()
var thirdperson_lefthand: DisplayProperty = DisplayProperty.new()
var ground: DisplayProperty = DisplayProperty.new()
var head: DisplayProperty = DisplayProperty.new()


static func from_json(json: Dictionary) -> Display:
	var display = Display.new()
	for property in json:
		display.set(property, DisplayProperty.from_json(json[property]))
	return display


func to_json() -> Dictionary:
	var json = {}
	for property in get_property_list():
		var name = property.name
		var display_property = get(name)
		if display_property is DisplayProperty:
			if not display_property.is_default():
				json[name] = display_property.to_json()
	return json
