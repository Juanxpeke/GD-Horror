class_name PickableComponent extends RigidBody3D
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
@onready var _hittable_component : HittableComponent = %HittableComponent
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	if _hittable_component.is_hitted:
		pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
