class_name SceneTreeInspector extends TabContainer
## An interface that allows the user to inspect each element of the current scene
## tree (nodes, resources and sub-objects).

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## Minimum size for this interface.
const MINIMUM_SIZE : Vector2 = Vector2(320, 480)
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _scene_tree_list : SceneTreeList
var _object_methods_list : MethodsList
var _method_caller_interface : MethodInterface
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	custom_minimum_size = MINIMUM_SIZE
	theme = DebugUtil.get_editor_theme()
	tab_selected.connect(_on_tab_selected)
	
	_scene_tree_list = SceneTreeList.new()
	_scene_tree_list.show_methods_button_pressed.connect(_on_show_methods_button_pressed)
	_scene_tree_list.toggle_visibility_button_pressed.connect(_on_toggle_visibility_button_pressed)
	add_child(_scene_tree_list)
	
	_object_methods_list = MethodsList.new()
	_object_methods_list.method_selected.connect(_on_method_selected)
	add_child(_object_methods_list)
	
	_method_caller_interface = MethodInterface.new()
	add_child(_method_caller_interface)
	
	current_tab = _get_tab_index(_scene_tree_list)
	
	set_tab_title(_get_tab_index(_scene_tree_list), "")
	set_tab_icon(_get_tab_index(_scene_tree_list), DebugUtil.get_editor_global_icon("ClassList"))
	
	set_tab_title(_get_tab_index(_object_methods_list), "Methods List")
	
	set_tab_title(_get_tab_index(_method_caller_interface), "Method")
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_tab_selected(tab : int) -> void:
	if tab == _get_tab_index(_object_methods_list):
		_object_methods_list.update()
	elif tab == _get_tab_index(_method_caller_interface):
		_method_caller_interface.update()

func _on_show_methods_button_pressed(node : Node) -> void:
	_object_methods_list.object = node
	
	current_tab = _get_tab_index(_object_methods_list)

func _on_toggle_visibility_button_pressed(node : Node) -> void:
	node.visible = not node.visible

func _on_method_selected(object : Object, method : Dictionary) -> void:
	_method_caller_interface.object = object
	_method_caller_interface.method = method
	
	current_tab = _get_tab_index(_method_caller_interface)
#endregion Callbacks
func _get_tab_index(control : Control) -> int:
	const MAX_DEPTH : int = 4
	
	var tab_node : Control = control
	var depth : int = 0
	
	while tab_node.get_parent() != self and depth < MAX_DEPTH:
		depth += 1
		tab_node = tab_node.get_parent()
	
	return tab_node.get_index()
#endregion Private Methods
