class_name Player extends CharacterBody3D
## A player.

#region Signals
#endregion Signals

#region Enums
## TODO
enum CrouchingState {
	## TODO
	STANDING,
	## TODO
	CROUCHING_DOWN,
	## TODO
	CROUCHING,
	## TODO
	STANDING_UP
}
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
## TODO
const CROUCH_SPEED : float = 4.5
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
## TODO
var _trying_to_crouch : bool = false
var _crouching_state : CrouchingState = CrouchingState.STANDING
## TODO
var hunger : int = 100:
	set(new_hunger):
		hunger = clampi(new_hunger, 0, 100)
## TODO
var thirst : int = 100:
	set(new_thirst):
		thirst = clampi(new_thirst, 0, 100)
## TODO
var oxygen : int = 100:
	set(new_oxygen):
		oxygen = clampi(new_oxygen, 0, 100)
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var head_pivot : Node3D = %HeadPivot
@onready var head_ray : HittableRay = %HeadRay
@onready var hand : Marker3D = %Hand
@onready var top_head_cast : ShapeCast3D = %TopHeadCast
@onready var animation_player : AnimationPlayer = %AnimationPlayer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	GameManager.player = self
	GameManager.player_hand = hand
	
	head_ray.hit_registered.connect(_on_head_ray_hit_registered)
	head_ray.hit_unregistered.connect(_on_head_ray_hit_unregistered)
	head_ray.pick_registered.connect(_on_head_ray_pick_registered)
	head_ray.pick_unregistered.connect(_on_head_ray_pick_unregistered)
	
	top_head_cast.add_exception(self)
	
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	
	EventsManager.item_consumed.connect(_on_item_consumed)

func _physics_process(delta : float) -> void:
	var input_direction : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")

	var forward := transform.basis.z
	var right   := transform.basis.x
	
	var movement_direction = Vector2(forward.x, forward.z) * input_direction.y + Vector2(right.x, right.z) * input_direction.x
	
	var velocity_xz = movement_direction * MOVEMENT_SPEED # WARNING: This should not be delta dependent (?)
	
	velocity = Vector3(velocity_xz.x, velocity.y, velocity_xz.y)
	
	velocity += get_gravity() * delta

	move_and_slide()

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var horizontal_rotation : float = event.relative.x * HEAD_HORIZONTAL_ROTATION_SPEED * -1
		var vertical_rotation   : float = event.relative.y *   HEAD_VERTICAL_ROTATION_SPEED * -1
		
		horizontal_rotation = clamp(horizontal_rotation, -MAXIMUM_HEAD_HORIZONTAL_DELTA_ROTATION, MAXIMUM_HEAD_HORIZONTAL_DELTA_ROTATION)
		vertical_rotation   = clamp(  vertical_rotation,   -MAXIMUM_HEAD_VERTICAL_DELTA_ROTATION,   MAXIMUM_HEAD_VERTICAL_DELTA_ROTATION)
		
		rotate_y(horizontal_rotation)
		head_pivot.rotate_x(vertical_rotation)
		head_pivot.rotation.x = clamp(head_pivot.rotation.x, -MAXIMUM_HEAD_VERTICAL_ROTATION, MAXIMUM_HEAD_VERTICAL_ROTATION)
	
	if event.is_action_pressed("crouch"):
		_trying_to_crouch = true
		_update_crouching_state()
	elif event.is_action_released("crouch"):
		_trying_to_crouch = false
		_update_crouching_state()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_head_ray_hit_registered(hittable_component : HittableComponent) -> void:
	var hit_event := EventsManager.HitEvent.new(hittable_component)
	EventsManager.hittable_component_hit.emit(hit_event)

func _on_head_ray_hit_unregistered() -> void:
	EventsManager.hittable_component_unhit.emit()

func _on_head_ray_pick_registered() -> void:
	EventsManager.hittable_component_picked.emit()

func _on_head_ray_pick_unregistered() -> void:
	EventsManager.hittable_component_unpicked.emit()

func _on_animation_player_animation_finished(anim_name : StringName) -> void:
	if anim_name == "crouch":
		if _trying_to_crouch:
			_crouching_state = CrouchingState.CROUCHING
		else:
			_crouching_state = CrouchingState.STANDING

func _on_item_consumed(consumption_event : EventsManager.ConsumptionEvent) -> void:
	hunger -= consumption_event.food_points
	thirst -= consumption_event.drink_points
#endregion Callbacks

func _update_crouching_state() -> void:
	if _trying_to_crouch and _crouching_state != CrouchingState.CROUCHING:
		if is_on_floor():
			animation_player.play("crouch", -1, CROUCH_SPEED)
			_crouching_state = CrouchingState.CROUCHING_DOWN
	elif not _trying_to_crouch and _crouching_state != CrouchingState.STANDING:
		if top_head_cast.is_colliding():
			pass
		else:
			animation_player.play("crouch", -1, -CROUCH_SPEED, true)
			_crouching_state = CrouchingState.STANDING_UP
#endregion Private Methods
