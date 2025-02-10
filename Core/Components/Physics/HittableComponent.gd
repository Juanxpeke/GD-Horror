class_name HittableComponent extends Node
## A component that can make a [CollisionObject3D] detectable by the [Player]'s camera ray.
##
## [HittableComponent] is very cool.

#region Signals
## Emitted when the ray starts colliding with [member collision_object].
signal focused
## Emitted when the ray stops colliding with [member collision_object].
signal unfocused
## Emitted when [member collision_object] is interacted with.
## Requires [member interactable] to be set to [code]true[/code].
## See also [member interactable].
signal interacted
## Emitted when [member collision_object] is picked.
## Requires [member pickable] to be set to [code]true[/code].
## See also [member pickable].
signal picked
## Emitted when [member collision_object] is unpicked.
## Requires [member pickable] to be set to [code]true[/code].
## See also [member pickable].
signal unpicked
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## See also [member pickable].
const INITIAL_DRAG_SPEED : float = 18.0
## See also [member pickable].
const MAXIMUM_DRAG_SPEED : float = 40.0
## See also [member pickable].
const MAXIMUM_COLLIDING_DRAG_SPEED : float = 2.5
## See also [member pickable].
const MAXIMUM_DRAG_DISTANCE : float = 1.6
## Time that has to pass in order for [member collision_object] [member RigidBody3D.can_sleep] variable
## to be restored to its initial value after being unpicked.
## See also [member pickable].
const CAN_SLEEP_RESTORATION_TIME : float = 1.0
#endregion Constants

#region Exports Variables
## [CollisionObject3D] that will be put in the ray's layer in order to be detected.
@export var collision_object : CollisionObject3D
## [MeshInstance3D] that visually represents [member collision_object].
@export var mesh_instance : MeshInstance3D

@export_group("Interaction")
## If [code]true[/code], [member collision_object] can be interacted with when the action
## [code]"interact"[/code] is pressed.
@export var interactable : bool = false
## Name that can be shown as a hint while [member being_hit].
@export var interaction_name : String = ""
## Default sound that will be played when [member collision_object] is interacted with.
## For more advanced behaviour, use [signal interacted].
@export var interact_sound : AudioStream

@export_group("Picking")
## If [code]true[/code], [member collision_object] will follow the player's hand while the action
## [code]"pick"[/code] is being pressed.
## Requires [member collision_object] to be an instance of [RigidBody3D].
## [b]Note:[/b] At the moment [member collision_object] is picked, its variable [member RigidBody3D.can_sleep]
## value is set to [code]true[/code] automatically, and is restored after [constant CAN_SLEEP_RESTORATION_TIME]
## seconds.
@export var pickable : bool = false
## Default sound that will be played when [member collision_object] is picked.
## For more advanced behaviour, use [signal picked]. 
@export var pick_sound : AudioStream
## Default sound that will be played when [member collision_object] is picked.
## For more advanced behaviour, use [signal unpicked].
@export var unpick_sound : AudioStream
#endregion Exports Variables

#region Static Variables
## If [code]true[/code], there is at least one instance of [HittableComponent] being picked.
## See also [member being_picked].
static var picking : bool = false
#endregion Static Variables

#region Public Variables
## If [code]true[/code], [member collision_object] is being hit by the ray in the current frame.
## [b]Note:[/b] This variable must not be modified.
var being_hit : bool = false
## If [code]true[/code], [member collision_object] is being picked.
## See also [member pickable].
## [b]Note:[/b] This variable must not be modified.
var being_picked : bool = false
#endregion Public Variables

#region Private Variables
var _player_pick_initial_rotation      : float = 0.0
var _object_pick_initial_rotation      : float = 0.0
var _object_pick_initial_angle_to_hand : float = 0.0
var _object_pick_initial_can_sleep     : bool  = true

var _waiting_to_restore_object_can_sleep_state : bool = false
var _object_unpicked_time : float = 0.0
#endregion Private Variables

#region On Ready Variables
@onready var highlight_material : Material = preload("res://Core/Components/HighlightMaterial.tres")
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_force_collision_object_state()
	_assert_collision_object_state()
	
	collision_object.collision_layer |= PhysicsManager.CollisionLayer.CAMERA_RAY
	collision_object.set_meta("HittableComponentPath", collision_object.get_path_to(self, true))
	
	tree_exited.connect(_on_tree_exited)

