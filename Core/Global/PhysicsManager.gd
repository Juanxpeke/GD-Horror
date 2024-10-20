extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
enum CollisionLayer {
	WORLD = 1 << 0 , 
	CAMERA_RAY = 1 << 31
}
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
var player_hand : Marker3D = null:
	set(new_player_hand):
		player_hand = new_player_hand
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

func _process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
