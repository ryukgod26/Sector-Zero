class_name CrouchingPlayerState
extends PlayerMovementState

@export var SPEED := 3.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25
@export_range(1,6,0.1) var CROUCH_SPEED := 4.
@onready var crouch_shapecast: ShapeCast3D = $"../../Crouch_Shapecast"

var crouch_released := false

func enter(previous_state) -> void:
	if previous_state.name == "SlidingPlayerState":
		animation_player.current_animation = "Crouch"
		animation_player.seek(1,true)
	else:
		animation_player.play("Crouch",-1,CROUCH_SPEED)

func update(delta: float) -> void:
	
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DEACCELERATION)
	PLAYER.update_velocity()
	
	weapon.sway_weapon(delta,false)

	if Input.is_action_just_released("Crouch"):
		uncrouch()
	
	elif not Input.is_action_pressed("Crouch") and not crouch_released:
		crouch_released = true
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

func exit() -> void:
	crouch_released = false
