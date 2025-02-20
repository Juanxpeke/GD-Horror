class_name DebugComponent extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
## TODO
enum DebugEnum {
	FIRST,
	SECOND
}
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
func method(what_if : bool, past_action : String,  n_times : int = 0) -> void:
	if what_if:
		LogManager.audio_log("We %s %d times" % [past_action, n_times]) # TODO
	else:
		LogManager.audio_log("We didn't %s %d times" % [past_action, n_times]) # TODO
## TODO
func enum_method(e : DebugEnum) -> void:
	LogManager.audio_log(str(e))
## TODO
func array_method(arr : Array, typed_arr : Array[bool]) -> void:
	LogManager.audio_log(str(arr) + "-" + str(typed_arr))
#endregion Public Methods

#region Private Methods
#endregion Private Methods
