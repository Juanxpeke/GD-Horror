class_name SceneTreeList extends Tree
## Docstring

#region Signals
## TODO
signal show_methods_button_pressed(node : Node)
## TODO
signal toggle_visibility_button_pressed(node : Node)
#endregion Signals

#region Enums
enum SceneTreeListButton {
	BUTTON_METHODS,
	BUTTON_VISIBILITY,
};
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
	_update()
	
	button_clicked.connect(_on_button_clicked)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_button_clicked(item : TreeItem, column : int, id : int, mouse_button_index : int) -> void:
	var node : Node = item.get_metadata(0)
	
	match id:
		SceneTreeListButton.BUTTON_METHODS:
			show_methods_button_pressed.emit(node)
		SceneTreeListButton.BUTTON_VISIBILITY:
			toggle_visibility_button_pressed.emit(node)
#endregion Callbacks

func _update() -> void:
	clear()

	_create_items_from_node(get_tree().root)

func _create_items_from_node(node : Node, parent : TreeItem = null) -> void:
	var tree_item := create_item(parent)
	tree_item.set_text(0, node.name)
	tree_item.set_icon(0, DebugManager.get_editor_class_icon(node.get_class()))

	tree_item.set_metadata(0, node)
	
	tree_item.add_button(0, DebugManager.get_editor_class_icon("MemberMethod"), SceneTreeListButton.BUTTON_METHODS, false, "Show Methods")
	
	var node_visible : bool = false;
	
	if node.has_method("is_visible") and node.has_method("set_visible") and node.has_signal("visibility_changed") and node != get_tree().root:
		if node.is_visible():
			tree_item.add_button(0, DebugManager.get_editor_class_icon("GuiVisibilityVisible"), SceneTreeListButton.BUTTON_VISIBILITY, false, "Toggle Visibility")
		else:
			tree_item.add_button(0, DebugManager.get_editor_class_icon("GuiVisibilityHidden"), SceneTreeListButton.BUTTON_VISIBILITY, false, "Toggle Visibility")
		
		var visibility_changed_callback = func():
			if node.is_visible():
				tree_item.set_button(0, SceneTreeListButton.BUTTON_VISIBILITY, DebugManager.get_editor_class_icon("GuiVisibilityVisible"))
			else:
				tree_item.set_button(0, SceneTreeListButton.BUTTON_VISIBILITY, DebugManager.get_editor_class_icon("GuiVisibilityHidden"))
	
		if not node.is_connected("visibility_changed", visibility_changed_callback):
			node.connect("visibility_changed", visibility_changed_callback)
	
	for child_node in node.get_children():
		_create_items_from_node(child_node, tree_item)
	
	if parent != null:
		tree_item.collapsed = true
#endregion Private Methods
