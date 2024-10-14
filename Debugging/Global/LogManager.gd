extends Node
## A global class for custom log methods.

#region Signals
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
var _rendering_color : String = "green"
var _physics_color : String = "yellow"
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
#endregion Built-in Virtual Methods

#region Public Methods
# Logs a message related to a rendering system.
func rendering_log(message : String) -> void:
	print_rich("[color=%s](Rendering) %s[/color]" % [_rendering_color, message])

# Logs a message related to a physics system.
func physics_log(message : String) -> void:
	print_rich("[color=%s](Physics) %s[/color]" % [_physics_color, message])
#endregion Public Methods

#region Private Methods
#endregion Private Methods
