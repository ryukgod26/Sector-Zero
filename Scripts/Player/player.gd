extends CharacterBody3D

const JUMP_VELOCITY = 4.5

@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25
@export var DEFAULT_SPEED := 5.
@export var CROUCH_SPEED := 2.
@export var SPRINT_SPEED := 7.
@export var TILT_LOWER_LIMIT := deg_to_rad(-90)
@export var TILT_UPPER_LIMIT := deg_to_rad(90)
@export var CAMERA_CONTROLLER: Camera3D
@export var MOUSE_SENSTIVITY: float = 0.5
@export var TOGGLE_CROUCH := true
@export_range(5,10,0.1) var CROUCH_ANIM_SPEED := 7.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var crouch_shapecast: ShapeCast3D = $Crouch_Shapecast

var _speed: float
var _mouse_input := false
var _rotation_input: float
var _tilt_input: float
var _mouse_rotation:Vector3
var _player_rotation: Vector3
var _camera_rotation: Vector3

var is_crouching := false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	crouch_shapecast.add_exception($".")
	_speed = DEFAULT_SPEED
	Globals.player = self

func _physics_process(delta: float) -> void:
	
	Globals.debug.add_property("Movement Speed",_speed,1)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	_update_camera(delta)
	if Input.is_action_just_pressed("Jump") and is_on_floor() and not is_crouching:
		velocity.y += JUMP_VELOCITY
	
	var input_dir = Input.get_vector("move_left","move_right","move_forward","move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * _speed,ACCELERATION)
		velocity.z = lerp(velocity.z,direction.z * _speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0 , DEACCELERATION)
		velocity.z = move_toward(velocity.z, 0 , DEACCELERATION)
	 
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Crouch") and is_on_floor() and TOGGLE_CROUCH:
		toggle_crouch()
	
	if event.is_action_pressed("Crouch") and not is_crouching and is_on_floor() and not TOGGLE_CROUCH:
		crouching(true)
	
	if event.is_action_released("Crouch") and not TOGGLE_CROUCH:
		if not crouch_shapecast.is_colliding():
			crouching(false)
		
		elif crouch_shapecast.is_colliding():
			uncrouch_check()

func _update_camera(delta):
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x,TILT_LOWER_LIMIT,TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0,_mouse_rotation.y,0)
	_camera_rotation = Vector3(_mouse_rotation.x,0,0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0


func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSTIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSTIVITY
		#print(Vector2(_rotation_input,_tilt_input))

func toggle_crouch():
	if is_crouching and not crouch_shapecast.is_colliding():
		print("UnCrouching") 
		crouching(true)
	elif not is_crouching:
		crouching(false)
		print("Crouching")

func crouching(state: bool):
	if state:
		animation_player.play("Crouch",0,CROUCH_ANIM_SPEED)
		set_movement_speed("crouching")
	else:
		animation_player.play("Crouch",0,-CROUCH_ANIM_SPEED,1)
		set_movement_speed("default")

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "Crouch":
		is_crouching = not is_crouching

func uncrouch_check():
	if not crouch_shapecast.is_colliding():
		crouching(false)
	if crouch_shapecast.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch_check()

func set_movement_speed(state: String):
	state = state.to_lower()
	match state:
		"default":
			_speed = DEFAULT_SPEED
		"crouching":
			_speed = CROUCH_SPEED
