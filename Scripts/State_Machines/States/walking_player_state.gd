class_name WalkingPlayerState
extends State

@export var animation_player:AnimationPlayer
@export var top_animation_speed:= 2.2

func update(delta: float) -> void:
	set_anim_speed(Globals.player.velocity.length())
	if Globals.player.velocity.length() == 0:
		transition.emit("IdlePlayerState")

func enter() -> void:
	animation_player.play("walking",-1,1.)

func set_anim_speed(val):
	var alpha = remap(val,0,Globals.player.DEFAULT_SPEED,0.0,1.0)
	animation_player.speed_scale = lerp(0.0,top_animation_speed,alpha)
