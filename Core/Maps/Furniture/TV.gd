class_name TV
extends StaticBody3D
## A TV object that can be turned on or off.

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
## Boolean that tells if the TV is on or not.
var is_on : bool = false
#endregion Private Variables

#region On Ready Variables
@onready var hittable_component : HittableComponent = %HittableComponent
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	hittable_component.interacted.connect(_on_interacted)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_interacted() -> void:
	if not is_on:
		is_on = true
		hittable_component.interaction_name = "Turn OFF" # TODO: HUD can't handle interaction name changes
	else:
		is_on = false
		hittable_component.interaction_name = "Turn ON"
#endregion Private Methods
