class_name MinimalMenuComponent
extends CanvasLayer
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var toggle_menu_key : Key = KEY_ESCAPE
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _last_mouse_mode : Input.MouseMode
#endregion Private Variables

#region On Ready Variables
@onready var _resume_button   : Button = %ResumeButton
@onready var _settings_button : Button = %SettingsButton
@onready var _exit_buton      : Button = %ExitButton
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_last_mouse_mode = Input.mouse_mode
	
	visible = false
	
	_resume_button.pressed.connect(_on_resume_button_pressed)
	_settings_button.pressed.connect(_on_settings_button_pressed)
	_exit_buton.pressed.connect(_on_exit_button_pressed)

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventKey and event.keycode == toggle_menu_key and event.is_pressed():
		if visible:
			_close()
		else:
			_open()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_resume_button_pressed() -> void:
	_close()

func _on_settings_button_pressed() -> void:
	pass

func _on_exit_button_pressed() -> void:
	get_tree().quit()
#endregion Callbacks

func _open() -> void:
	get_tree().paused = true
	_last_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true

func _close() -> void:
	get_tree().paused = false
	Input.mouse_mode = _last_mouse_mode
	visible = false
#endregion Private Methods
