class_name DebugUtil
## Docstring

#region Enums
#endregion Enums

#region Constants
## TODO
const EDITOR_THEME_PATH = "res://Debugging/Global/DebugManager/EditorTheme.tres"

#region Nodes Meta
## TODO
const META_PREFIX : String = "gdbugger_"
## TODO
const META_SCENE_TREE_LIST_ITEM : String = META_PREFIX + "scene_tree_list_item"
## TODO
const META_DEBUG_INTERFACES_LIST_ITEM : String = META_PREFIX + "debug_interfaces_list_item"
#endregion Nodes Meta

#endregion Constants

#region Public Static Methods
#region Classes and Scripts
## TODO
static func get_parent_class(class_name_ : String) -> String:
	return ClassDB.get_parent_class(class_name_)
## TODO
static func class_get_method_list(class_name_ : String, no_inheritance : bool = false, class_object : Object = null) -> Array[Dictionary]:
	if OS.is_debug_build():
		return ClassDB.class_get_method_list(class_name_, no_inheritance)
	else:
		var method_list : Array[Dictionary] = []
		var method_super_list : Array[Dictionary] = class_object.get_method_list()
		var method_only_name_list : Array[Dictionary] = ClassDB.class_get_method_list(class_name_, no_inheritance)
		
		for method : Dictionary in method_super_list:
			var is_class_method : bool = false
			for method_only_name : Dictionary in method_only_name_list:
				if method_only_name["name"] == method["name"]:
					is_class_method = true
					break
			if is_class_method:
				method_list.push_back(method)
		
		return method_list
## TODO
static func script_get_method_list(script : Script, no_script_inheritance : bool = false) -> Array[Dictionary]:
	var base_script : Script = script.get_base_script()
	
	if base_script and no_script_inheritance:
		var method_list : Array[Dictionary]
		var base_method_names : Dictionary = {}
		for base_method in base_script.get_script_method_list():
			base_method_names[base_method["name"]] = true
		for method in script.get_script_method_list():
			if not base_method_names.has(method["name"]):
				method_list.push_back(method)
		
		return method_list
	else:
		return script.get_script_method_list()
## TODO
static func get_method_signature(method : Dictionary) -> String:
	var signature : PackedStringArray
	
	signature.append(method["name"])
	signature.append("(")
	
	var arg_idx : int = 0
	for arg : Dictionary in method["args"]:
		if arg_idx != 0:
			signature.append(", ")
		
		var type_name : String
		match arg["type"]:
			TYPE_NIL:
				type_name = "Variant"
			TYPE_INT:
				if (arg["usage"] & PROPERTY_USAGE_CLASS_IS_ENUM) and arg["class_name"] != StringName() and not arg["class_name"].begins_with("res://"):
					type_name = arg["class_name"]
				else:
					type_name = "int"
			TYPE_ARRAY:
				if arg["hint"] == PROPERTY_HINT_ARRAY_TYPE and not arg["hint_string"].is_empty() and not arg["hint_string"].begins_with("res://"):
					type_name = "Array[" + arg["hint_string"] + "]"
				else:
					type_name = "Array"
			TYPE_OBJECT:
				if arg["class_name"] != StringName():
					type_name = arg["class_name"]
				else:
					type_name = "Object"
			_:
				type_name = type_string(arg["type"])
		
		var arg_name : String = arg["name"]
		if arg["name"].is_empty():
			arg_name = "arg" + str(arg_idx)
		
		signature.append(arg_name + ": " + type_name)
		
		arg_idx +=1
	
	signature.append(")")
	return String().join(signature)
#endregion Classes and Scripts
#region Editor Theme
## TODO
static func get_editor_theme() -> Theme:
	return load(EDITOR_THEME_PATH)
## TODO
static func get_editor_font(name : String, theme_type : String) -> Font:
	return get_editor_theme().get_font(name, theme_type)
## TODO
static func get_editor_font_size(name : String, theme_type : String) -> int:
	return get_editor_theme().get_font_size(name, theme_type)
## TODO
static func get_editor_icon(name : String, theme_type : String) -> Texture2D:
	return get_editor_theme().get_icon(name, theme_type)
## TODO
static func get_editor_stylebox(name : String, theme_type : String) -> StyleBox:
	return get_editor_theme().get_stylebox(name, theme_type)
## TODO
static func has_editor_icon(name : String, theme_type : String) -> bool:
	return get_editor_theme().has_icon(name, theme_type)
## TODO
static func has_editor_stylebox(name : String, theme_type : String) -> bool:
	return get_editor_theme().has_stylebox(name, theme_type)
#region Global Assets Types
## TODO
static func get_editor_main_font() -> Font:
	return get_editor_font("main", "EditorFonts")
## TODO
static func get_editor_output_source_font() -> Font:
	return get_editor_font("output_source", "EditorFonts")
## TODO
static func get_editor_output_source_font_size() -> int:
	return get_editor_font_size("output_source_size", "EditorFonts")
## TODO
static func has_editor_global_icon(icon_name : String) -> bool:
	return has_editor_icon(icon_name, "EditorIcons")
## TODO
static func get_editor_global_icon(icon_name : String) -> Texture2D:
	return get_editor_icon(icon_name, "EditorIcons")
#region Global Assets Types
#region Common Assets
## TODO
static func get_editor_darker_stylebox() -> StyleBox:
	return get_editor_stylebox("panel", "Tree")
#endregion Common Assets
#region Type Variations
## TODO
static func get_editor_light_button_variation() -> String:
	return "LightButton" # NOTE: In Godot source code they use InspectorActionButton
#endregion Type Variations
#endregion Editor Theme
#endregion Public Static Methods

#region Private Static Methods
#endregion Private Static Methods
