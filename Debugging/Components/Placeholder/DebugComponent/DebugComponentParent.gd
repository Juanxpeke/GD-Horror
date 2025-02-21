class_name DebugComponentParent extends DebugComponent
## Docstring

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
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func method(what_if : bool, action : String,  n_times : int = 0) -> void:
	LogManager.debugging_log("Get overrided") # TODO
## TODO
func parent_method(what_if : bool, action : String,  n_times : int = 0, at : String = "Paris") -> void:
	if what_if:
		LogManager.debugging_log("We did %s %d times at %s" % [action, n_times, at]) # TODO
	else:
		LogManager.debugging_log("We didn't %s %d times at %s" % [action, n_times, at]) # TODO
#endregion Public Methods

#region Private Methods
#endregion Private Methods
