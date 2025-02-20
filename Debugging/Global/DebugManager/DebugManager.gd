extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
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
func get_editor_class_icon(class_name_ : String) -> Texture2D:
	if editor_theme.has_icon(class_name_, "EditorIcons"):
		return editor_theme.get_icon(class_name_, "EditorIcons")
	return editor_theme.get_icon("Object", "EditorIcons")
#endregion Editor Theme
#endregion Public Methods

#region Private Methods
#endregion Private Methods
