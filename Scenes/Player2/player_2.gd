extends CharacterBody3D

@onready var main_camera: Camera3D = %MainCamera


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var camera_rotation = Vector2(0,0)
var mouse_sensitivity = .001

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion:
		var mouse_event = event.relative * mouse_sensitivity
		CameraLook(mouse_event)

func CameraLook(Movement: Vector2):
	camera_rotation += Movement
	camera_rotation.y = clamp(camera_rotation.y,-1.5,1.2 )
	
	transform.basis = Basis()
	main_camera.transform.basis = Basis()
	
	rotate_object_local(Vector3(0,1,0), -camera_rotation.x)
	main_camera.rotate_object_local(Vector3(1,0,0), -camera_rotation.y)
