extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var vision_ray: RayCast3D = $VisionRay

@export var patrol_points: Array[Node3D] = []
@export var speed_walk := 1.7
@export var speed_run := 3.
@export var attack_range = 2.
@export var investigate_wait_time := 4.
@export var patrol_wait_time := 3.
@export var update_interval := 0.2

const UPDATE_TIME = 0.2
const SPEED = 150
const SMOOTHING_FACTOR = 0.1
const VIEW_ANGLE := 190.

enum EnemyState {IDLE, PATROL, INVESTIGATE, CHASE, ATTACK, RETURN}
var state: EnemyState = EnemyState.IDLE

var target: Node3D
var patrol_index := 0
var patrol_timer := 0.
var investigate_timer := 0.
var update_timer := 0.
var investigate_position: Vector3
var return_position: Vector3
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	target = Globals.player
	_enter_state(EnemyState.IDLE if patrol_points.is_empty() else EnemyState.PATROL)

func _physics_process(delta: float) -> void:
	_update_path(delta)
	
	match state:
		EnemyState.IDLE: _state_idle()
		EnemyState.PATROL: _state_patrol(delta)
		EnemyState.CHASE: _state_chase(delta)
	
	_looking()
	_apply_gravity(delta)
	move_and_slide()

func _can_see_player() -> bool:
	return target and vision_ray.is_colliding() and vision_ray.get_collider() == target

func _looking() -> void:
	if not target:
		return
	
	var to_player = (target.global_transform.origin - global_transform.origin).normalized()
	var forward = -global_transform.basis.z
	var angle_deg = rad_to_deg(acos(clamp(forward.dot(to_player),-1.,1.)))
	if angle_deg > VIEW_ANGLE * .5:
		return
	
	var ray_forward = -vision_ray.global_transform.basis.z
	var new_dir  = ray_forward.slerp(to_player,SMOOTHING_FACTOR).normalized()
	vision_ray.look_at(vision_ray.glo.origin + new_dir,Vector3.UP)

func _got_to_next_patrol_point() -> void:
	patrol_index = (patrol_index + 1) % patrol_points.size()
	navigation_agent.set_target_position(patrol_points[patrol_index].global_transform.origin)

func _move_towards(next_pos: Vector3, speed: float) -> void:
	var dir = (next_pos - global_transform.origin)
	dir.y = 0.
	if is_zero_approx( dir.length() ):
		velocity.x = lerp(velocity.x,0.,SMOOTHING_FACTOR)
		velocity.y = lerp(velocity.y,0.,SMOOTHING_FACTOR)
		return
	
	dir = dir.normalized()
	var current_facing = -global_transform.basis.z
	var new_dir = current_facing.slerp(dir,SMOOTHING_FACTOR).normalized()
	look_at(global_transform.origin + new_dir,Vector3.UP)
	
	velocity.x = dir.x * speed
	velocity.y = dir.y * speed

func _stop_and_idle() -> void:
	velocity = Vector3.ZERO
	animation_player.play("Idle")

func _walk_to(next_pos: Vector3, speed: float) -> void:
	animation_player.play("Walking")
	_move_towards(next_pos,speed)

func _state_idle() -> void:
	if _can_see_player():
		_enter_state(EnemyState.CHASE)

func _state_chase(delta: float) -> void:
	if not target:
		_enter_state(EnemyState.RETURN)
		return
	
	_walk_to(navigation_agent.get_next_path_position(),speed_run)
	
	if global_transform.origin.distance_to(target.global_transform.origin) < attack_range:
		_enter_state(EnemyState.ATTACK)
	elif  not _can_see_player():
		investigate_position = target.global_transform.origin
		_enter_state(EnemyState.INVESTIGATE)

func _update_agent_target() -> void:
	target = Globals.player
	match state:
		EnemyState.PATROL:
			if patrol_points.size() > 0:
				navigation_agent.set_target_position(patrol_points[patrol_index].global_position)
		
		EnemyState.INVESTIGATE:
			navigation_agent.set_target_position(investigate_position)
		EnemyState.CHASE:
			if target:
				navigation_agent.set_target_position(target.global_transform.origin)
		EnemyState.RETURN:
			navigation_agent.set_target_position(return_position)

func _update_path(delta):
	update_timer -= delta
	if update_timer <= 0.0:
		_update_agent_target()
		update_timer = update_interval

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity*delta
	else:
		velocity.y = 0.

func _enter_state(new_state: EnemyState) -> void:
	state = new_state
	match state:
		EnemyState.PATROL:
			patrol_timer = 0
			_got_to_next_patrol_point()

func _state_patrol(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		if patrol_timer < 0.0:
			patrol_timer = patrol_wait_time
			_stop_and_idle()
		else:
			patrol_timer -= delta
			if patrol_timer <= 0.:
				_got_to_next_patrol_point()
	else:
		_walk_to(navigation_agent.get_next_path_position(),speed_walk)
	
	if _can_see_player():
		_enter_state(EnemyState.CHASE)

func _state_attack() -> void:
	velocity = Vector3.ZERO
	animation_player.play("Attack")
	await animation_player.animation_finished
	_enter_state(EnemyState.CHASE)

func _state_investigation(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		if investigate_timer <= 0.:
			investigate_timer = investigate_wait_time
			_stop_and_idle()
		else:
			investigate_timer -= delta
			if investigate_timer <= 0.:
				_enter_state(EnemyState.RETURN)
	else:
		_walk_to(navigation_agent.get_next_path_position(),speed_walk)
	
	if _can_see_player():
		_enter_state(EnemyState.CHASE)
