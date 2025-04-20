extends Node
## Manager of global signals.

#region Signals
#region Hittables
## Emitted when a [HittableComponent] is hit.
signal hittable_component_hit(hit_event : HitEvent)
## Emitted when a [HittableComponent] is unhit.
signal hittable_component_unhit
## Emitted when a [HittableComponent] is picked.
signal hittable_component_picked
## Emitted when a [HittableComponent] is unpicked.
signal hittable_component_unpicked
#endregion Hittables
#region Consumables
## Emitted when a [ConsumableComponent] is consumed.
signal item_consumed(consumption_event : ConsumptionEvent)
#endregion Consumables
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
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods

#region Inner Classes
class HitEvent:
	var interactable     : bool   = false
	var interaction_name : String = ""
	var pickable         : bool   = false
	
	func _init(hittable_component : HittableComponent) -> void:
		interactable = hittable_component.interactable
		interaction_name = hittable_component.interaction_name
		pickable = hittable_component.pickable

class ConsumptionEvent:
	var food_points  : int = 0
	var drink_points : int = 0
	
	func _init(consumable_component : ConsumableComponent) -> void:
		food_points = consumable_component.consumption_food_points
		drink_points = consumable_component.consumption_drink_points
#endregion Inner Classes
