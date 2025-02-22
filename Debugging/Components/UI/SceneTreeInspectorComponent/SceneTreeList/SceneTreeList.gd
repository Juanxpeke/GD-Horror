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
const BANNED_NODE_NAMES : Dictionary = {
	"Dialogic": true,
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
	_update()
	
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)
	
	button_clicked.connect(_on_button_clicked)
	item_activated.connect(_on_item_activated)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_node_added(_node : Node) -> void:
	pass #_update()

func _on_node_removed(_node : Node) -> void:
	pass #_update()

func _on_button_clicked(item : TreeItem, _column : int, id : int, _mouse_button_index : int) -> void:
	var node : Node = item.get_metadata(0)
	
	match id:
		SceneTreeListButton.BUTTON_METHODS:
			show_methods_button_pressed.emit(node)
		SceneTreeListButton.BUTTON_VISIBILITY:
			toggle_visibility_button_pressed.emit(node)

func _on_item_activated() -> void:
	var item : TreeItem = get_selected()
	item.collapsed = not item.collapsed
#endregion Callbacks
#region Nodes Callbacks
func _node_child_entered_tree_callback(child : Node, node : Node) -> void:
	if node.has_meta(DebugManager.NODE_SCENE_TREE_ITEM):
		var tree_item : TreeItem = node.get_meta(DebugManager.NODE_SCENE_TREE_ITEM)
		
		if tree_item:
			if not child.has_meta(DebugManager.NODE_SCENE_TREE_ITEM):
				_create_items_from_node(child, tree_item)

func _node_renamed_callback(node : Node) -> void:
	if node.has_meta(DebugManager.NODE_SCENE_TREE_ITEM):
		var tree_item : TreeItem = node.get_meta(DebugManager.NODE_SCENE_TREE_ITEM)
		
		if tree_item:
			tree_item.set_text(0, node.name)

func _node_tree_exiting_callback(node : Node) -> void:
	if node.has_meta(DebugManager.NODE_SCENE_TREE_ITEM):
		var tree_item : TreeItem = node.get_meta(DebugManager.NODE_SCENE_TREE_ITEM)
		
		if tree_item:
			tree_item.free() # NOTE: From TreeItem docs

func _node_visibility_changed_callback(node : Node) -> void:
	if node.has_meta(DebugManager.NODE_SCENE_TREE_ITEM):
		var tree_item : TreeItem = node.get_meta(DebugManager.NODE_SCENE_TREE_ITEM)
		
		if tree_item:
			if node.call("is_visible"):
				tree_item.set_button(0, SceneTreeListButton.BUTTON_VISIBILITY, DebugManager.get_editor_class_icon("GuiVisibilityVisible"))
			else:
				tree_item.set_button(0, SceneTreeListButton.BUTTON_VISIBILITY, DebugManager.get_editor_class_icon("GuiVisibilityHidden"))
#endregion Nodes Callbacks

func _update() -> void:
	clear()

	_create_items_from_node(get_tree().root)

func _create_items_from_node(node : Node, parent : TreeItem = null) -> void:
	if BANNED_NODE_NAMES.has(node.name):
		return
	
	var tree_item := create_item(parent)
	tree_item.set_text(0, node.name)
	tree_item.set_icon(0, DebugManager.get_editor_class_icon(node.get_class()))

	tree_item.set_metadata(0, node)
	
	tree_item.add_button(0, DebugManager.get_editor_class_icon("MemberMethod"), SceneTreeListButton.BUTTON_METHODS, false, "Show Methods")
	
	if not node.is_connected("child_entered_tree", _node_child_entered_tree_callback.bind(node)):
		node.connect("child_entered_tree", _node_child_entered_tree_callback.bind(node))
	
	if not node.is_connected("renamed", _node_renamed_callback.bind(node)):
		node.connect("renamed", _node_renamed_callback.bind(node))
	
	if not node.is_connected("tree_exiting", _node_tree_exiting_callback.bind(node)):
		node.connect("tree_exiting", _node_tree_exiting_callback.bind(node))
	
	if node.has_method("is_visible") and node.has_method("set_visible") and node.has_signal("visibility_changed") and node != get_tree().root:
		if node.call("is_visible"):
			tree_item.add_button(0, DebugManager.get_editor_class_icon("GuiVisibilityVisible"), SceneTreeListButton.BUTTON_VISIBILITY, false, "Toggle Visibility")
		else:
			tree_item.add_button(0, DebugManager.get_editor_class_icon("GuiVisibilityHidden"), SceneTreeListButton.BUTTON_VISIBILITY, false, "Toggle Visibility")
		
		if not node.is_connected("visibility_changed", _node_visibility_changed_callback.bind(node)):
			node.connect("visibility_changed", _node_visibility_changed_callback.bind(node))
		
	node.set_meta(DebugManager.NODE_SCENE_TREE_ITEM, tree_item)
	
	for child_node in node.get_children():
		_create_items_from_node(child_node, tree_item)
	
	if parent != null:
		tree_item.collapsed = true
#endregion Private Methods
