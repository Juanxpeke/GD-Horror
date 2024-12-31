class_name Player extends CharacterBody3D
## A player.

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const MOVEMENT_SPEED : float = 4.0
## TODO
const HEAD_HORIZONTAL_ROTATION_SPEED : float = 0.003
## TODO
const HEAD_VERTICAL_ROTATION_SPEED   : float = 0.002
## TODO
const MAXIMUM_HEAD_HORIZONTAL_DELTA_ROTATION : float = 0.25
## TODO
const MAXIMUM_HEAD_VERTICAL_DELTA_ROTATION   : float = 0.25
## TODO
const MAXIMUM_HEAD_VERTICAL_ROTATION         : float = deg_to_rad(72)
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
## TODO
var hunger : float = 100.0:
	set(new_hunger):
		hunger = clamp(new_hunger, 0, 100.0)
## TODO
var thirst : float = 100.0:
	set(new_thirst):
		thirst = clamp(new_thirst, 0, 100.0)
## TODO
var oxygen : float = 100.0:
	set(new_oxygen):
		oxygen = clamp(new_oxygen, 0, 100.0)
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var head_pivot : Node3D = %HeadPivot
@onready var hand : Marker3D = %Hand
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	GameManager.player = self
	GameManager.player_hand = hand

func _physics_process(delta : float) -> void:
	var input_direction : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")

	var forward := transform.basis.z
	var right   := transform.basis.x
	
	var movement_direction = Vector2(forward.x, forward.z) * input_direction.y + Vector2(right.x, right.z) * input_direction.x
	
	var velocity_xz = movement_direction * MOVEMENT_SPEED # WARNING: This should not be delta dependent (?)
	
	velocity = Vector3(velocity_xz.x, velocity.y, velocity_xz.y)
	
	velocity.y -= PhysicsManager.gravity * delta

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * 0.0)

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var horizontal_rotation : float = event.relative.x * HEAD_HORIZONTAL_ROTATION_SPEED * -1
		var vertical_rotation   : float = event.relative.y *   HEAD_VERTICAL_ROTATION_SPEED * -1
		
		horizontal_rotation = clamp(horizontal_rotation, -MAXIMUM_HEAD_HORIZONTAL_DELTA_ROTATION, MAXIMUM_HEAD_HORIZONTAL_DELTA_ROTATION)
		vertical_rotation   = clamp(  vertical_rotation,   -MAXIMUM_HEAD_VERTICAL_DELTA_ROTATION,   MAXIMUM_HEAD_VERTICAL_DELTA_ROTATION)
		
		rotate_y(horizontal_rotation)
		head_pivot.rotate_x(vertical_rotation)
		head_pivot.rotation.x = clamp(head_pivot.rotation.x, -MAXIMUM_HEAD_VERTICAL_ROTATION, MAXIMUM_HEAD_VERTICAL_ROTATION)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
