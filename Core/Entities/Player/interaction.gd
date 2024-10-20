class_name Interaction extends RayCast3D
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
var last_collider : CollisionObject3D = null
var last_hittable_component : HittableComponent = null
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	last_collider = get_collider()
	
	if not last_collider and last_hittable_component:
		last_hittable_component.unregister_hit()
		last_hittable_component = null
	
	if last_collider:
		var hittable_component := get_hittable_component(last_collider)
		
		if hittable_component != last_hittable_component:
			if last_hittable_component:
				last_hittable_component.unregister_hit()
			last_hittable_component = hittable_component
			last_hittable_component.register_hit()
		
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func get_hittable_component(node : Node3D) -> HittableComponent:
	var component_path = node.get_meta("HittableComponentPath", null)
	assert(component_path)
	return node.get_node(component_path)
#endregion Private Methods
