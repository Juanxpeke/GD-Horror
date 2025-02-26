class_name MethodsList extends VBoxContainer
## A list that shows the member methods of a given object.

#region Signals
## Emitted when a method from the list is activated. See [signal Tree.item_activated].
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
		update()
## TODO
var hide_const_methods : bool = true:
	set(new_hide_const_methods):
		hide_const_methods = new_hide_const_methods
		update()
## TODO
var hide_virtual_methods : bool = true:
	set(new_hide_virtual_methods):
		hide_virtual_methods = new_hide_virtual_methods
		update()
## TODO
var hide_vararg_methods : bool = true:
	set(new_hide_vararg_methods):
		hide_vararg_methods = new_hide_vararg_methods
		update()
## TODO
var hide_static_methods : bool = true:
	set(new_hide_static_methods):
		hide_static_methods = new_hide_static_methods
		update()
## TODO
var hide_object_core_methods : bool = true:
	set(new_hide_object_core_methods):
		hide_object_core_methods = new_hide_object_core_methods
		update()
## TODO
var hide_private_methods : bool = true:
	set(new_hide_private_methods):
		hide_private_methods = new_hide_private_methods
		update()
## TODO
var sort_methods_by_name : bool = true:
	set(new_sort_methods_by_name):
		sort_methods_by_name = new_sort_methods_by_name
		update()
#endregion Public Variables

#region Private Variables
var _no_data_container : MarginContainer
var _object_methods_list : Tree
var _object_methods_filters : HBoxContainer
var _hide_private_button : Button
var _sort_by_name_button : Button
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	theme = DebugUtil.get_editor_theme()
	
	_no_data_container = MarginContainer.new()
	_no_data_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_no_data_container.add_theme_constant_override(  "margin_left", 12)
	_no_data_container.add_theme_constant_override(   "margin_top", 12)
	_no_data_container.add_theme_constant_override( "margin_right", 12)
	_no_data_container.add_theme_constant_override("margin_bottom", 12)
	add_child(_no_data_container)
	
	var _no_data_label := Label.new()
	_no_data_label.text = "Press the 'Show Methods' option on a Node or Resource to see its methods."
	_no_data_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_no_data_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_no_data_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_no_data_container.add_child(_no_data_label)
	
	_object_methods_filters = HBoxContainer.new()
	add_child(_object_methods_filters)
	
	_hide_private_button = Button.new()
	_hide_private_button.toggle_mode = true
	_hide_private_button.tooltip_text = "Toggle Private Methods"
	_hide_private_button.toggled.connect(func(toggled_on): hide_private_methods = toggled_on)
	_object_methods_filters.add_child(_hide_private_button)
	
	_sort_by_name_button = Button.new()
	_sort_by_name_button.toggle_mode = true
	_sort_by_name_button.tooltip_text = "Toggle Sort By Name"
	_sort_by_name_button.toggled.connect(func(toggled_on): sort_methods_by_name = toggled_on)
	_object_methods_filters.add_child(_sort_by_name_button)
	
	_object_methods_list = Tree.new()
	_object_methods_list.columns = 1
	_object_methods_list.select_mode = Tree.SELECT_ROW
	_object_methods_list.hide_root = true
	_object_methods_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_object_methods_list.item_activated.connect(_on_method_item_activated)
	add_child(_object_methods_list)
	
	update()
#endregion Built-in Virtual Methods

#region Public Methods
## Updates this interface.
func update() -> void:
	if not is_instance_valid(object):
		_object_methods_filters.hide()
		_object_methods_list.hide()
		_no_data_container.show()
	else:
		_no_data_container.hide()
		_object_methods_filters.show()
		_object_methods_list.show()
		_update_methods_filters()
		_update_methods_list()
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_method_item_activated() -> void:
	var method_item : TreeItem = _object_methods_list.get_selected()
	var method : Dictionary = method_item.get_metadata(0)
	
	if is_instance_valid(object) and object.has_method(method["name"]):
		method_selected.emit(object, method)
	else:
		update()
#endregion Callbacks
func _update_methods_filters() -> void:
	_hide_private_button.set_pressed_no_signal(hide_private_methods)
	if hide_private_methods:
		_hide_private_button.icon = DebugUtil.get_editor_global_icon("GuiVisibilityHidden")
	else:
		_hide_private_button.icon = DebugUtil.get_editor_global_icon("GuiVisibilityVisible")
	
	_sort_by_name_button.set_pressed_no_signal(sort_methods_by_name)
	_sort_by_name_button.icon = DebugUtil.get_editor_global_icon("FontItem")

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
			
			if DebugUtil.has_editor_global_icon(native_base):
				class_icon = DebugUtil.get_editor_global_icon(native_base)
			
			class_methods = DebugUtil.script_get_method_list(script_base, true)
			
			script_base = script_base.get_base_script()
		else:
			class_name_ = native_base
			
			if DebugUtil.has_editor_global_icon(native_base):
				class_icon = DebugUtil.get_editor_global_icon(native_base)
			
			class_methods = DebugUtil.class_get_method_list(native_base, true, object)
			
			native_base = DebugUtil.get_parent_class(native_base)
		
		if not class_icon:
			class_icon = DebugUtil.get_editor_global_icon("Object")
		
		var section_item : TreeItem
		
		class_methods = class_methods.filter(_is_valid_method)
		if sort_methods_by_name:
			class_methods.sort_custom(_sort_method_by_name)
		
		if not class_methods.is_empty():
			section_item = _object_methods_list.create_item(root)
			section_item.set_text(0, class_name_)
			section_item.set_icon(0, class_icon)
			section_item.set_selectable(0, false)
			section_item.set_editable(0, false)
			section_item.set_custom_bg_color(0, get_theme_color("prop_subsection", "Editor"))
		for method : Dictionary in class_methods:
			var method_item : TreeItem = _object_methods_list.create_item(section_item)
			
			method_item.set_text(0, DebugUtil.get_method_signature(method))
			method_item.set_icon(0, DebugUtil.get_editor_global_icon("MemberMethod"))
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

func _sort_method_by_name(m1 : Dictionary, m2 : Dictionary) -> bool:
	return m1["name"] < m2["name"]
#endregion Private Methods
