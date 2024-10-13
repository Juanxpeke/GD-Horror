class_name TV
extends Interactable
## A TV.

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
## Boolean related to the TV on state.
var is_on : bool = false
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _interact() -> void:
	if not is_on:
		is_on = true
		print("TV ON")
	else:
		is_on = false
		print("TV OFF")
#endregion Private Methods
