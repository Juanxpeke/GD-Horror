extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
enum CollisionLayer {
	STATIC_WORLD = 1 <<  0,
	RIGID_WORLD  = 1 <<  1,
	PLAYER_WORLD = 1 <<  2, 
	CAMERA_RAY   = 1 << 31
}
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	LogManager.physics_log("Default gravity: %f" % gravity)

func _process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
