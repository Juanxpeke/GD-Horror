class_name LogInterfaceComponent extends Control
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
## TODO
@export var lines : int = 6:
	set(new_lines):
		lines = new_lines
		if is_inside_tree():
			_update()
## TODO
@export var line_scene : PackedScene
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _lines_list      : Control = %LinesList
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_update()
	
	LogManager.rendering_log_issued.connect(_on_rendering_log_issued)
	LogManager.physics_log_issued.connect(_on_physics_log_issued)
	LogManager.audio_log_issued.connect(_on_audio_log_issued)
	LogManager.debugging_log_issued.connect(_on_debugging_log_issued)
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

func _on_debugging_log_issued(message : String) -> void:
	var content := "[color=%s](Debugging) %s[/color]" % [LogManager.debugging_color, message]
	_push_line(content)
#endregion Callbacks
func _update() -> void:
	if transparent:
		self_modulate = Color.TRANSPARENT
	else:
		self_modulate = Color.WHITE
		
	while _lines_list.get_child_count() < lines:
		var new_line : RichTextLabel = line_scene.instantiate()
		new_line.add_theme_font_override("normal_font", DebugManager.get_editor_output_source_font())
		new_line.add_theme_font_size_override("normal_font_size", DebugManager.get_editor_output_source_font_size())
		new_line.text = ""
		_lines_list.add_child(new_line)
		_lines_list.move_child(new_line, -1)
	
	while _lines_list.get_child_count() > lines:
		var death_line := _lines_list.get_child(0)
		_lines_list.remove_child(death_line)
		death_line.queue_free()

func _push_line(content : String) -> void:
	for line_index in range(_lines_list.get_child_count()):
		var line : RichTextLabel = _lines_list.get_child(line_index)
		if line_index < _lines_list.get_child_count() - 1:
			var bottom_line : RichTextLabel = _lines_list.get_child(line_index + 1)
			line.text = bottom_line.text
		else:
			line.text = content
#endregion Private Methods
