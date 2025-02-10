class_name ConsumableComponent
extends Node
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
@export var max_consumptions : int = 1
## TODO
@export var consumed_meshes : Array[Mesh]
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
	max_consumptions = max(max_consumptions, consumed_meshes.size() + 1)
	
	hittable_component.interacted.connect(_on_interacted)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_interacted() -> void:
	assert(_consumptions_counter < max_consumptions)
	
	EventsManager.item_consumed.emit(consumption_food_points, consumption_drink_points)
	
	if _consumptions_counter < consumed_meshes.size():
		hittable_component.mesh_instance.mesh = consumed_meshes[_consumptions_counter]
	
	_consumptions_counter += 1
	
	if _consumptions_counter == max_consumptions:
		owner.queue_free()
#endregion Private Methods
