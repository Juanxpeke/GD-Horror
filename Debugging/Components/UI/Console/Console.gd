class_name Console extends PanelContainer
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const MINIMUM_SIZE : Vector2 = Vector2(640, 180)
#endregion Constants

#region Exports Variables
## TODO
@export var transparent : bool = false:
	set(new_transparent):
		transparent = new_transparent
		_update()
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _log : RichTextLabel
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	custom_minimum_size = MINIMUM_SIZE
	theme = DebugUtil.get_editor_theme()
	add_theme_stylebox_override("panel", get_theme_stylebox("DefaultPanel", "EditorStyles"))
	
	var vb := VBoxContainer.new();
	vb.set_custom_minimum_size(Vector2(0, 180));
	vb.set_v_size_flags(SIZE_EXPAND_FILL);
	vb.set_h_size_flags(SIZE_EXPAND_FILL);
	add_child(vb);
	
	_log = RichTextLabel.new()
	_log.bbcode_enabled = true
	_log.scroll_following = true
	_log.selection_enabled = true
	_log.context_menu_enabled = true
	_log.focus_mode = Control.FOCUS_CLICK
	_log.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_log.deselect_on_focus_loss_enabled = true
	
	_log.add_theme_font_override("normal_font", DebugUtil.get_editor_output_source_font())
	
	var font_size : int = DebugUtil.get_editor_output_source_font_size()
	_log.begin_bulk_theme_override();
	_log.add_theme_font_size_override("normal_font_size", font_size);
	_log.add_theme_font_size_override("bold_font_size", font_size);
	_log.add_theme_font_size_override("italics_font_size", font_size);
	_log.add_theme_font_size_override("mono_font_size", font_size);
	_log.end_bulk_theme_override();
	
	vb.add_child(_log)

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
		_log.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	else:
		self_modulate = Color.WHITE
		if _log.has_theme_stylebox_override("normal"):
			_log.remove_theme_stylebox_override("normal")

func _push_line(content : String) -> void:
	_log.append_text(content)
	_log.newline()
#endregion Private Methods
