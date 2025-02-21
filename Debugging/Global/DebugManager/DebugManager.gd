extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#region Meta Names
const META_PREFIX : String = "gdbugger_"
const NODE_SCENE_TREE_ITEM : String = META_PREFIX + "tree_item" 
#endregion Meta Names
#endregion Constants

#region Exports Variables
## TODO
@export var minimal_menu_enabled : bool = true
## TODO
@export var log_interface_enabled : bool = true
## TODO
@export var minimal_menu_scene : PackedScene = null
## TODO
@export var log_interface_scene : PackedScene = null
## TODO
@export var editor_theme : Theme = null
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	if minimal_menu_enabled and minimal_menu_scene:
		var minimal_menu : MinimalMenuComponent = minimal_menu_scene.instantiate()
		add_child(minimal_menu)
	if log_interface_enabled and log_interface_scene:
		var log_interface := log_interface_scene.instantiate()
		add_child(log_interface)
#endregion Built-in Virtual Methods

#region Public Methods
#region Editor Theme
## TODO
func get_editor_theme() -> Theme:
	return editor_theme	
## TODO
func get_editor_main_font() -> Font:
	return editor_theme.get_font("main", "EditorFonts")
## TODO
func get_editor_output_source_font() -> Font:
	return editor_theme.get_font("output_source", "EditorFonts")
## TODO
func get_editor_output_source_font_size() -> int:
	return editor_theme.get_font_size("output_source_size", "EditorFonts")
## TODO
func has_editor_class_icon(class_name_ : String) -> bool:
	return editor_theme.has_icon(class_name_, "EditorIcons")
## TODO
func get_editor_class_icon(class_name_ : String) -> Texture2D:
	if editor_theme.has_icon(class_name_, "EditorIcons"):
		return editor_theme.get_icon(class_name_, "EditorIcons")
	return editor_theme.get_icon("Object", "EditorIcons")
#endregion Editor Theme
#region Classes and Scripts
## TODO
func get_parent_class(class_name_ : String) -> String:
	return ClassDB.get_parent_class(class_name_)
## TODO
func get_class_method_list(class_name_ : String, no_inheritance : bool = false, class_object : Object = null) -> Array[Dictionary]:
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
func get_script_method_list(script : Script, no_script_inheritance : bool = false) -> Array[Dictionary]:
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
func get_method_signature(method : Dictionary) -> String:
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
#endregion Public Methods

#region Private Methods
#endregion Private Methods
