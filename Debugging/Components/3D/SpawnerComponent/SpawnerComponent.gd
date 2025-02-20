class_name SpawnerComponent extends Node3D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var scene : PackedScene = null
## TODO
@export var spawn_count : int = 1

@export_group("Auto Spawn")
## TODO
@export var auto_spawn : bool = false:
	set(new_auto_spawn):
		auto_spawn = new_auto_spawn
		if is_inside_tree():
			_update()
## TODO
@export var auto_spawn_cooldown : float = 1.0:
	set(new_auto_spawn_cooldown):
		auto_spawn_cooldown = new_auto_spawn_cooldown
		if is_inside_tree():
			_update()
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _auto_spawn_timer : Timer = %AutoSpawnTimer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_update()
	
	_auto_spawn_timer.timeout.connect(_on_auto_spawn_timer_timeout)
#endregion Built-in Virtual Methods

#region Public Methods
func spawn() -> void:
	if scene:
		for _i in range(spawn_count):
			var instance : Node3D = scene.instantiate()
			add_child(instance)
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_auto_spawn_timer_timeout() -> void:
	if auto_spawn:
		spawn()
#endregion Callbacks
func _update() -> void:
	_auto_spawn_timer.paused = not auto_spawn
	
	if auto_spawn:
		_auto_spawn_timer.start()
	
	_auto_spawn_timer.wait_time = auto_spawn_cooldown
#endregion Private Methods
