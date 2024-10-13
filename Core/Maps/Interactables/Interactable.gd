class_name Interactable
extends StaticBody3D
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
@onready var hittable_component : HittableComponent = $HittableComponent
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and hittable_component.is_hitted:
		_interact()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _interact() -> void:
	pass
#endregion Private Methods
