extends Control
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
@export var current_camera : Camera3D 
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var sub_viewport : SubViewport = $PanelContainer/SubViewportContainer/SubViewport
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	if current_camera:
		await get_tree().create_timer(1.0).timeout
		print("XDD")
		current_camera.get_parent().remove_child(current_camera)
		var xd = Camera3D.new()
		sub_viewport.add_child(xd) #.add_child(current_camera)
func _process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
