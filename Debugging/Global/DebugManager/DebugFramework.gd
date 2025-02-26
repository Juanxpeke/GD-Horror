class_name DebugFramework extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
## TODO
enum DebugInterfacesListButton {
	## TODO
	BUTTON_VISIBILITY,
	## TODO
	BUTTON_IN_GAME,
}
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _debug_menu_window : Window
var _debug_menu : PanelContainer
var _debug_interfaces_list : Tree
var _toggle_paused_button : Button
var _stop_debugging_button : Button
var _exit_button : Button

var _console_window : Window
var _console : Console
var _scene_tree_inspector_window : Window
var _scene_tree_inspector : SceneTreeInspector

var _debug_windows : Array[Window]

var _in_game_paused : bool
var _in_game_mouse_mode : Input.MouseMode

var _previous_session_windows : Array[Window] = []

var _debugging : bool = false:
	set(new_debugging):
		_debugging = new_debugging
		_update()
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	
	_debug_menu_window = Window.new()
	_init_window(_debug_menu_window, "Debug Menu")
	_debug_menu_window.unresizable = true
	add_child(_debug_menu_window)
	
	_scene_tree_inspector_window = Window.new()
	_init_window(_scene_tree_inspector_window, "Scene Tree Inspector")
	add_child(_scene_tree_inspector_window)
	
	_scene_tree_inspector = SceneTreeInspector.new()
	_scene_tree_inspector.set_anchors_preset(Control.PRESET_FULL_RECT)
	_scene_tree_inspector_window.add_child(_scene_tree_inspector)
	
	_console_window = Window.new()
	_init_window(_console_window, "Console")
	add_child(_console_window)
	
	_console = Console.new()
	_console.set_anchors_preset(Control.PRESET_FULL_RECT)
	_console_window.add_child(_console)
	
	_debug_windows = [_console_window, _scene_tree_inspector_window]
	
	_init_debug_menu() # NOTE: This needs debug windows to be initialized

func _init_debug_menu() -> void:
	_debug_menu = PanelContainer.new()
	_debug_menu.set_anchors_preset(Control.PRESET_FULL_RECT)
	_debug_menu.theme = DebugUtil.get_editor_theme()
	_debug_menu.add_theme_stylebox_override("panel", DebugUtil.get_editor_darker_stylebox())
	_debug_menu_window.add_child(_debug_menu)
	
	var _debug_vbox := VBoxContainer.new()
	_debug_menu.add_child(_debug_vbox)
	
	_debug_interfaces_list = Tree.new()
	_debug_interfaces_list.columns = 1
	_debug_interfaces_list.hide_folding = true
	_debug_interfaces_list.scroll_horizontal_enabled = false
	_debug_interfaces_list.scroll_vertical_enabled = false
	_debug_interfaces_list.hide_root = true
	_debug_interfaces_list.button_clicked.connect(_on_debug_interfaces_list_button_clicked)
	
	var _root := _debug_interfaces_list.create_item()
	for window in _debug_windows:
		_create_debug_interface_item(window)
	
	_debug_vbox.add_child(_debug_interfaces_list)
	
	var _bottom_vbox := VBoxContainer.new()
	_debug_vbox.add_child(_bottom_vbox)
	
	_toggle_paused_button = Button.new()
	_toggle_paused_button.text = "Toggle Paused"
	_toggle_paused_button.theme_type_variation = DebugUtil.get_editor_light_button_variation()
	_toggle_paused_button.pressed.connect(_on_toggle_paused_button_pressed)
	_bottom_vbox.add_child(_toggle_paused_button)
	
	_stop_debugging_button = Button.new()
	_stop_debugging_button.text = "Stop Debugging"
	_stop_debugging_button.theme_type_variation = DebugUtil.get_editor_light_button_variation()
	_stop_debugging_button.pressed.connect(_on_stop_debugging_button_pressed)
	_bottom_vbox.add_child(_stop_debugging_button)
	
	_exit_button = Button.new()
	_exit_button.text = "Exit"
	_exit_button.theme_type_variation = DebugUtil.get_editor_light_button_variation()
	_exit_button.pressed.connect(_on_exit_button_pressed)
	_bottom_vbox.add_child(_exit_button)

func _init_window(window : Window, title : String = "Window") -> void:
	window.mode = Window.MODE_WINDOWED
	window.title = title
	window.initial_position = Window.WINDOW_INITIAL_POSITION_ABSOLUTE
	window.visible = false
	window.wrap_controls = true # NOTE: This is GOD to respect controls content size
	window.always_on_top = true
	window.extend_to_title = true # NOTE: Only works for macOS
	window.force_native = true
	window.gui_embed_subwindows = true
	window.close_requested.connect(_window_close_requested_callback.bind(window))

