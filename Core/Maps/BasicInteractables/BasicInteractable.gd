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
var _interactable_component : InteractableComponent = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	var depth : int = 1
	_find_interactable_component(depth)
	
	if _interactable_component:
		_interactable_component.interacted.connect(_on_interacted)
	else:
		push_warning("InteractableComponent child not found.")
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _find_interactable_component(depth : int) -> void:
	var nodes_left : Array[Node] = [self]
	
	while depth > 0:
		var next_nodes_left : Array[Node] = []
		for node : Node in nodes_left:
			next_nodes_left.append_array(node.get_children())
		
		nodes_left = next_nodes_left
		
		depth -= 1
		
		for node : Node in nodes_left:
			if node is InteractableComponent:
				_interactable_component = node
				return

func _on_interacted() -> void:
	_interact()

func _interact() -> void:
	pass
#endregion Private Methods
