class_name WalkingPlayerState
extends PlayerMovementState

@export var SPEED := 5.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25
@export var max_animation_speed:= 2.2

func enter(_previous_state) -> void:
	if animation_player.is_playing() and animation_player.current_animation == "JumpEnd":
		await animation_player.animation_finished
	animation_player.play("walking",-1,1.)
	Globals.player._speed = Globals.player.DEFAULT_SPEED

func exit() -> void:
	animation_player.speed_scale = 1

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DEACCELERATION)
	PLAYER.update_velocity()
	set_anim_speed(PLAYER.velocity.length())
	
	weapon.sway_weapon(delta, false)
	
	if Input.is_action_just_pressed("Crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if Input.is_action_just_pressed("Jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("Sprint") and PLAYER.is_on_floor():
		transition.emit("SprintingPlayerState")
	
	if PLAYER.velocity.y < -3 and not PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")


func set_anim_speed(val):
	var alpha = remap(val,0,Globals.player.DEFAULT_SPEED,0.0,1.0)
	animation_player.speed_scale = lerp(0.0,max_animation_speed,alpha)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("Sprint") and Globals.player.is_on_floor():
		#transition.emit("SprintingPlayerState")
