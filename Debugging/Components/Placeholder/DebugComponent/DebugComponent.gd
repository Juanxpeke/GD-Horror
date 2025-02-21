class_name DebugComponent extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
## TODO
enum DebugEnum {
	## TODO
	FIRST,
	## TODO
	SECOND
}
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
func _enter_tree() -> void:
	is_inside_tree()
	LogManager.debugging_log("Debug component %s entered the tree!" % name)

func _ready() -> void:
	LogManager.debugging_log("Debug component %s ready!" % name)
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func method(what_if : bool, action : String,  n_times : int = 0) -> void:
	if what_if:
		LogManager.debugging_log("We did %s %d times" % [action, n_times]) # TODO
	else:
		LogManager.debugging_log("We didn't %s %d times" % [action, n_times]) # TODO
## TODO
func enum_method(e : DebugEnum) -> void:
	LogManager.debugging_log(str(e))
## TODO
func array_method(arr : Array, typed_arr : Array[bool]) -> void:
	LogManager.debugging_log(str(arr) + "-" + str(typed_arr))
## TODO
func add_children_method() -> void:
	var first_child := DebugComponent.new()
	first_child.name = "FirstChild"
	var second_child := DebugComponent.new()
	second_child.name = "SecondChild"
	var grandchild := DebugComponent.new()
	grandchild.name = "Grandchild"
	
	first_child.add_child(grandchild)
	add_child(first_child)
	add_child(second_child)
## TODO
func rename_method(new_name : String) -> void:
	name = new_name
#endregion Public Methods

#region Private Methods
#endregion Private Methods
