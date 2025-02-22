class_name DebugMenuComponent extends Control
## Docstring

#region Signals
## TODO
signal stop_debugging_requested
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _debug_windows : Array[Window] = []
#endregion Private Variables

#region On Ready Variables
@onready var _game_paused_check_box : CheckBox = %GamePausedCheckBox
@onready var _debug_windows_list    : Control  = %DebugWindowsList
@onready var _stop_debugging_button : Button   = %StopDebuggingButton
@onready var _exit_button           : Button   = %ExitButton
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("DefaultPanel", "EditorStyles"))
	
	_update()
	
	_game_paused_check_box.toggled.connect(_on_game_paused_check_box_toggled)
	
	_stop_debugging_button.pressed.connect(_on_stop_debugging_button_pressed)
	_exit_button.pressed.connect(_on_exit_button_pressed)
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func add_debug_window(window : Window) -> void:
	_debug_windows.push_back(window)
	
	_update()
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_game_paused_check_box_toggled(toggled_on : bool) -> void:
	get_tree().paused = toggled_on

func _on_stop_debugging_button_pressed() -> void:
	stop_debugging_requested.emit()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
#endregion Callbacks

func _update() -> void:
	for child in _debug_windows_list.get_children():
		child.queue_free()
	
	for window in _debug_windows:
		_create_window_button(window)
	
	if _debug_windows.is_empty():
		_debug_windows_list.hide()
	else:
		_debug_windows_list.show()

func _create_window_button(window : Window) -> void:
	var button := Button.new()
	
	button.text = "Open %s" % window.title
	button.pressed.connect(func(): window.show(); window.grab_focus())
	
	_debug_windows_list.add_child(button)

#endregion Private Methods
