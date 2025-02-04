@tool
class_name LogInterfaceComponent
extends CanvasLayer
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var transparent : bool = true:
	set(new_transparent):
		transparent = new_transparent
		if is_inside_tree():
			_update()
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _lines_container : Control = %LinesContainer
@onready var _lines_arranger  : Control = %LinesArranger
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_ready_base()
	
	if Engine.is_editor_hint():
		_ready_editor()
	else:
		_ready_game()

func _ready_base() -> void:
	_update()

func _ready_editor() -> void:
	pass

func _ready_game() -> void:
	LogManager.rendering_log_issued.connect(_on_rendering_log_issued)
	LogManager.physics_log_issued.connect(_on_physics_log_issued)
	LogManager.audio_log_issued.connect(_on_audio_log_issued)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_rendering_log_issued(message : String) -> void:
	var content := "[color=%s](Rendering) %s[/color]" % [LogManager.rendering_color, message]
	_push_line(content)

func _on_physics_log_issued(message : String) -> void:
	var content := "[color=%s](Physics) %s[/color]" % [LogManager.physics_color, message]
	_push_line(content)

func _on_audio_log_issued(message : String) -> void:
	var content := "[color=%s](Audio) %s[/color]" % [LogManager.audio_color, message]
	_push_line(content)
#endregion Callbacks
func _update() -> void:
	if transparent:
		_lines_container.self_modulate = Color.TRANSPARENT
	else:
		_lines_container.self_modulate = Color.WHITE

func _push_line(content : String) -> void:
	for line_index in range(_lines_arranger.get_child_count()):
		var line : RichTextLabel = _lines_arranger.get_child(line_index)
		if line_index < _lines_arranger.get_child_count() - 1:
			var bottom_line : RichTextLabel = _lines_arranger.get_child(line_index + 1)
			line.text = bottom_line.text
		else:
			line.text = content
#endregion Private Methods
