class_name CrouchingPlayerState
extends PlayerMovementState

@export var SPEED := 3.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25
@export_range(1,6,0.1) var CROUCH_SPEED := 4.
@onready var crouch_shapecast: ShapeCast3D = $"../../Crouch_Shapecast"

func enter() -> void:
	animation_player.play("Crouch",-1,CROUCH_SPEED)

func update(delta: float) -> void:
	
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DEACCELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_released("Crouch"):
		uncrouch()
		
func uncrouch():
	if not crouch_shapecast.is_colliding() and not Input.is_action_just_pressed("Crouch"):
		animation_player.play("Crouch",-1,-CROUCH_SPEED,true)
		if animation_player.is_playing():
			await animation_player.animation_finished
		transition.emit("IdlePlayerState")
	elif crouch_shapecast.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()
