class_name PerformanceInterfaceComponent extends Control
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
@onready var _device_label : Label = %DeviceLabel
@onready var _fps_label : Label = %FPSLabel
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_device_label.text = RenderingServer.get_rendering_device().get_device_name()

func _process(delta : float) -> void:
	_fps_label.text = str(Engine.get_frames_per_second())
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
