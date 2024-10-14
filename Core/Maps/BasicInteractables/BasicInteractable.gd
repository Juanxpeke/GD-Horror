class_name BasicInteractable
extends CollisionObject3D
## A [CollisionObject3D] which detects the camera ray and can be interactable
## by pressing the interact key.

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
@onready var _interactable_component : InteractableComponent = $InteractableComponent
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_interactable_component.interacted.connect(_on_interacted)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_interacted() -> void:
	_interact()

func _interact() -> void:
	pass
#endregion Private Methods
