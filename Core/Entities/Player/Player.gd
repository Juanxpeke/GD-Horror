class_name Player
extends CharacterBody3D
## A player.

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## Gravity applied to the player.
const BASE_MOVEMENT_SPEED : float = 12.0
const MAXIMUM_MOVEMENT_SPEED : float = 5.0
const CAMERA_HORIZONTAL_ROTATION_SPEED : float = 0.005
const CAMERA_VERTICAL_ROTATION_SPEED : float = 0.002
const FRICTION_VALUE : float = 0.30

#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _gravity : float = 0.0
var picked_object : RigidBody3D
#endregion Private Variables

#region On Ready Variables
@onready var head_pivot : Node3D = %HeadPivot
@onready var interaction : Interaction = %Interaction
@onready var hand : Marker3D = %Hand
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	PhysicsManager.player_hand = hand
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# TODO: Move this logic to a PhysicsManager class.
	_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta : float) -> void:
	var movement : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")

	movement *= delta * BASE_MOVEMENT_SPEED

	var forward := transform.basis.z
	var right := transform.basis.x

	movement = Vector2(forward.x, forward.z) * movement.y + Vector2(right.x, right.z) * movement.x

	var velocity_xz = Vector2(velocity.x, velocity.z)
	
	if not movement.is_zero_approx():
		velocity += Vector3(movement.x, 0, movement.y)
	else:
		velocity_xz -= velocity_xz * FRICTION_VALUE
		velocity = Vector3(velocity_xz.x, velocity.y, velocity_xz.y)
	
	if velocity_xz.length() > MAXIMUM_MOVEMENT_SPEED:
		velocity_xz = velocity_xz.normalized() * MAXIMUM_MOVEMENT_SPEED
		velocity = Vector3(velocity_xz.x, velocity.y, velocity_xz.y)
	
	velocity.y -= _gravity * delta

	move_and_slide()
	
	# Moving picked item
	if picked_object != null:
		if picked_object.has_method("pick_item"):
			picked_object.pick_item()
		else:
			print("not picked")
			
func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var horizontal_plane_rotation : float = event.relative.x * CAMERA_HORIZONTAL_ROTATION_SPEED * -1
		var vertical_plane_rotation : float = event.relative.y * CAMERA_VERTICAL_ROTATION_SPEED * -1
		
		rotate_y(horizontal_plane_rotation)
		head_pivot.rotate_x(vertical_plane_rotation)
	
	if Input.is_action_just_pressed("pick_item") and interaction.last_collider is PickableComponent:
		print("input picked item")
		picked_object = interaction.last_collider
	elif Input.is_action_just_pressed("pick_item"):
		print("input drop item")
		picked_object = null		
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
