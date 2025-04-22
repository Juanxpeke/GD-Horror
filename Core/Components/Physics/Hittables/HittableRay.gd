class_name HittableRayCast extends RayCast3D
## TODO

#region Signals
## TODO
signal hit_registered(hittable_component : HittableComponent)
## TODO
signal hit_unregistered
## TODO
signal pick_registered
## TODO
signal pick_unregistered
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
## TODO. Do not modify this variable.
var last_collider : CollisionObject3D = null
## TODO. Do not modify this variable.
var last_hittable_component : HittableComponent = null:
	set(new_last_hittable_component):
		last_hittable_component = new_last_hittable_component
		if last_hittable_component:
			hit_registered.emit(last_hittable_component)
		else:
			hit_unregistered.emit()
#endregion Public Variables

#region Private Variables
var _picking : bool:
	set(new_picking):
		_picking = new_picking
		if _picking:
			pick_registered.emit()
		else:
			pick_unregistered.emit()
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _physics_process(_delta : float) -> void:
	last_collider = get_collider()
	
	if not _picking:
		_update_last_hittable_component()
	else:
		if not is_instance_valid(last_hittable_component):
			_picking = false
			return # WARNING: There should be a last hittable component
		last_hittable_component.register_picking_process(_delta, _unpick_last_hittable_component)

func _input(event: InputEvent) -> void:
	if not is_instance_valid(last_hittable_component):
		return
	
	if last_hittable_component.interactable and event.is_action_pressed("interact"):
		last_hittable_component.register_interaction()
	
	if not _picking and last_hittable_component.pickable and event.is_action_pressed("pick_item"):
		_pick_last_hittable_component()
	
	# Safer in case pickable is set to false but still being picked
	if last_hittable_component.being_picked and event.is_action_released("pick_item"):
		_unpick_last_hittable_component()

#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _update_last_hittable_component() -> void:
		if not last_collider:
			# Make sure last_hittable_component is not null nor being freed before unregistering hit
			if is_instance_valid(last_hittable_component):
				last_hittable_component.unregister_hit()
			# If last_hittable_component is not null, set to null
			if last_hittable_component:
				last_hittable_component = null
		else:
			var hittable_component := _get_hittable_component(last_collider)
			
			if hittable_component != last_hittable_component:
				# Make sure last_hittable_component is not null nor being freed before unregistering hit
				if is_instance_valid(last_hittable_component):
					last_hittable_component.unregister_hit()
				
				last_hittable_component = hittable_component
				last_hittable_component.register_hit()

func _pick_last_hittable_component() -> void:
	_picking = true
	last_hittable_component.register_pick()

func _unpick_last_hittable_component() -> void:
	_picking = false
	last_hittable_component.unregister_pick()

func _get_hittable_component(node : Node3D) -> HittableComponent:
	if node.has_meta("JuanxpHittableComponentPath"):
		var component_path = node.get_meta("JuanxpHittableComponentPath", null)
		return node.get_node(component_path)
	else:
		return null
#endregion Private Methods
