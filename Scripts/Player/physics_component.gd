extends Node

@export var character: CharacterBody3D
@export_range(0.,500.,0.1) var force := 100.
@export var enabled := false

func _physics_process(_delta: float) -> void:
	if enabled and character.get_slide_collision_count() > 0:
		var collision = character.get_last_slide_collision()
		if collision.get_collider() is RigidBody3D:
			var direction = -collision.get_normal()
			var speed = clamp(character.velocity.length(),1.,10.)
			var impulse_pos = collision.get_position() - collision.get_collider().global_position
			collision.get_collider().apply_impulse(direction * speed * force, impulse_pos)
