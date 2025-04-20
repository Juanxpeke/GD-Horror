extends Node
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
func _enter_tree() -> void:
	for node in get_tree().get_nodes_in_group("JuanxpHittableComponent"):
		var hittable_component : HittableComponent = node as HittableComponent
		hittable_component.collision_object.collision_layer |= PhysicsManager.CollisionLayer.CAMERA_RAY
	
	get_tree().node_added.connect(_on_tree_node_added)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_tree_node_added(node : Node) -> void:
	if node.is_in_group("JuanxpHittableComponent"):
		var hittable_component : HittableComponent = node as HittableComponent
		hittable_component.collision_object.collision_layer |= PhysicsManager.CollisionLayer.CAMERA_RAY
#endregion Private Methods
