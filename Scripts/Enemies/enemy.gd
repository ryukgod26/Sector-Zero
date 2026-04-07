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
	pass

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

func update_agent_target() -> void:
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
