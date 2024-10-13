class_name HittableComponent extends Node
## Docstring

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
var is_hitted : bool = false
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var highlight_material = preload("res://Core/Components/highlight_material.tres")
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	collision_object.collision_layer |= PhysicsManager.CollisionLayer.CAMERA_RAY;

func _process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
func register_hit() -> void:
	focused.emit()
	is_hitted = true
	if mesh:
		mesh.material_overlay = highlight_material
	print("register_hit")
	
func unregister_hit() -> void:
	unfocused.emit()
	is_hitted = false
	if mesh:
		mesh.material_overlay = null
	print("unregister_hit")
#endregion Public Methods

#region Private Methods
#endregion Private Methods
