extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
enum DrawLayer {
	## TODO
	DEFAULT,
	## TODO
	HUD,
	## TODO
	MENU,
	## TODO
	LOG,
}
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
	for node in get_tree().get_nodes_in_group("HUDLayer"):
		var canvas_layer : CanvasLayer = node as CanvasLayer
		canvas_layer.layer = DrawLayer.HUD
	for node in get_tree().get_nodes_in_group("MenuLayer"):
		var canvas_layer : CanvasLayer = node as CanvasLayer
		canvas_layer.layer = DrawLayer.MENU
	for node in get_tree().get_nodes_in_group("LogLayer"):
		var canvas_layer : CanvasLayer = node as CanvasLayer
		canvas_layer.layer = DrawLayer.LOG
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
