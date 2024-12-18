class_name HittableComponent extends Node
## A component that can be hit by the [Player] camera ray.

#region Signals
## TODO
signal focused
## TODO
signal unfocused
## TODO
signal interacted
## TODO
signal picked
## TODO
signal unpicked
#endregion Signals

#region Enums
#endregion Enums

#region Constants
const PICKING_DRAG_SPEED : float = 30.0
#endregion Constants

#region Exports Variables
## TODO
@export var collision_object : CollisionObject3D
## TODO
@export var mesh : MeshInstance3D
## TODO
@export var interactable : bool = false
## TODO
@export var pickable : bool = false
#endregion Exports Variables

#region Static Variables
## TODO
static var picking : bool = false
#endregion Static Variables

#region Public Variables
## TODO
var being_hit : bool = false
## TODO
var being_picked : bool = false
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var highlight_material : Material = preload("res://Core/Components/HighlightMaterial.tres")
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_assert_collision_object_state()
	collision_object.collision_layer |= PhysicsManager.CollisionLayer.CAMERA_RAY
	collision_object.set_meta("HittableComponentPath", collision_object.get_path_to(self, true))

func _physics_process(delta : float) -> void:
	if being_picked:
		var a = collision_object.global_transform.origin
		var b = GameManager.player_hand.global_transform.origin
		collision_object.set_linear_velocity((b-a) * PICKING_DRAG_SPEED)

func _input(event: InputEvent) -> void:
	if being_hit:
		if interactable and event.is_action_pressed("interact"):
			interacted.emit()
		
		if pickable and not picking and event.is_action_pressed("pick_item"):
			picked.emit()
			picking = true
			being_picked = true
			
			collision_object.lock_rotation = true
			mesh.material_overlay = null
			
	if being_picked and event.is_action_released("pick_item"):
		unpicked.emit()
		being_picked = false
		picking = false
		
		collision_object.lock_rotation = false
		
		if being_hit:
			mesh.material_overlay = highlight_material
		
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func register_hit() -> void:
	focused.emit()
	being_hit = true
	if mesh:
		mesh.material_overlay = highlight_material
	LogManager.physics_log("HittableComponent hit registered")

## TODO
func unregister_hit() -> void:
	unfocused.emit()
	being_hit = false
	if mesh:
		mesh.material_overlay = null
	LogManager.physics_log("HittableComponent hit unregistered")
#endregion Public Methods

#region Private Methods
func _assert_collision_object_state() -> void:
	assert(collision_object)
	assert(not (collision_object.collision_layer & PhysicsManager.CollisionLayer.CAMERA_RAY))
	assert(not pickable or collision_object is RigidBody3D)
#endregion Private Methods
