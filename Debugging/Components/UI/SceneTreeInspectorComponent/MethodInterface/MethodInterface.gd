class_name MethodInterface extends VBoxContainer
## An interface that displays the properties of a given method and might allow the
## user to call it.

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const COMPONENT_LABELS : Array[String] = ["x", "y", "z", "w"]
#endregion Constants

#region Exports Variables

#endregion Exports Variables

#region Public Variables
## TODO
var object : Object = null:
	set(new_object):
		object = new_object
		update()
## TODO
var method : Dictionary = {}:
	set(new_method):
		method = new_method
		update()
#endregion Public Variables

#region Private Variables
var _no_data_container : MarginContainer
var _method_container : PanelContainer
var _object_text_rect : TextureRect
var _object_name_label : Label
var _method_name_label : Label
var _arguments_vbox : VBoxContainer
var _call_button : Button

var _arguments : Array = []
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
	_no_data_label.text = "Press a method in the 'Methods List' menu."
	_no_data_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_no_data_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_no_data_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	_no_data_container.add_child(_no_data_label)
	
	_method_container = PanelContainer.new()
	_method_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_method_container.add_theme_stylebox_override("panel", DebugUtil.get_editor_darker_stylebox())
	add_child(_method_container)
	
	var _method_vbox = VBoxContainer.new()
	_method_container.add_child(_method_vbox)
	
	var _object_information_hbox := HBoxContainer.new()
	_method_vbox.add_child(_object_information_hbox)
	
	_object_text_rect = TextureRect.new()
	_object_text_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_object_information_hbox.add_child(_object_text_rect)
	
	_object_name_label = Label.new()
	_object_name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	_object_information_hbox.add_child(_object_name_label)
	
	var _method_information_hbox := HBoxContainer.new()
	_method_vbox.add_child(_method_information_hbox)
	
	_method_name_label = Label.new()
	_method_name_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	_method_information_hbox.add_child(_method_name_label)
	
	_arguments_vbox = VBoxContainer.new()
	_method_vbox.add_child(_arguments_vbox)
	
	_call_button = Button.new()
	_call_button.text = "Call Method"
	_call_button.icon = DebugUtil.get_editor_global_icon("Callable")
	_call_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_call_button.theme_type_variation = DebugUtil.get_editor_light_button_variation()
	_call_button.pressed.connect(_on_call_button_pressed)
	_method_vbox.add_child(_call_button)
	
	update()
	
#endregion Built-in Virtual Methods

#region Public Methods
## Updates this interface.
func update() -> void:
	if not object or not method or not object.has_method(method["name"]):
		_method_container.hide()
		_no_data_container.show()
	else:
		_no_data_container.hide()
		_method_container.show()
		
		_update_object_and_method()
		_update_arguments()
		_update_call_button()
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_call_button_pressed() -> void:
	if object and object.has_method(method["name"]):
		object.callv(method["name"], _arguments)
	else:
		update()
#endregion Callbacks
func _update_object_and_method() -> void:
	_object_text_rect.texture = DebugUtil.get_editor_global_icon(object.get_class())
	if not object is Node:
		_object_name_label.text = object.get_class()
	else:
		_object_name_label.text = object.name
	
	_method_name_label.text = method["name"]

func _update_arguments() -> void:
	_arguments.clear()
	_arguments.resize(method["args"].size())
	
	for editor_argument in _arguments_vbox.get_children():
		editor_argument.queue_free()
	
	var first_default_arg_idx =  method["args"].size() - method["default_args"].size()
	
	var arg_idx : int = 0
	for arg : Dictionary in method["args"]:
		var def_idx : int = arg_idx - first_default_arg_idx
		
		match arg["type"]:
			TYPE_NIL:
				continue
			TYPE_BOOL:
				_create_bool_argument_editor(arg, arg_idx, def_idx)
			TYPE_INT:
				_create_int_argument_editor(arg, arg_idx, def_idx)
			TYPE_STRING, TYPE_STRING_NAME:
				_create_string_argument_editor(arg, arg_idx, def_idx)
			TYPE_VECTOR2, TYPE_VECTOR2I, TYPE_VECTOR3, TYPE_VECTOR3I:
				_create_vector_argument_editor(arg, arg_idx, def_idx)
		arg_idx += 1

func _create_inline_argument_editor(arg : Dictionary, raw_editor : Control) -> void:
	var editor := HBoxContainer.new()

	var label := Label.new()
	label.text = arg["name"]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.clip_text = true
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	raw_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	editor.add_child(label)
	editor.add_child(raw_editor)

	_arguments_vbox.add_child(editor)

func _create_bool_argument_editor(arg : Dictionary, arg_idx : int, def_idx : int) -> void:
	var bool_argument_editor := CheckBox.new()

	if def_idx >= 0:
		bool_argument_editor.button_pressed = method["default_args"][def_idx]
	_arguments[arg_idx] = bool_argument_editor.button_pressed
	
	bool_argument_editor.text = "On"
	bool_argument_editor.toggled.connect(func(toggled_on): _arguments[arg_idx] = toggled_on)
	
	_create_inline_argument_editor(arg, bool_argument_editor)

func _create_int_argument_editor(arg : Dictionary, arg_idx : int, def_idx : int) -> void:
	var int_argument_editor := SpinBox.new()
	
	if def_idx >= 0:
		int_argument_editor.value = method["default_args"][def_idx]
	_arguments[arg_idx] = int_argument_editor.value
	
	int_argument_editor.value_changed.connect(func(value): _arguments[arg_idx] = value)
	
	_create_inline_argument_editor(arg, int_argument_editor)

func _create_string_argument_editor(arg : Dictionary, arg_idx : int, def_idx : int) -> void:
	var string_argument_editor := LineEdit.new()
	string_argument_editor.caret_blink = true
	
	if def_idx >= 0:
		string_argument_editor.text = method["default_args"][def_idx]
	_arguments[arg_idx] = string_argument_editor.text
	
	string_argument_editor.text_changed.connect(func(new_text): _arguments[arg_idx] = new_text)
	
	_create_inline_argument_editor(arg, string_argument_editor)

func _create_vector_argument_editor(arg : Dictionary, arg_idx : int, def_idx : int) -> void:
	var component_count : int
	match arg["type"]:
		TYPE_VECTOR2, TYPE_VECTOR2I:
			component_count = 2
		TYPE_VECTOR3, TYPE_VECTOR3I:
			component_count = 3
		TYPE_VECTOR4, TYPE_VECTOR4I:
			component_count = 4
	
	var hb := HBoxContainer.new()
	hb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var bc : BoxContainer
	if true:
		bc = HBoxContainer.new()
	bc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hb.add_child(bc)
	
	var spin_sliders : Array[SpinBox] = []
	spin_sliders.resize(component_count)
	
	for i : int in range(component_count):
		spin_sliders[i] = SpinBox.new()
		#spin[i]->set_flat(true);
		#spin[i]->set_label(String(COMPONENT_LABELS[i]));
		if true:
			spin_sliders[i].size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		
		bc.add_child(spin_sliders[i])
	
	_arguments_vbox.add_child(hb)

func _update_call_button() -> void:
	_call_button.disabled = false
#endregion Private Methods
