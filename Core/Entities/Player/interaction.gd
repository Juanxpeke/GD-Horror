extends RayCast3D
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
@onready var last_hittable_component : HittableComponent = null
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	var new_collider = get_collider()
	
	if not new_collider and last_hittable_component:
		last_hittable_component.unregister_hit()
		last_hittable_component = null
	
	if new_collider:
		var hittable_component := get_hittable_component(new_collider)
		
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
	var aux_node = node.get_node_or_null("HittableComponent")
	if not aux_node:
		aux_node = node.get_parent().get_node("HittableComponent")
	return aux_node
#endregion Private Methods
