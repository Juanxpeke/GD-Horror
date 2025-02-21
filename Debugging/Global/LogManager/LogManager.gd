extends Node
## A global class for custom log methods.

#region Signals
## TODO
signal rendering_log_issued(message : String)
## TODO
signal physics_log_issued(message : String)
## TODO
signal audio_log_issued(message : String)
## TODO
signal debugging_log_issued(message : String)
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
var rendering_color : String = "green"
var physics_color   : String = "yellow"
var audio_color     : String = "cyan"
var debugging_color : String = "white"
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
#endregion Built-in Virtual Methods

#region Public Methods
## Logs a message related to a rendering system.
func rendering_log(message : String) -> void:
	print_rich("[color=%s](Rendering) %s[/color]" % [rendering_color, message])
	rendering_log_issued.emit(message)
## Logs a message related to a physics system.
func physics_log(message : String) -> void:
	print_rich("[color=%s](Physics) %s[/color]" % [physics_color, message])
	physics_log_issued.emit(message)
## Logs a message related to an audio system.
func audio_log(message : String) -> void:
	print_rich("[color=%s](Audio) %s[/color]" % [audio_color, message])
	audio_log_issued.emit(message)
## Logs a message related to a debugging system.
func debugging_log(message : String) -> void:
	print_rich("[color=%s](Debugging) %s[/color]" % [debugging_color, message])
	debugging_log_issued.emit(message)
#endregion Public Methods

#region Private Methods
#endregion Private Methods