func _physics_process(delta : float) -> void:
	if being_picked:
		var object : RigidBody3D = collision_object as RigidBody3D
		
		var object_pos := object.global_transform.origin
		var hand_pos := GameManager.player_hand.global_transform.origin
		
		var drag_vector := hand_pos - object_pos
		var drag_length := drag_vector.length()
		
		# If the object is too far, it must be dropped
		if drag_length > MAXIMUM_DRAG_DISTANCE:
			object.set_linear_velocity(Vector3.ZERO)
			unpick_object()
		# If not, it should be dragged to the player's hand
		else:
			var drag_direction := drag_vector / drag_length
			
			# The drag speed depends on the object's mass and its distance
			var mass_factor     : float = min(1.0 / object.mass, 1.0)
			var distance_factor : float = drag_length
			
			var drag_speed := distance_factor * mass_factor * INITIAL_DRAG_SPEED
			
			# If object is colliding, reduce drag speed so it doesn't push heavy objects so easily
			if object.get_contact_count() > 0:
				drag_speed /= 1 # TODO: Solve this, dividing the speed entirely causes a bug in which
								#       heavy objects can't be lifted
			
			drag_speed = min(drag_speed, MAXIMUM_DRAG_SPEED)
			
			object.set_linear_velocity(drag_direction * drag_speed)
			
			# Maintain object's rotation relative to the player
			var object_vector := object_pos - GameManager.player.global_transform.origin
			var hand_vector   :=   hand_pos - GameManager.player.global_transform.origin
			
			var object_vector_xz := Vector2(object_vector.x, object_vector.z)
			var hand_vector_xz   := Vector2(  hand_vector.x,   hand_vector.z)
			
			var object_angle_to_hand := object_vector_xz.angle_to(hand_vector_xz) 
			
			var object_front_rotation = _object_pick_initial_rotation + (GameManager.player.rotation.y - _player_pick_initial_rotation)
			
			object.rotation.y = object_front_rotation + (object_angle_to_hand - _object_pick_initial_angle_to_hand)
	else:
		if _waiting_to_restore_object_can_sleep_state:
			_object_unpicked_time += delta
			
			if _object_unpicked_time > CAN_SLEEP_RESTORATION_TIME:
				var object : RigidBody3D = collision_object as RigidBody3D
				object.can_sleep = _object_pick_initial_can_sleep
				
				_waiting_to_restore_object_can_sleep_state = false
				_object_unpicked_time = 0.0
				
				LogManager.physics_log("Restoring %s can_sleep value to %s" % [object.name, object.can_sleep])

func _input(event: InputEvent) -> void:
	if being_hit:
		if interactable and event.is_action_pressed("interact"):
			if interact_sound:
				AudioManager.play_sound(interact_sound)
			interacted.emit()
		
		if pickable and not picking and event.is_action_pressed("pick_item"):
			pick_object()
			
	if being_picked and event.is_action_released("pick_item"):
		unpick_object()
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func register_hit() -> void:
	being_hit = true
	
	if mesh_instance:
		mesh_instance.material_overlay = highlight_material
	
	LogManager.physics_log("HittableComponent hit registered")
	
	focused.emit()
## TODO
func unregister_hit() -> void:
	being_hit = false
	
	if mesh_instance:
		mesh_instance.material_overlay = null
	
	LogManager.physics_log("HittableComponent hit unregistered")
	
	unfocused.emit()
## TODO
func pick_object() -> void:
	being_picked = true
	picking = true
	
	var object : RigidBody3D = collision_object as RigidBody3D
	
	var object_vector :=                  object.global_transform.origin - GameManager.player.global_transform.origin
	var hand_vector   := GameManager.player_hand.global_transform.origin - GameManager.player.global_transform.origin
	
	var object_vector_xz := Vector2(object_vector.x, object_vector.z)
	var hand_vector_xz   := Vector2(  hand_vector.x,   hand_vector.z)
	
	_player_pick_initial_rotation      = GameManager.player.rotation.y
	_object_pick_initial_rotation      = object.rotation.y
	_object_pick_initial_angle_to_hand = object_vector_xz.angle_to(hand_vector_xz)
	
	if not _waiting_to_restore_object_can_sleep_state:
		_object_pick_initial_can_sleep = object.can_sleep
	_waiting_to_restore_object_can_sleep_state = false
	
	object.can_sleep = false
	object.lock_rotation = true
	object.add_collision_exception_with(GameManager.player)

	mesh_instance.material_overlay = null
	
	if pick_sound:
		AudioManager.play_sound(pick_sound)
	
	LogManager.physics_log("HittableComponent picked")
	
	picked.emit()
## TODO
func unpick_object() -> void:
	being_picked = false
	picking = false
	
	var object : RigidBody3D = collision_object as RigidBody3D
	
	_waiting_to_restore_object_can_sleep_state = true
	_object_unpicked_time = 0.0
	
	object.lock_rotation = false
	object.remove_collision_exception_with(GameManager.player)
	
	if being_hit:
		mesh_instance.material_overlay = highlight_material
	
	if unpick_sound:
		AudioManager.play_sound(unpick_sound)
	
	LogManager.physics_log("HittableComponent unpicked")
	
	unpicked.emit()
#endregion Public Methods

#region Private Methods
#region Assertions
func _force_collision_object_state() -> void:
	if pickable and collision_object.max_contacts_reported == 0:
		collision_object.contact_monitor = true
		collision_object.max_contacts_reported = 1

func _assert_collision_object_state() -> void:
	assert(collision_object)
	assert(not (collision_object.collision_layer & PhysicsManager.CollisionLayer.CAMERA_RAY))
	
	if pickable:
		assert(collision_object is RigidBody3D)
		# NOTE: This is necessary for collision detection
		#       (https://docs.godotengine.org/en/stable/classes/class_rigidbody3d.html#class-rigidbody3d-method-get-colliding-bodies)
		assert(collision_object.contact_monitor)
		assert(collision_object.max_contacts_reported > 0)
#endregion Assertions
#region Callbacks
func _on_tree_exited() -> void:
	if being_picked:
		being_picked = false
		picking = false
#endregion Callbacks
#endregion Private Methods
