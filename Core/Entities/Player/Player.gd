class_name Player
extends CharacterBody3D
## A player.

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const BASE_MOVEMENT_SPEED : float = 250.0
## TODO
const MAXIMUM_MOVEMENT_SPEED : float = 5.0
## TODO
const CAMERA_HORIZONTAL_ROTATION_SPEED : float = 0.005
## TODO
const CAMERA_VERTICAL_ROTATION_SPEED : float = 0.002
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var head_pivot : Node3D = %HeadPivot
@onready var interaction : Interaction = %Interaction
@onready var hand : Marker3D = %Hand
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	GameManager.player_hand = hand

func _physics_process(delta : float) -> void:
	var movement : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")

	movement *= delta * BASE_MOVEMENT_SPEED

	var forward := transform.basis.z
	var right := transform.basis.x

	movement = Vector2(forward.x, forward.z) * movement.y + Vector2(right.x, right.z) * movement.x

	velocity = Vector3(movement.x, 0, movement.y)
	
	velocity.y -= PhysicsManager.gravity * delta

	move_and_slide()

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var horizontal_plane_rotation : float = event.relative.x * CAMERA_HORIZONTAL_ROTATION_SPEED * -1
		var vertical_plane_rotation : float = event.relative.y * CAMERA_VERTICAL_ROTATION_SPEED * -1
		
		rotate_y(horizontal_plane_rotation)
		head_pivot.rotate_x(vertical_plane_rotation)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
