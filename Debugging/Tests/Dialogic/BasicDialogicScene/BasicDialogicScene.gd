extends Node3D
## Docstring

@export var basic_dialogic_timeline : DialogicTimeline

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
func _input(event: InputEvent):
	# Check if a dialog is already running
	if Dialogic.current_timeline != null:
		return

	if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
		Dialogic.start(basic_dialogic_timeline)
		get_viewport().set_input_as_handled()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
