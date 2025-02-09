class_name CameraPanelComponent extends Control
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var cameras : Array[Camera3D]
## TODO
@export var duplicate_cameras : bool = true
## TODO
@export var current_camera_index : int = 0
## TODO
@export var switch_camera_key : Key = KEY_TAB
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _sub_viewport : SubViewport = %SubViewport
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	if not cameras.is_empty():
		assert(current_camera_index < cameras.size())
		
		if duplicate_cameras:
			for camera : Camera3D in cameras:
				var sub_viewport_camera : Camera3D= camera.duplicate()
				_sub_viewport.add_child(sub_viewport_camera)
				
			var current_camera : Camera3D = _sub_viewport.get_child(current_camera_index)
			current_camera.current = true
		else:
			_reparent_cameras.call_deferred()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == switch_camera_key and event.is_pressed():
		var previous_camera : Camera3D = _sub_viewport.get_child(current_camera_index)
		previous_camera.current = false
		
		current_camera_index = (current_camera_index + 1) % _sub_viewport.get_child_count()
		
		var current_camera : Camera3D = _sub_viewport.get_child(current_camera_index)
		current_camera.current = true
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _reparent_cameras() -> void:
	for camera : Camera3D in cameras:
		camera.reparent(_sub_viewport)
	
	var current_camera : Camera3D = _sub_viewport.get_child(current_camera_index)
	current_camera.current = true
#endregion Private Methods
