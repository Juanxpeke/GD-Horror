class_name HUD extends CanvasLayer
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
@onready var _interaction_label : Label = %InteractionLabel
@onready var _picking_label     : Label = %PickingLabel
#endregion On Ready Variables

#region Built-in Virtual Methods
func _enter_tree() -> void:
	EventsManager.hittable_component_hit.connect(_on_hittable_component_hit)
	EventsManager.hittable_component_unhit.connect(_on_hittable_component_unhit)
	EventsManager.hittable_component_picked.connect(_on_hittable_component_picked)
	EventsManager.hittable_component_unpicked.connect(_on_hittable_component_unpicked)

func _ready() -> void:
	_interaction_label.visible = false
	_picking_label.visible = false
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_hittable_component_hit(hit_event : EventsManager.HitEvent) -> void:
	if hit_event.interactable:
		_interaction_label.visible = true
		_interaction_label.text = hit_event.interaction_name
	else:
		_interaction_label.visible = false
	
	if hit_event.pickable:
		_picking_label.visible = true
	else:
		_picking_label.visible = false

func _on_hittable_component_unhit() -> void:
	_interaction_label.visible = false
	_picking_label.visible = false

func _on_hittable_component_picked() -> void:
	_picking_label.visible = false

func _on_hittable_component_unpicked() -> void:
	_picking_label.visible = true
#endregion Callbacks
#endregion Private Methods
