class_name MethodCallerInterface extends Control
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables

#endregion Exports Variables

#region Public Variables
## TODO
var object : Object = null
## TODO
var method : Dictionary = {}:
	set(new_method):
		method = new_method
		if is_inside_tree():
			update()
#endregion Public Variables

#region Private Variables
var _arguments : Array = []
#endregion Private Variables

#region On Ready Variables
@onready var _no_object_or_method_label_container : MarginContainer = %NoObjectOrMethodLabelContainer
@onready var _method_caller_menu : VBoxContainer = %MethodCallerMenu
@onready var _object_icon : TextureRect = %ObjectIcon
@onready var _object_name_label : Label = %ObjectNameLabel
@onready var _method_name_label : Label = %MethodNameLabel
@onready var _arguments_list : VBoxContainer = %ArgumentsList
@onready var _call_button : Button = %CallButton
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	update()
	
	_call_button.theme_type_variation = "InspectorActionButton"
	_call_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_call_button.icon = DebugManager.get_editor_class_icon("Callable")
	
	_call_button.pressed.connect(_on_call_button_pressed)
#endregion Built-in Virtual Methods

#region Public Methods
func update() -> void:
	if not object or not method or not object.has_method(method["name"]):
		_method_caller_menu.hide()
		_no_object_or_method_label_container.show()
	else:
		_no_object_or_method_label_container.hide()
		_method_caller_menu.show()
		
		_update_object_and_method()
		_update_arguments()
		_update_call_button()
	
	LogManager.debugging_log("Method caller interface updated")
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
	_object_icon.texture = DebugManager.get_editor_class_icon(object.get_class())
	if not object is Node:
		_object_name_label.text = object.get_class()
	else:
		_object_name_label.text = object.name
	
	_method_name_label.text = method["name"]

func _update_arguments() -> void:
	_arguments.clear()
	_arguments.resize(method["args"].size())
	
	for editor_argument in _arguments_list.get_children():
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

	_arguments_list.add_child(editor)

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
	
	if def_idx >= 0:
		string_argument_editor.text = method["default_args"][def_idx]
	_arguments[arg_idx] = string_argument_editor.text
	
	string_argument_editor.text_changed.connect(func(new_text): _arguments[arg_idx] = new_text)
	
	_create_inline_argument_editor(arg, string_argument_editor)

func _update_call_button() -> void:
	_call_button.disabled = false
#endregion Private Methods