func _ready() -> void:
	_scene_tree_inspector_window.position = get_tree().root.position
	_console_window.position = get_tree().root.position
	_debug_menu_window.position = get_tree().root.position
	
	get_tree().root.focus_entered.connect(_on_main_window_focus_entered)
	get_tree().root.focus_exited.connect(_on_main_window_focus_exited)
	
	_debug_menu_window.close_requested.connect(func(): _debugging = false)

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey and event.keycode == DebugManager.open_debug_menu_key and event.is_pressed():
		_debugging = true

func _notification(what : int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			_debug_menu_window.always_on_top = true
			_console_window.always_on_top = true
			_scene_tree_inspector_window.always_on_top = true 
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			_debug_menu_window.always_on_top = false
			_console_window.always_on_top = false
			_scene_tree_inspector_window.always_on_top = false
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Assertions
#endregion Assertions
#region Callbacks
func _on_main_window_focus_entered() -> void:
	if _debugging:
		_return_to_in_game_state()

func _on_main_window_focus_exited() -> void:
	if _debugging:
		_save_in_game_state()
		
		Engine.get_main_loop().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_debug_interfaces_list_button_clicked(item : TreeItem, _column : int, id : int, _mouse_button_index : int) -> void:
	var window : Window = item.get_metadata(0)
	
	match id:
		DebugInterfacesListButton.BUTTON_VISIBILITY:
			if window.visible:
				window.visible = false
			else:
				window.visible = true
				window.grab_focus()

func _on_toggle_paused_button_pressed() -> void:
	Engine.get_main_loop().paused = not Engine.get_main_loop().paused

func _on_stop_debugging_button_pressed() -> void:
	_debugging = false

func _on_exit_button_pressed() -> void:
	Engine.get_main_loop().quit()
#endregion Callbacks
#region Bind Callbacks
func _window_close_requested_callback(window : Window) -> void:
	if is_instance_valid(window):
		window.hide()

func _window_visibility_changed_callback(window : Window) -> void:
	if is_instance_valid(window) and window.has_meta(DebugUtil.META_DEBUG_INTERFACES_LIST_ITEM):
		var tree_item : TreeItem = window.get_meta(DebugUtil.META_DEBUG_INTERFACES_LIST_ITEM)
		
		if tree_item:
			if window.visible:
				tree_item.set_button(0, DebugInterfacesListButton.BUTTON_VISIBILITY, DebugUtil.get_editor_global_icon("GuiVisibilityVisible"))
			else:
				tree_item.set_button(0, DebugInterfacesListButton.BUTTON_VISIBILITY, DebugUtil.get_editor_global_icon("GuiVisibilityHidden"))
#endregion Bind Callbacks

func _update() -> void:
	if _debugging:
		for window in _previous_session_windows:
			window.show()
		_previous_session_windows.clear()
		
		_debug_menu_window.show()
		_debug_menu_window.grab_focus()
		
	else:
		for window in _debug_windows:
			if window.visible:
				window.hide()
				_previous_session_windows.push_back(window)
		
		_debug_menu_window.hide()
		
		_return_to_in_game_state()

func _create_debug_interface_item(window : Window) -> void:
	if not is_instance_valid(window):
		return
	
	var tree_item := _debug_interfaces_list.create_item()
	tree_item.set_text(0, window.title)
	tree_item.set_metadata(0, window)
	tree_item.set_selectable(0, false)
	tree_item.set_text_overrun_behavior(0, TextServer.OVERRUN_NO_TRIMMING)
	
	if window.visible:
		tree_item.add_button(0, DebugUtil.get_editor_global_icon("GuiVisibilityVisible"), DebugInterfacesListButton.BUTTON_VISIBILITY, false, "Toggle Visibility")
	else:
		tree_item.add_button(0, DebugUtil.get_editor_global_icon("GuiVisibilityHidden"), DebugInterfacesListButton.BUTTON_VISIBILITY, false, "Toggle Visibility")
	
	if not window.visibility_changed.is_connected(_window_visibility_changed_callback.bind(window)):
		window.visibility_changed.connect(_window_visibility_changed_callback.bind(window))
	
	window.set_meta(DebugUtil.META_DEBUG_INTERFACES_LIST_ITEM, tree_item)

func _return_to_in_game_state() -> void:
	Engine.get_main_loop().paused = _in_game_paused
	Input.mouse_mode = _in_game_mouse_mode

func _save_in_game_state() -> void:
	_in_game_paused = Engine.get_main_loop().paused
	_in_game_mouse_mode = Input.mouse_mode
#endregion Private Methods
