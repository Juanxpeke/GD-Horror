extends Node3D
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

func _input(event : InputEvent) -> void:
	var cubo : RigidBody3D = $Cubos/Cubo
	if event.is_action_pressed("interact"):
		cubo.linear_velocity = Vector3(10, 0, 0)
	elif event.is_action_released("interact"):
		cubo.apply_impulse(Vector3(100, 0, 0))
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
