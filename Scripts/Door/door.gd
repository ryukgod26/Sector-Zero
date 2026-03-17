class_name DoorComponent
extends Node

enum DoorType {Sliding, Rotating}
enum ForwardDirection {X,Y,Z}

@export_group("Door Settings")
@export var door_type: DoorType
@export var forward_direction: ForwardDirection
@export var move_dir: Vector3
@export var rotation := Vector3(0,1,0)
@export var rotation_amount := 90.
@export var door_size: Vector3
@export var close_time := 2.0
@export_group("Tween Setings")
@export var speed := 0.5
@export var transition_type: Tween.TransitionType
@export var easing: Tween.EaseType

var parent
var orig_pos: Vector3
var orig_rot: Vector3
var door_direction: Vector3
var rotation_adjustment: float

func _ready() -> void:
	parent = get_parent()
	orig_pos = parent.position
	orig_rot = parent.rotation
	parent.ready.connect(connect_parent)

func connect_parent():
	parent.connect("interacted",Callable(self,"open_door"))

func open_door() -> void:
	var tween = create_tween()
	match door_type:
		DoorType.Sliding:
			tween.tween_property(parent,"position",orig_pos + (move_dir * door_size),speed).set_trans(transition_type).set_ease(easing)
		DoorType.Rotating:
			#tween.tween_property(parent,"position",orig_pos + (move_dir * door_size),speed).set_trans(transition_type).set_ease(easing)
			tween.tween_property(parent,"rotation",orig_rot + (rotation * rotation_adjustment * deg_to_rad(rotation_amount)),speed).set_trans(transition_type).set_ease(easing)
	tween.tween_interval(close_time)
	tween.tween_callback(close_door)

func close_door() -> void:
	var tween = create_tween()
	match door_type:
		DoorType.Sliding:
			tween.tween_property(parent,"position",orig_pos,speed).set_trans(transition_type).set_ease(easing)
		DoorType.Rotating:
			tween.tween_property(parent,"rotation",orig_rot,speed).set_trans(transition_type).set_ease(easing)

func check_door() -> void:
	match forward_direction:
		ForwardDirection.X:
			door_direction = parent.global_transform.basis.x
		ForwardDirection.Y:
			door_direction = parent.global_transform.basis.y
		ForwardDirection.Z:
			door_direction = parent.global_transform.basis.z
	
	var door_pos: Vector3 = parent.global_position
	var player_pos := Globals.player.global_position
	var dir_to_player := door_pos.direction_to(player_pos)
	var door_dot := dir_to_player.dot(door_direction)
	if door_dot < 0:
		rotation_adjustment = -1
	else:
		rotation_adjustment = 1
	open_door()
