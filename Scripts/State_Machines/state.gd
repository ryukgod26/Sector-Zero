class_name  State
extends Node

@warning_ignore("unused_signal")
signal transition(new_state: String)

@warning_ignore("unused_parameter")
func enter(previous_state) -> void:
	pass

func exit() -> void:
	pass

@warning_ignore("unused_parameter")
func update(delta: float) -> void:
	pass
	
@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	pass
