class_name SprintingPlayerState
extends State

@export var animation_player: AnimationPlayer
@export var max_animation_speed := 1.6

func enter() -> void:
	animation_player.play("Sprinting",0.5,1.0)
	Globals.player._speed = Globals.player.SPRINT_SPEED

func update(delta: float) -> void:
	set_anim_speed(Globals.player.velocity.length())


func set_anim_speed(val):
	var alpha = remap(val,0,Globals.player.SPRINT_SPEED,0.0,1.0)
	animation_player.speed_scale = lerp(0.0,max_animation_speed,alpha)

func _input(event: InputEvent) -> void:
	if event.is_action_released("Sprint") and Globals.player.is_on_floor():
		transition.emit("WalkingPlayerState")
