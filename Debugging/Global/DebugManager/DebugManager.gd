extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#region Meta Names
#endregion Meta Names
#endregion Constants

#region Exports Variables
## TODO
@export var open_debug_menu_key : Key = KEY_HOME
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	var debug_framework := DebugFramework.new()
	add_child(debug_framework)
	
	var node_debug := ParentDebug.new()
	add_child(node_debug)
#endregion Built-in Virtual Methods

#region Public Methods
#region Editor Theme
#endregion Editor Theme
#endregion Public Methods

#region Private Methods
#endregion Private Methods
