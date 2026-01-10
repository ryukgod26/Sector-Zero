class_name StateMachine
extends Node

@export var CURRENT_STATE: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("%s is not a State Yet is a Child of State Machine." % child.name)
	await owner.ready
	CURRENT_STATE.enter(null)

func _process(delta: float) -> void:
	CURRENT_STATE.update(delta)


func _physics_process(delta: float) -> void:
	CURRENT_STATE.physics_update(delta)
	Globals.debug.add_property("State",CURRENT_STATE.name,1)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name.to_lower())
	
	if new_state != null:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter(CURRENT_STATE)
			CURRENT_STATE = new_state
	else:
		push_warning("State: %s Does Not Exist." % new_state.name)
