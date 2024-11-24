extends Control
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
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	pass

func _process(delta : float) -> void:
	pass
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Core/Maps/World.tscn")
	
func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Core/UI/Options.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
