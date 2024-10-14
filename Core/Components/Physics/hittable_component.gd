class_name HittableComponent extends Node
## A component that can be hit by the [Player] camera ray.

#region Signals
signal focused
signal unfocused
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
@export var collision_object : CollisionObject3D
@export var mesh : MeshInstance3D
#endregion Exports Variables

#region Public Variables
var is_hitted : bool = false # TODO: Change it to is_hit
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var highlight_material : Material = preload("res://Core/Components/highlight_material.tres")
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_assert_collision_object_state()
	collision_object.collision_layer |= PhysicsManager.CollisionLayer.CAMERA_RAY
	collision_object.set_meta("HittableComponentPath", collision_object.get_path_to(self, true))

func _process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
func register_hit() -> void:
	focused.emit()
	is_hitted = true
	if mesh:
		mesh.material_overlay = highlight_material
	LogManager.physics_log("HittableComponent hit registered")
	
func unregister_hit() -> void:
	unfocused.emit()
	is_hitted = false
	if mesh:
		mesh.material_overlay = null
	LogManager.physics_log("HittableComponent hit unregistered")
#endregion Public Methods

#region Private Methods
func _assert_collision_object_state() -> void:
	assert(collision_object)
	assert(not (collision_object.collision_layer & PhysicsManager.CollisionLayer.CAMERA_RAY))
#endregion Private Methods
