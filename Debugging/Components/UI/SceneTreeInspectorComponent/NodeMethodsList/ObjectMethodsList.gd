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
#endregion Public Variables

#region Private Variables
var _no_object_label_container : MarginContainer
var _release_build_methods_list : ItemList
#endregion Private Variables

#region On Ready Variables
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
func _on_release_build_item_activated(index : int) -> void:
	var method : Dictionary = _release_build_methods_list.get_item_metadata(index)
	method_selected.emit(object, method)
#endregion Callbacks
func _initialize() -> void:
	_initialize_no_object_label_container()
	
	if OS.is_debug_build():
		_initialize_as_debug_build()
	else:
		_initialize_as_release_build()

func _initialize_no_object_label_container() -> void:
	_no_object_label_container = MarginContainer.new()
	_no_object_label_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_no_object_label_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_no_object_label_container.add_theme_constant_override("margin_left",   16)
	_no_object_label_container.add_theme_constant_override("margin_top",    16)
	_no_object_label_container.add_theme_constant_override("margin_right",  16)
	_no_object_label_container.add_theme_constant_override("margin_bottom", 16)
	
	var _no_object_label := Label.new()
	_no_object_label.text = "Select a Node or Resource to see its methods."
	_no_object_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_no_object_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_no_object_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_no_object_label_container.add_child(_no_object_label)
	
	add_child(_no_object_label_container)

func _initialize_as_debug_build() -> void:
	_initialize_as_release_build()

func _initialize_as_release_build() -> void:
	_release_build_methods_list = ItemList.new()
	_release_build_methods_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_release_build_methods_list.item_activated.connect(_on_release_build_item_activated)
	add_child(_release_build_methods_list)

func _update() -> void:
	_no_object_label_container.hide()
	
	if OS.is_debug_build():
		_update_as_debug_build()
	else:
		_update_as_release_build()

func _update_as_debug_build() -> void:
	_update_as_release_build()

func _update_as_release_build() -> void:
	_release_build_methods_list.clear()
	_release_build_methods_list.hide()
	
	if not object:
		_no_object_label_container.show()
		return
	
	var methods : Array[Dictionary] = object.get_method_list()
	
	for method : Dictionary in methods:
		var method_name : String = method["name"]
		var method_flags : MethodFlags = method["flags"]
		
		if method_flags & METHOD_FLAG_EDITOR:
			continue
		if method_flags & METHOD_FLAG_CONST:
			continue
		if method_flags & METHOD_FLAG_VIRTUAL:
			continue
		if method_flags & METHOD_FLAG_VARARG:
			continue
		if method_flags & METHOD_FLAG_STATIC:
			continue
		if method_flags & METHOD_FLAG_OBJECT_CORE:
			continue
		if method_name[0] == "_":
			continue
		
		var method_item_idx := _release_build_methods_list.add_item(method_name)
		_release_build_methods_list.set_item_metadata(method_item_idx, method)
	
	_release_build_methods_list.show()
#endregion Private Methods
