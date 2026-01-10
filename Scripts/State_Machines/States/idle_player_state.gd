class_name  IdlePlayerState
extends PlayerMovementState

@export var SPEED := 5.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DEACCELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("Crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if Globals.player.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("Jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.y < -3 and not PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")

func enter(_previous_state) -> void:
	if animation_player.is_playing() and animation_player.current_animation == "JumpEnd":
		await animation_player.animation_finished
	animation_player.pause()
