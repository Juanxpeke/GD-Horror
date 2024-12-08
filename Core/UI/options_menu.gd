extends Control
## Docstring

#region Signals
#endregion Signals

#region Enums

#endregion Enums

#region Constants
const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Window Mode",
	"Borderless Window",
	"Borderless Full-Screen"
]

const RESOLUTION_DICTIONARY: Dictionary = {
	"640 x 480" : Vector2(640, 480),  # VGA
	"800 x 600" : Vector2(800, 600),  # SVGA
	"1024 x 768" : Vector2(1024, 768),  # XGA
	"1280 x 720" : Vector2(1280, 720),  # HD (720p)
	"1366 x 768" : Vector2(1366, 768),  # HD+
	"1440 x 900" : Vector2(1440, 900),  # WXGA+
	"1600 x 900" : Vector2(1600, 900),  # HD+ (Wide)
	"1920 x 1080" : Vector2(1920, 1080),  # Full HD (1080p)
	#"2560 x 1440" : Vector2(2560, 1440),  # QHD (1440p)	
	#"3840 x 2160" : Vector2(3840, 2160),  # 4K UHD
	#"7680 x 4320" : Vector2(7680, 4320),  # 8K UHD
}

#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var window_mode_button = $"%WindowOptions" as OptionButton
@onready var window_resolution_button = $"%ResolutionOptions" as OptionButton
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:	
	window_mode_button.item_selected.connect(on_change_window_mode)
	
	for resolution_size in RESOLUTION_DICTIONARY:
		window_resolution_button.add_item(resolution_size)
		
	window_resolution_button.item_selected.connect(on_change_resolution)
	

func _process(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func on_change_window_mode(index : int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Borderless Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			
func on_change_resolution(index : int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	center_window()

func center_window() -> void:
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)
#endregion Private Methods
