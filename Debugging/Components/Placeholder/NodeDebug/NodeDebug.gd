class_name NodeDebug extends Node
## Im just a debug node.

#region Signals
#endregion Signals

#region Enums
## Im just a debug node.
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
	LogManager.debugging_log("Debug node %s entered the tree!" % name)

func _ready() -> void:
	LogManager.debugging_log("Debug node %s ready!" % name)
#endregion Built-in Virtual Methods

#region Public Methods
## Im just a debug node.
func method(what_if : bool, action : String,  n_times : int = 0) -> void:
	if what_if:
		LogManager.debugging_log("We did %s %d times" % [action, n_times]) # TODO
	else:
		LogManager.debugging_log("We didn't %s %d times" % [action, n_times]) # TODO
## Im just a debug node.
func enum_method(e : DebugEnum) -> void:
	LogManager.debugging_log(str(e))
## Im just a debug node.
func array_method(arr : Array, typed_arr : Array[bool]) -> void:
	LogManager.debugging_log(str(arr) + "-" + str(typed_arr))
## Im just a debug node.
func rename_method(new_name : String) -> void:
	name = new_name
## Im just a debug node.
func add_children_method() -> void:
	var first_child := NodeDebug.new()
	first_child.name = "FirstChild"
	var second_child := NodeDebug.new()
	second_child.name = "SecondChild"
	var grandchild := NodeDebug.new()
	grandchild.name = "Grandchild"
	
	first_child.add_child(grandchild)
	add_child(first_child)
	add_child(second_child)
## Im just a debug node.
func replace_by_method() -> void:
	var replacement := NodeDebug.new()
	replacement.name = "Replacement"
	replace_by(replacement)
#endregion Public Methods

#region Private Methods
#endregion Private Methods
