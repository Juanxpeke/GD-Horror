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
@export var add_minimal_menu : bool = true
## TODO
@export var minimal_menu_scene : PackedScene
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	if add_minimal_menu and minimal_menu_scene:
		var minimal_menu : MinimalMenuComponent = minimal_menu_scene.instantiate()
		add_child(minimal_menu)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
