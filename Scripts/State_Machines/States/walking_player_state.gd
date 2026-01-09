class_name WalkingPlayerState
extends PlayerMovementState

@export var SPEED := 5.
@export var ACCELERATION := 0.1
@export var DEACCELERATION := 0.25
@export var max_animation_speed:= 2.2

func enter() -> void:
	animation_player.play("walking",-1,1.)
	Globals.player._speed = Globals.player.DEFAULT_SPEED

func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DEACCELERATION)
	PLAYER.update_velocity()
	set_anim_speed(Globals.player.velocity.length())
	if Globals.player.velocity.length() == 0:
		transition.emit("IdlePlayerState")

func set_anim_speed(val):
	var alpha = remap(val,0,Globals.player.DEFAULT_SPEED,0.0,1.0)
	animation_player.speed_scale = lerp(0.0,max_animation_speed,alpha)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Sprint") and Globals.player.is_on_floor():
		transition.emit("SprintingPlayerState")
