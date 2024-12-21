class_name HittableComponent extends Node
## A component that can be hit by the [Player] camera ray.

#region Signals
## TODO
signal focused
## TODO
signal unfocused
## TODO
signal interacted
## TODO
signal picked
## TODO
signal unpicked
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const INITIAL_DRAG_SPEED : float = 18.0
## TODO
const MAXIMUM_DRAG_SPEED : float = 40.0
## TODO
const MAXIMUM_COLLIDING_DRAG_SPEED : float = 2.5
## TODO
const MAXIMUM_DRAG_DISTANCE : float = 1.6
#endregion Constants

#region Exports Variables
## TODO
@export var collision_object : CollisionObject3D
## TODO
@export var mesh : MeshInstance3D
## TODO
@export var interactable : bool = false
## TODO
@export var pickable : bool = false
#endregion Exports Variables

#region Static Variables
## TODO
static var picking : bool = false
#endregion Static Variables

#region Public Variables
## TODO
var being_hit : bool = false
## TODO
var being_picked : bool = false
#endregion Public Variables

#region Private Variables
var _object_pick_initial_rotation : float = 0.0
var _player_pick_initial_rotation : float = 0.0
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
			
			
			# If object is not colliding, maintain its rotation relative to the player
			if object.get_contact_count() == 0:
				var object_vector := object_pos - GameManager.player.global_transform.origin
				var hand_vector   :=   hand_pos - GameManager.player.global_transform.origin
				
				var object_vector_xz := Vector2(object_vector.x, object_vector.z)
				var hand_vector_xz   := Vector2(  hand_vector.x,   hand_vector.z)
				
				var object_angle_to_hand := object_vector_xz.angle_to(hand_vector_xz) 
				
				var object_front_rotation = _object_pick_initial_rotation + (GameManager.player.rotation.y - _player_pick_initial_rotation)
				
				object.rotation.y = object_front_rotation + object_angle_to_hand
			# If it is colliding, reduce drag speed so it doesn't push heavy objects so easily
			else:
				drag_speed /= 1
			
			drag_speed = min(drag_speed, MAXIMUM_DRAG_SPEED)
			
			object.set_linear_velocity(drag_direction * drag_speed)

func _input(event: InputEvent) -> void:
	if being_hit:
		if interactable and event.is_action_pressed("interact"):
			interacted.emit()
		
		if pickable and not picking and event.is_action_pressed("pick_item"):
			pick_object()
			
	if being_picked and event.is_action_released("pick_item"):
		unpick_object()
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func register_hit() -> void:
	focused.emit()
	being_hit = true
	
	if mesh:
		mesh.material_overlay = highlight_material
	
	LogManager.physics_log("HittableComponent hit registered")
## TODO
func unregister_hit() -> void:
	unfocused.emit()
	being_hit = false
	
	if mesh:
		mesh.material_overlay = null
	
	LogManager.physics_log("HittableComponent hit unregistered")
## TODO
func pick_object() -> void:
	picked.emit()
	being_picked = true
	picking = true
	
	collision_object.lock_rotation = true
	collision_object.collision_layer &= ~PhysicsManager.CollisionLayer.PLAYER_WORLD
	
	mesh.material_overlay = null
	
	_object_pick_initial_rotation = collision_object.rotation.y
	_player_pick_initial_rotation = GameManager.player.rotation.y
## TODO
func unpick_object() -> void:
	unpicked.emit()
	being_picked = false
	picking = false
	
	collision_object.lock_rotation = false
	collision_object.collision_layer |= PhysicsManager.CollisionLayer.PLAYER_WORLD
	
	if being_hit:
		mesh.material_overlay = highlight_material
#endregion Public Methods

#region Private Methods
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
#endregion Private Methods
