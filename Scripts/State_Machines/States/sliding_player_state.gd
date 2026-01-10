class_name SlidingPlayerState
extends PlayerMovementState

@export var SPEED := 6.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25
@export var max_animation_speed := 2.2
@export var tilt_amount := 0.09
@export_range(1,6,0.1) var slide_anim_speed := 4.

func enter(previous_state) -> void:
	set_tilt(PLAYER._current_rotation)
	animation_player.get_animation("Sliding").track_set_key_value(5,0,PLAYER.velocity.length())
	animation_player.speed_scale = 1.
	animation_player.play("Sliding",-1,slide_anim_speed)

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_velocity()

func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	tilt.z = clamp(tilt_amount * player_rotation,-0.1,0.1)
	if tilt.z == 0:
		tilt.z = .05
	animation_player.get_animation("Sliding").track_set_key_value(1,1,tilt)
	animation_player.get_animation("Sliding").track_set_key_value(1,2,tilt)
	#print(animation_player.get_animation("Sliding").track_get_path(5))
	#print(animation_player.get_animation("Sliding").track_get_path(1))

func finish():
	transition.emit("CrouchingPlayerState")
