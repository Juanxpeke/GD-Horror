class_name PickableComponent extends RigidBody3D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
const DRAG_SPEED_MULTIPLIER : float = 30.0
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
var hand : Marker3D = null
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
func pick_item() -> void:	
	var a = global_transform.origin
	var b = PhysicsManager.player_hand.global_transform.origin
	set_linear_velocity((b-a) * DRAG_SPEED_MULTIPLIER)

#endregion Public Methods

#region Private Methods
#endregion Private Methods
