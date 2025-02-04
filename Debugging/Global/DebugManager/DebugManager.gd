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
@export var minimal_menu_scene : PackedScene
## TODO
@export var log_interface_enabled : bool = true
## TODO
@export var log_interface_scene : PackedScene
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
#endregion Public Methods

#region Private Methods
#endregion Private Methods
