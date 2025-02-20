class_name ObjectMethodsList extends Control
## Docstring

#region Signals
## TODO
signal method_selected(object : Object, method : Dictionary)
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Static Variables
#endregion Static Variables

#region Exports Variables
#endregion Exports Variables

#region Public Variables
## TODO
var object : Object = null:
	set(new_object):
		object = new_object
		if is_inside_tree():
			_update()
## TODO
var hide_const_methods : bool = true:
	set(new_hide_const_methods):
		hide_const_methods = new_hide_const_methods
		if is_inside_tree():
			_update()
## TODO
var hide_virtual_methods : bool = true:
	set(new_hide_virtual_methods):
		hide_virtual_methods = new_hide_virtual_methods
		if is_inside_tree():
			_update()
## TODO
var hide_vararg_methods : bool = true:
	set(new_hide_vararg_methods):
		hide_vararg_methods = new_hide_vararg_methods
		if is_inside_tree():
			_update()
## TODO
var hide_static_methods : bool = true:
	set(new_hide_static_methods):
		hide_static_methods = new_hide_static_methods
		if is_inside_tree():
			_update()
## TODO
var hide_object_core_methods : bool = true:
	set(new_hide_object_core_methods):
		hide_object_core_methods = new_hide_object_core_methods
		if is_inside_tree():
			_update()
## TODO
var hide_private_methods : bool = true:
	set(new_hide_private_methods):
		hide_private_methods = new_hide_private_methods
		if is_inside_tree():
			_update()
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _no_object_label_container : MarginContainer = %NoObjectLabelContainer
@onready var _object_methods_list : Tree = %ObjectMethodsList
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_initialize()
	_update()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_method_item_activated() -> void:
	var method_item : TreeItem = _object_methods_list.get_selected()
	var method : Dictionary = method_item.get_metadata(0)
	method_selected.emit(object, method)
#endregion Callbacks
func _initialize() -> void:
	_object_methods_list.columns = 1
	_object_methods_list.select_mode = Tree.SELECT_ROW
	_object_methods_list.hide_root = true
	_object_methods_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_object_methods_list.item_activated.connect(_on_method_item_activated)

func _update() -> void:
	if not object:
		_object_methods_list.hide()
		_no_object_label_container.show()
	else:
		_no_object_label_container.hide()
		_object_methods_list.show()
		_update_methods_list()

func _update_methods_list() -> void:
	_object_methods_list.clear()
	
	var root : TreeItem = _object_methods_list.create_item();
	
	var native_base : String = object.get_class()
	var script_base : Script = object.get_script()
	
	while native_base != "":
		var class_name_ : String
		var class_icon : Texture2D
		var class_methods : Array[Dictionary]
		
		if script_base:
			class_name_ = script_base.get_global_name()
			if (class_name_.is_empty()):
				class_name_ = script_base.get_path().get_file()
			
			if DebugManager.has_editor_class_icon(native_base):
				class_icon = DebugManager.get_editor_class_icon(native_base)
			
			class_methods = DebugManager.get_script_method_list(script_base, true)
			
			script_base = script_base.get_base_script()
		else:
			class_name_ = native_base
			
			if DebugManager.has_editor_class_icon(native_base):
				class_icon = DebugManager.get_editor_class_icon(native_base)
			
			class_methods = DebugManager.get_class_method_list(native_base, true, object)
			
			native_base = DebugManager.get_parent_class(native_base)
		
		if not class_icon:
			class_icon = DebugManager.get_editor_class_icon("Object")
		
		var section_item : TreeItem
		
		if not class_methods.is_empty():
			section_item = _object_methods_list.create_item(root)
			section_item.set_text(0, class_name_)
			section_item.set_icon(0, class_icon)
			section_item.set_selectable(0, false)
			section_item.set_editable(0, false)
			section_item.set_custom_bg_color(0, Color.BLACK)
		for method : Dictionary in class_methods:
			var method_name : String = method["name"]
		
			if not _is_valid_method(method):
				continue
			
			var method_item : TreeItem = _object_methods_list.create_item(section_item)
			method_item.set_text(0, DebugManager.get_method_signature(method))
			method_item.set_icon(0, DebugManager.get_editor_class_icon("MemberMethod"))
			method_item.set_metadata(0, method)
	
	_object_methods_list.show()

func _is_valid_method(method : Dictionary) -> bool:
	var method_name : String = method["name"]
	var method_flags : MethodFlags = method["flags"]
	
	if method_flags & METHOD_FLAG_EDITOR:
		pass
	if method_flags & METHOD_FLAG_CONST:
		if hide_const_methods: return false
	if method_flags & METHOD_FLAG_VIRTUAL:
		if hide_virtual_methods: return false
	if method_flags & METHOD_FLAG_VARARG:
		if hide_vararg_methods: return false
	if method_flags & METHOD_FLAG_STATIC:
		if hide_static_methods: return false
	if method_flags & METHOD_FLAG_OBJECT_CORE:
		if hide_object_core_methods: return false
	if method_name[0] == "_":
		if hide_private_methods: return false
	return true
#endregion Private Methods
