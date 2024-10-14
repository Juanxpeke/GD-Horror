class_name InteractableComponent
extends HittableComponent
## A [HittableComponent] that reacts to the interact key.

#region Signals
signal interacted
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
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_hitted:
		interacted.emit()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
