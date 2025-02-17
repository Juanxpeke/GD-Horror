class_name PlayerRay extends RayCast3D
## TODO

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
	
	if not HittableComponent.picking:
		if not last_collider:
			# Make sure last_hittable_component is not null nor being freed
			if is_instance_valid(last_hittable_component):
				last_hittable_component.unregister_hit()
			# If last_hittable_component is not null, emit global unhit signal
			if last_hittable_component:
				EventsManager.hittable_component_unhit.emit()
			last_hittable_component = null
		
		if last_collider:
			var hittable_component := _get_hittable_component(last_collider)
			
			if hittable_component != last_hittable_component:
				# Make sure last_hittable_component is not null nor being freed
				if is_instance_valid(last_hittable_component):
					last_hittable_component.unregister_hit()
				
				last_hittable_component = hittable_component
				last_hittable_component.register_hit()
				
				var hit_event := EventsManager.HitEvent.new(last_hittable_component)
				EventsManager.hittable_component_hit.emit(hit_event)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _get_hittable_component(node : Node3D) -> HittableComponent:
	var component_path = node.get_meta("HittableComponentPath", null)
	assert(component_path)
	return node.get_node(component_path)
#endregion Private Methods
