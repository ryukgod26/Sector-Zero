class_name SprintingPlayerState
extends PlayerMovementState

@export var SPEED := 7.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25
@export var max_animation_speed := 1.6

func enter(_previous_state) -> void:
	animation_player.play("Sprinting",0.5,1.0)

func exit() -> void:
	animation_player.speed_scale = 1

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DEACCELERATION)
	PLAYER.update_velocity()
	
	if (Input.is_action_just_released("Sprint") and PLAYER.is_on_floor()) or PLAYER.velocity.length() == 0 :
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("Crouch") and PLAYER.is_on_floor() and PLAYER.velocity.length() > 6:
		transition.emit("SlidingPlayerState")
	
	set_anim_speed(Globals.player.velocity.length())

func set_anim_speed(val):
	var alpha = remap(val,0,SPEED,0.0,1.0)
	animation_player.speed_scale = lerp(0.0,max_animation_speed,alpha)
