extends Node3D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
@export var mesh : MeshInstance3D
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var highlight_material = preload("res://Core/Components/highlight_material.tres")
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass

func _process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func in_range() -> void:
	print("in_range")
	mesh.material_overlay = highlight_material
	
func not_in_range() -> void:
	print("not_in_range")
	mesh.material_overlay = null
#endregion Private Methods
