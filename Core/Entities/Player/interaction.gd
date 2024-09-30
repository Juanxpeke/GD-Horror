extends RayCast3D
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
@onready var actual_collider : RigidBody3D = get_collider()
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	var new_collider = get_collider()
	if new_collider != actual_collider:
		if actual_collider != null:
			actual_collider.not_in_range()
		actual_collider = new_collider
		if new_collider != null:
			new_collider.in_range()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
