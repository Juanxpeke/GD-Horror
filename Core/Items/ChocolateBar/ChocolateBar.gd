class_name ChocolateBar
extends RigidBody3D
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
	_hittable_component.interacted.connect(_on_interacted)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_interacted() -> void:
	print("nam nam nam")
#endregion Private Methods
