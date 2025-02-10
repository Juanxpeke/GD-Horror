class_name ChocolateBar
extends RigidBody3D
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
@onready var _hittable_component : HittableComponent = %HittableComponent
@onready var _consumable_component : ConsumableComponent = %ConsumableComponent
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_consumable_component.consumption_food_points  = GameParametersManager.CHOCOLATE_BAR_FOOD_POINTS
	_consumable_component.consumption_drink_points = GameParametersManager.CHOCOLATE_BAR_DRINK_POINTS
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
