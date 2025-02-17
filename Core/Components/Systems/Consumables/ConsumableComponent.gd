class_name ConsumableComponent extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var hittable_component : HittableComponent
## TODO
@export var consumption_food_points : int = 0
## TODO
@export var consumption_drink_points : int = 0
## TODO
@export var consumed_stages : Array[ConsumedStage] = []
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _consumptions_counter : int = 0
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_assert_parameters()
	
	hittable_component.interaction_name = "Consume"
	
	hittable_component.interacted.connect(_on_interacted)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Assertions
func _assert_parameters() -> void:
	_assert_collision_object_parameters()
	_assert_consumed_stages_parameters()

func _assert_collision_object_parameters() -> void:
	# NOTE: At the moment, we assume collision_object only has one shape owner with one shape
	assert(hittable_component.collision_object.get_shape_owners().size() == 1)
	assert(hittable_component.collision_object.shape_owner_get_shape_count(0) == 1)

func _assert_consumed_stages_parameters() -> void:
	for stage in consumed_stages:
		assert(stage.mesh)
		assert(stage.shape)
#endregion Assertions
#region Callbacks
func _on_interacted() -> void:
	assert(_consumptions_counter < consumed_stages.size() + 1)
	
	if _consumptions_counter < consumed_stages.size():
		var mesh_instance : MeshInstance3D = hittable_component.mesh_instance
		mesh_instance.mesh = consumed_stages[_consumptions_counter].mesh
		
		var collision_shape : CollisionShape3D = hittable_component.collision_object.shape_owner_get_owner(0)
		collision_shape.shape = consumed_stages[_consumptions_counter].shape
	
	_consumptions_counter += 1
	
	if _consumptions_counter == consumed_stages.size() + 1:
		owner.queue_free()
	
	var consumption_event := EventsManager.ConsumptionEvent.new(self)
	EventsManager.item_consumed.emit(consumption_event)
#endregion Callbacks
#endregion Private Methods
