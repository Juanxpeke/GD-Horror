class_name DebugInterface extends CanvasLayer
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
const MAX_LAYER : int = 128
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _debugging : bool = false:
	set(new_debugging):
		_debugging = new_debugging
		if is_inside_tree():
			_update()

var _in_game_paused : bool
var _in_game_mouse_mode : Input.MouseMode

var _previous_session_windows : Array[Window] = []
#endregion Private Variables

#region On Ready Variables
@onready var _debug_menu_window : Window = %DebugMenuWindow
@onready var _scene_tree_inspector_window : Window = %SceneTreeInspectorWindow
@onready var _log_interface : LogInterfaceComponent = %LogInterfaceComponent
@onready var _debug_menu : DebugMenuComponent = %DebugMenuComponent
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	layer = MAX_LAYER
	
	_force_windows_properties()
	
	get_tree().root.focus_entered.connect(_on_main_window_focus_entered)
	get_tree().root.focus_exited.connect(_on_main_window_focus_exited)
	
	_debug_menu.add_debug_window(_scene_tree_inspector_window)
	
	_debug_menu_window.close_requested.connect(func(): _debugging = false)
	_scene_tree_inspector_window.close_requested.connect(func(): _scene_tree_inspector_window.hide())

	_debug_menu.stop_debugging_requested.connect(func(): _debugging = false)

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey and event.keycode == DebugManager.open_debug_menu_key and event.is_pressed():
		_debugging = true
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func toggle_log_interface() -> void:
	_log_interface.visible = not _log_interface.visible
#endregion Public Methods

#region Private Methods
#region Assertions
func _force_windows_properties() -> void:
	_force_window_property(_debug_menu_window)
	_force_window_property(_scene_tree_inspector_window)

func _force_window_property(window : Window) -> void:
	window.initial_position = Window.WINDOW_INITIAL_POSITION_ABSOLUTE
	window.position = get_tree().root.position
	window.visible = false
	window.wrap_controls = true
	window.extend_to_title = true # NOTE: Only works for macOS
	window.force_native = true
	window.gui_embed_subwindows = true
#endregion Assertions
#region Callbacks
func _on_main_window_focus_entered() -> void:
	if _debugging:
		_return_to_in_game_state()

func _on_main_window_focus_exited() -> void:
	if _debugging:
		_save_in_game_state()
		
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#endregion Callbacks

func _update() -> void:
	if _debugging:
		for window in _previous_session_windows:
			window.show()
		_previous_session_windows.clear()
		
		_debug_menu_window.show()
		_debug_menu_window.grab_focus()
	else:
		if _scene_tree_inspector_window.visible:
			_scene_tree_inspector_window.hide()
			_previous_session_windows.push_back(_scene_tree_inspector_window)
		
		_debug_menu_window.hide()
		
		_return_to_in_game_state()

func _return_to_in_game_state() -> void:
	get_tree().paused = _in_game_paused
	Input.mouse_mode = _in_game_mouse_mode

func _save_in_game_state() -> void:
	_in_game_paused = get_tree().paused
	_in_game_mouse_mode = Input.mouse_mode
#endregion Private Methods
